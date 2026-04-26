import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../achievements/badge_catalog.dart';
import '../stories/story_catalog.dart';

enum AudioSourceType { story, sleep }

class StoryLibraryItem {
  const StoryLibraryItem({
    required this.storyId,
    required this.title,
    required this.imagePath,
    required this.currentPage,
    required this.totalPages,
    required this.isFavorite,
    required this.isCompleted,
    required this.lastUpdatedMillis,
  });

  final String storyId;
  final String title;
  final String imagePath;
  final int currentPage;
  final int totalPages;
  final bool isFavorite;
  final bool isCompleted;
  final int lastUpdatedMillis;

  double get progress =>
      totalPages <= 0 ? 0 : (currentPage / totalPages).clamp(0, 1);
  bool get hasProgress => currentPage > 0;

  StoryLibraryItem copyWith({
    String? title,
    String? imagePath,
    int? currentPage,
    int? totalPages,
    bool? isFavorite,
    bool? isCompleted,
    int? lastUpdatedMillis,
  }) {
    return StoryLibraryItem(
      storyId: storyId,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isFavorite: isFavorite ?? this.isFavorite,
      isCompleted: isCompleted ?? this.isCompleted,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'title': title,
      'imagePath': imagePath,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'isFavorite': isFavorite,
      'isCompleted': isCompleted,
      'lastUpdatedMillis': lastUpdatedMillis,
    };
  }

  factory StoryLibraryItem.fromJson(Map<String, dynamic> json) {
    return StoryLibraryItem(
      storyId: json['storyId'] as String,
      title:
          json['title'] as String? ??
          storyTitleFromId(json['storyId'] as String),
      imagePath: json['imagePath'] as String? ?? defaultStoryImagePath,
      currentPage: (json['currentPage'] as num? ?? 0).toInt(),
      totalPages: (json['totalPages'] as num? ?? 5).toInt(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      lastUpdatedMillis: (json['lastUpdatedMillis'] as num? ?? 0).toInt(),
    );
  }
}

class AppState extends ChangeNotifier {
  AppState() {
    unawaited(_initialize());
  }

  static const _prefsProfileIdKey = 'app_state.profile_id';
  static const _prefsLibraryKey = 'app_state.library_json';
  static const _prefsLanguageKey = 'app_state.language_code';
  static const _prefsAppRatingKey = 'app_state.app_rating';
  static const _prefsFeedbackMessageKey = 'app_state.feedback_message';
  static const _prefsFeedbackAtKey = 'app_state.feedback_at';

  bool _hasSession = false;
  bool _onboardingComplete = false;
  bool _isPremium = false;
  bool _isLibraryReady = false;
  String _userName = '';
  String _avatar = 'prenses';
  String _languageCode = 'tr';
  String? _activeAudioTitle;
  AudioSourceType? _activeAudioType;
  String? _profileId;
  String? _lastFeedbackMessage;
  int? _lastFeedbackAtMillis;
  int _appRating = 0;

  SharedPreferences? _prefs;
  FirebaseFirestore? _firestore;
  final Map<String, StoryLibraryItem> _libraryItems =
      <String, StoryLibraryItem>{};
  final Set<String> _unlockedBadgeIds = <String>{};
  final Set<String> _activityDateKeys = <String>{};
  final List<String> _badgeCelebrationQueue = <String>[];
  int _sleepListenCount = 0;

  bool get hasSession => _hasSession;
  bool get onboardingComplete => _onboardingComplete;
  bool get isPremium => _isPremium;
  bool get isLibraryReady => _isLibraryReady;
  String get userName => _userName;
  String get avatar => _avatar;
  String get languageCode => _languageCode;
  bool get isEnglish => _languageCode == 'en';
  String? get activeAudioTitle => _activeAudioTitle;
  AudioSourceType? get activeAudioType => _activeAudioType;
  bool get hasActiveAudio => _activeAudioTitle != null;
  String? get lastFeedbackMessage => _lastFeedbackMessage;
  int? get lastFeedbackAtMillis => _lastFeedbackAtMillis;
  int get appRating => _appRating;
  int get unlockedBadgeCount => _unlockedBadgeIds.length;
  Set<String> get unlockedBadgeIds =>
      Set<String>.unmodifiable(_unlockedBadgeIds);
  BadgeDefinition? get activeBadgeCelebration => _badgeCelebrationQueue.isEmpty
      ? null
      : badgeDefinitionById(_badgeCelebrationQueue.first);
  Set<String> get favorites => _libraryItems.values
      .where((item) => item.isFavorite)
      .map((item) => item.storyId)
      .toSet();
  Map<String, int> get readingProgress => {
    for (final item in _libraryItems.values)
      if (item.hasProgress) item.storyId: item.currentPage,
  };
  List<StoryLibraryItem> get readingListStories =>
      _sortedItems(_libraryItems.values.where((item) => item.hasProgress));
  List<StoryLibraryItem> get favoriteStories =>
      _sortedItems(_libraryItems.values.where((item) => item.isFavorite));
  List<StoryLibraryItem> get completedStories =>
      _sortedItems(_libraryItems.values.where((item) => item.isCompleted));
  List<StoryLibraryItem> get activeReadingStories => _sortedItems(
    _libraryItems.values.where((item) => item.hasProgress && !item.isCompleted),
  );
  StoryLibraryItem? get currentReadingStory =>
      activeReadingStories.isEmpty ? null : activeReadingStories.first;

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _profileId = _prefs!.getString(_prefsProfileIdKey) ?? _generateProfileId();
    await _prefs!.setString(_prefsProfileIdKey, _profileId!);

    _loadLocalState();

    if (Firebase.apps.isNotEmpty) {
      try {
        _firestore = FirebaseFirestore.instance;
        await _loadRemoteState();
      } catch (_) {
        // Keep local persistence working if Firestore is unavailable.
      }
    }

    final changed = _evaluateBadges(announce: false);
    if (changed) {
      await _persistLibrary();
    }

    _isLibraryReady = true;
    notifyListeners();
  }

  String _generateProfileId() {
    final random = Random.secure();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    final suffix = List.generate(
      8,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    return 'profile_$timestamp$suffix';
  }

  void _loadLocalState() {
    _languageCode = _prefs?.getString(_prefsLanguageKey) ?? _languageCode;
    _appRating = (_prefs?.getInt(_prefsAppRatingKey) ?? 0).clamp(0, 5).toInt();
    _lastFeedbackMessage = _prefs?.getString(_prefsFeedbackMessageKey);
    _lastFeedbackAtMillis = _prefs?.getInt(_prefsFeedbackAtKey);

    final encoded = _prefs?.getString(_prefsLibraryKey);
    if (encoded == null || encoded.isEmpty) return;

    final decoded = jsonDecode(encoded) as Map<String, dynamic>;
    final stories = decoded['stories'] as Map<String, dynamic>? ?? const {};
    final badgeState =
        decoded['badgeState'] as Map<String, dynamic>? ?? const {};

    _libraryItems
      ..clear()
      ..addEntries(
        stories.entries.map(
          (entry) => MapEntry(
            entry.key,
            StoryLibraryItem.fromJson(
              Map<String, dynamic>.from(entry.value as Map),
            ),
          ),
        ),
      );

    _unlockedBadgeIds
      ..clear()
      ..addAll(
        ((badgeState['unlockedBadgeIds'] as List?) ?? const []).map(
          (item) => item.toString(),
        ),
      );
    _activityDateKeys
      ..clear()
      ..addAll(
        ((badgeState['activityDateKeys'] as List?) ?? const []).map(
          (item) => item.toString(),
        ),
      );
    _sleepListenCount = (badgeState['sleepListenCount'] as num? ?? 0).toInt();
  }

  Future<void> _loadRemoteState() async {
    final snapshot = await _firestore!
        .collection('library_profiles')
        .doc(_profileId)
        .get();
    if (!snapshot.exists) {
      await _persistLibrary();
      return;
    }

    final data = snapshot.data() ?? const {};
    final stories = data['stories'] as Map<String, dynamic>? ?? const {};
    final remoteItems = stories.map(
      (key, value) => MapEntry(
        key,
        StoryLibraryItem.fromJson(Map<String, dynamic>.from(value as Map)),
      ),
    );

    for (final entry in remoteItems.entries) {
      final local = _libraryItems[entry.key];
      if (local == null ||
          entry.value.lastUpdatedMillis >= local.lastUpdatedMillis) {
        _libraryItems[entry.key] = entry.value;
      }
    }

    final remoteBadgeState =
        data['badgeState'] as Map<String, dynamic>? ?? const {};
    _unlockedBadgeIds.addAll(
      ((remoteBadgeState['unlockedBadgeIds'] as List?) ?? const []).map(
        (item) => item.toString(),
      ),
    );
    _activityDateKeys.addAll(
      ((remoteBadgeState['activityDateKeys'] as List?) ?? const []).map(
        (item) => item.toString(),
      ),
    );
    _sleepListenCount = max(
      _sleepListenCount,
      (remoteBadgeState['sleepListenCount'] as num? ?? 0).toInt(),
    );

    await _saveLocalState();
  }

  List<StoryLibraryItem> _sortedItems(Iterable<StoryLibraryItem> items) {
    final list = items.toList();
    list.sort((a, b) => b.lastUpdatedMillis.compareTo(a.lastUpdatedMillis));
    return list;
  }

  StoryLibraryItem _entryFor(
    String storyId, {
    StoryCatalogEntry? catalogEntry,
  }) {
    final entry = catalogEntry ?? storyCatalogEntryFor(storyId);
    return _libraryItems[storyId] ??
        StoryLibraryItem(
          storyId: storyId,
          title: entry.title,
          imagePath: entry.imagePath,
          currentPage: 0,
          totalPages: entry.totalPages,
          isFavorite: false,
          isCompleted: false,
          lastUpdatedMillis: 0,
        );
  }

  Future<void> _saveLocalState() async {
    await _prefs?.setString(_prefsLanguageKey, _languageCode);
    await _prefs?.setInt(_prefsAppRatingKey, _appRating);
    if (_lastFeedbackMessage == null || _lastFeedbackMessage!.isEmpty) {
      await _prefs?.remove(_prefsFeedbackMessageKey);
    } else {
      await _prefs?.setString(_prefsFeedbackMessageKey, _lastFeedbackMessage!);
    }
    if (_lastFeedbackAtMillis == null) {
      await _prefs?.remove(_prefsFeedbackAtKey);
    } else {
      await _prefs?.setInt(_prefsFeedbackAtKey, _lastFeedbackAtMillis!);
    }

    final encoded = jsonEncode({
      'stories': {
        for (final item in _libraryItems.values) item.storyId: item.toJson(),
      },
      'badgeState': {
        'unlockedBadgeIds': _unlockedBadgeIds.toList()..sort(),
        'activityDateKeys': _activityDateKeys.toList()..sort(),
        'sleepListenCount': _sleepListenCount,
      },
    });
    await _prefs?.setString(_prefsLibraryKey, encoded);
  }

  Future<void> _persistLibrary() async {
    await _saveLocalState();
    if (_firestore == null || _profileId == null) return;

    try {
      await _firestore!.collection('library_profiles').doc(_profileId).set({
        'profileId': _profileId,
        'userName': _userName,
        'avatar': _avatar,
        'updatedAt': FieldValue.serverTimestamp(),
        'stories': {
          for (final item in _libraryItems.values) item.storyId: item.toJson(),
        },
        'badgeState': {
          'unlockedBadgeIds': _unlockedBadgeIds.toList()..sort(),
          'activityDateKeys': _activityDateKeys.toList()..sort(),
          'sleepListenCount': _sleepListenCount,
        },
      }, SetOptions(merge: true));
    } catch (_) {
      // Local state is already saved; swallow network failures.
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void _recordActivityDay() {
    _activityDateKeys.add(_todayKey());
  }

  bool _evaluateBadges({required bool announce}) {
    final completedCount = _libraryItems.values
        .where((item) => item.isCompleted)
        .length;
    final favoriteCount = _libraryItems.values
        .where((item) => item.isFavorite)
        .length;
    final startedCount = _libraryItems.values
        .where((item) => item.hasProgress)
        .length;
    final activeDaysCount = _activityDateKeys.length;
    final animalStory = _libraryItems['minik-dostlar'];
    final hasAnimalStoryProgress =
        animalStory != null &&
        (animalStory.hasProgress || animalStory.isCompleted);

    final unlockMap = <String, bool>{
      'ilk_masalim': completedCount >= 1,
      'uyku_oncesi_kahramani': _sleepListenCount >= 3,
      'seri_okuyucu': activeDaysCount >= 3,
      'hayal_gucu_ustasi': completedCount >= 20,
      'kitap_kurdu': completedCount >= 10,
      'masal_krali': completedCount >= 30,
      'hayvan_dostu': hasAnimalStoryProgress,
      'hizli_okuyucu': startedCount >= 3,
      'favori_avcisi': favoriteCount >= 5,
    };

    for (final entry in activityDayBadgeIds.entries) {
      unlockMap[entry.value] = activeDaysCount >= entry.key;
    }

    var changed = false;
    for (final badge in badgeCatalog) {
      if (unlockMap[badge.id] != true) continue;
      if (_unlockedBadgeIds.contains(badge.id)) continue;

      _unlockedBadgeIds.add(badge.id);
      changed = true;
      if (announce) {
        _badgeCelebrationQueue.add(badge.id);
      }
    }
    return changed;
  }

  void dismissBadgeCelebration() {
    if (_badgeCelebrationQueue.isEmpty) return;
    _badgeCelebrationQueue.removeAt(0);
    notifyListeners();
  }

  bool isBadgeUnlocked(String badgeId) => _unlockedBadgeIds.contains(badgeId);

  void startSession() {
    _hasSession = true;
    notifyListeners();
  }

  void saveName(String name) {
    _userName = name.trim().isEmpty ? 'Minik Kahraman' : name.trim();
    unawaited(_persistLibrary());
    notifyListeners();
  }

  void selectAvatar(String avatar) {
    _avatar = avatar;
    unawaited(_persistLibrary());
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    if (_languageCode == languageCode) return;
    _languageCode = languageCode;
    unawaited(_saveLocalState());
    notifyListeners();
  }

  void submitFeedback(String message) {
    final normalized = message.trim();
    if (normalized.isEmpty) return;
    _lastFeedbackMessage = normalized;
    _lastFeedbackAtMillis = DateTime.now().millisecondsSinceEpoch;
    unawaited(_saveLocalState());
    notifyListeners();
  }

  void setAppRating(int rating) {
    final normalized = rating.clamp(0, 5).toInt();
    if (_appRating == normalized) return;
    _appRating = normalized;
    unawaited(_saveLocalState());
    notifyListeners();
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void signOut() {
    _hasSession = false;
    _onboardingComplete = false;
    _activeAudioTitle = null;
    _activeAudioType = null;
    notifyListeners();
  }

  bool isFavoriteStory(String storyId) {
    return _libraryItems[storyId]?.isFavorite ?? false;
  }

  StoryLibraryItem? libraryItemFor(String storyId) => _libraryItems[storyId];

  int readingPageFor(String storyId) {
    final page = _libraryItems[storyId]?.currentPage ?? 0;
    return page <= 0
        ? 1
        : page.clamp(1, storyCatalogEntryFor(storyId).totalPages);
  }

  void startReadingStory(String storyId) {
    _recordActivityDay();
    final catalog = storyCatalogEntryFor(storyId);
    final existing = _entryFor(storyId, catalogEntry: catalog);
    if (existing.hasProgress) {
      final badgeChanged = _evaluateBadges(announce: true);
      if (badgeChanged) {
        unawaited(_persistLibrary());
      }
      notifyListeners();
      return;
    }

    _libraryItems[storyId] = existing.copyWith(
      currentPage: 1,
      totalPages: catalog.totalPages,
      lastUpdatedMillis: DateTime.now().millisecondsSinceEpoch,
    );
    _evaluateBadges(announce: true);
    unawaited(_persistLibrary());
    notifyListeners();
  }

  void toggleFavorite(String storyId) {
    final catalog = storyCatalogEntryFor(storyId);
    final existing = _entryFor(storyId, catalogEntry: catalog);
    _libraryItems[storyId] = existing.copyWith(
      title: catalog.title,
      imagePath: catalog.imagePath,
      totalPages: catalog.totalPages,
      isFavorite: !existing.isFavorite,
      lastUpdatedMillis: DateTime.now().millisecondsSinceEpoch,
    );
    _evaluateBadges(announce: true);
    unawaited(_persistLibrary());
    notifyListeners();
  }

  void updateReadingProgress(String storyId, int page) {
    _recordActivityDay();
    final catalog = storyCatalogEntryFor(storyId);
    final totalPages = catalog.totalPages;
    final clampedPage = page.clamp(1, totalPages);
    final completed = clampedPage >= totalPages;
    final existing = _entryFor(storyId, catalogEntry: catalog);

    _libraryItems[storyId] = existing.copyWith(
      title: catalog.title,
      imagePath: catalog.imagePath,
      currentPage: clampedPage,
      totalPages: totalPages,
      isCompleted: completed,
      lastUpdatedMillis: DateTime.now().millisecondsSinceEpoch,
    );
    _evaluateBadges(announce: true);
    unawaited(_persistLibrary());
    notifyListeners();
  }

  void setPremium(bool value) {
    _isPremium = value;
    notifyListeners();
  }

  void playStoryAudio(String title) {
    _activeAudioTitle = title;
    _activeAudioType = AudioSourceType.story;
    notifyListeners();
  }

  void playSleepAudio(String title) {
    _recordActivityDay();
    _sleepListenCount += 1;
    _activeAudioTitle = title;
    _activeAudioType = AudioSourceType.sleep;
    _evaluateBadges(announce: true);
    unawaited(_persistLibrary());
    notifyListeners();
  }

  void stopAudio() {
    _activeAudioTitle = null;
    _activeAudioType = null;
    notifyListeners();
  }
}
