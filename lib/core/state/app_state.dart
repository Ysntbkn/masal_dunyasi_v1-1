import 'package:flutter/foundation.dart';

enum AudioSourceType { story, sleep }

class AppState extends ChangeNotifier {
  bool _hasSession = false;
  bool _onboardingComplete = false;
  bool _isPremium = false;
  String _userName = '';
  String _avatar = 'prenses';
  String _languageCode = 'tr';
  String? _activeAudioTitle;
  AudioSourceType? _activeAudioType;

  final Set<String> _favorites = <String>{};
  final Map<String, int> _readingProgress = <String, int>{};

  bool get hasSession => _hasSession;
  bool get onboardingComplete => _onboardingComplete;
  bool get isPremium => _isPremium;
  String get userName => _userName;
  String get avatar => _avatar;
  String get languageCode => _languageCode;
  bool get isEnglish => _languageCode == 'en';
  String? get activeAudioTitle => _activeAudioTitle;
  AudioSourceType? get activeAudioType => _activeAudioType;
  bool get hasActiveAudio => _activeAudioTitle != null;
  Set<String> get favorites => Set.unmodifiable(_favorites);
  Map<String, int> get readingProgress => Map.unmodifiable(_readingProgress);

  void startSession() {
    _hasSession = true;
    notifyListeners();
  }

  void saveName(String name) {
    _userName = name.trim().isEmpty ? 'Minik Kahraman' : name.trim();
    notifyListeners();
  }

  void selectAvatar(String avatar) {
    _avatar = avatar;
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    if (_languageCode == languageCode) return;
    _languageCode = languageCode;
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

  void toggleFavorite(String storyId) {
    if (!_favorites.add(storyId)) {
      _favorites.remove(storyId);
    }
    notifyListeners();
  }

  void updateReadingProgress(String storyId, int page) {
    _readingProgress[storyId] = page;
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
    _activeAudioTitle = title;
    _activeAudioType = AudioSourceType.sleep;
    notifyListeners();
  }

  void stopAudio() {
    _activeAudioTitle = null;
    _activeAudioType = null;
    notifyListeners();
  }
}
