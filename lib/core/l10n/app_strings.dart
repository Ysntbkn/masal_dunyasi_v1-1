import '../state/app_state.dart';

class AppStrings {
  const AppStrings(this._state);

  final AppState _state;

  bool get _en => _state.isEnglish;

  String isEnglishLabel(String en, String tr) => _en ? en : tr;

  String get loginTitle => _en ? 'LOGIN' : 'G\u0130R\u0130\u015e YAP';
  String get chooseMethod =>
      _en ? 'Please Choose a Method' : 'L\u00fctfen Bir Y\u00f6ntem Se\u00e7in';
  String get googleLogin =>
      _en ? 'Continue With Google' : 'Google \u0130le Giri\u015f Yap';
  String get or => _en ? 'or' : 'veya';
  String get guestLogin => _en ? 'Continue as Guest' : 'Misafir Olarak Girin';
  String get termsStart =>
      _en ? 'By signing in, you accept ' : 'Giri\u015f yaparak ';
  String get termsOfService =>
      _en ? 'Terms of Service' : 'Hizmet \u015eartlar\u0131';
  String get and => _en ? ' and ' : ' ve ';
  String get privacyPolicy =>
      _en ? 'Privacy Policy' : 'Gizlilik Politikas\u0131n\u0131';
  String get termsEnd => _en ? '' : '\nkabul etmi\u015f olursunuz';

  String get nameTitle => _en ? 'GET TO KNOW YOU' : 'SEN\u0130 TANIYALIM';
  String get enterName =>
      _en ? 'Please Enter a Name' : 'L\u00fctfen Bir \u0130sim Girin';
  String get nameHint => _en ? 'Ex: Demet' : '\u00d6rnk: Demet';
  String get chooseLanguage => _en ? 'Language' : 'Dil Se\u00e7';
  String get continueText => _en ? 'Continue' : 'Devam Et';

  String get avatarTitle => _en ? 'CHOOSE AVATAR' : 'AVATAR SE\u00c7';
  String get chooseAvatar => _en
      ? 'Choose an Avatar You Like'
      : 'Be\u011fendi\u011fin Bir Avatar Se\u00e7';

  String get home => _en ? 'Home' : 'Ana Sayfa';
  String get library => _en ? 'Library' : 'K\u00fct\u00fcphane';
  String get sleep => _en ? 'Sleep' : 'Uyku';
  String get profile => _en ? 'Profile' : 'Profil';
  String get storyWorld => _en ? 'Story World' : 'Masal D\u00fcnyas\u0131';
  String get featuredStory =>
      _en ? 'Story of the Day' : 'G\u00fcn\u00fcn Masal\u0131';
  String get featuredStoryTitle => _en
      ? 'The Secret of the Glowing Book'
      : 'I\u015f\u0131lt\u0131l\u0131 Kitab\u0131n S\u0131rr\u0131';
  String get premiumStories => _en ? 'Premium Stories' : 'Premium Masallar';
  String get premiumStoriesSub => _en
      ? 'Explore exclusive collections.'
      : '\u00d6zel koleksiyonlar\u0131 ke\u015ffet.';
  String get categories => _en ? 'Categories' : 'Kategoriler';
  String get allCategories => _en ? 'All categories' : 'T\u00fcm kategoriler';
  String get continueReading => _en ? 'Continue' : 'Devam Et';
  String get favorites => _en ? 'Favorites' : 'Favoriler';
  String get readStories => _en ? 'Read Stories' : 'Okunanlar';
  String get sleepSounds => _en ? 'Sleep Sounds' : 'Uyku Sesleri';
  String get startMiniPlayer =>
      _en ? 'Start mini player' : 'Mini player ba\u015flat';
  String get settings => _en ? 'Settings' : 'Ayarlar';
  String get languageSelection => _en ? 'Language' : 'Dil Se\u00e7imi';
  String get languageSelectionHint =>
      _en ? 'Choose your app language' : 'Uygulama dilini se\u00e7';
  String get privacyPolicyTitle =>
      _en ? 'Privacy Policy' : 'Gizlilik Politikas\u0131';
  String get privacyPolicyHint => _en
      ? 'See how your data is used'
      : 'Verilerinin nas\u0131l kullan\u0131ld\u0131\u011f\u0131n\u0131 g\u00f6r';
  String get feedbackTitle => _en ? 'Feedback' : 'Geri Bildirim';
  String get feedbackHint =>
      _en ? 'Share your thoughts with us' : 'Fikrini bizimle payla\u015f';
  String get signOutTitle => _en ? 'Sign Out' : '\u00c7\u0131k\u0131\u015f Yap';
  String get signOutHint => _en
      ? 'Return to the welcome flow'
      : 'Kar\u015f\u0131lama ekran\u0131na d\u00f6n';
  String get turkish => _en ? 'Turkish' : 'T\u00fcrk\u00e7e';
  String get english => 'English';
  String get chooseLanguageSheetTitle =>
      _en ? 'Choose Language' : 'Dil Se\u00e7';
  String get chooseLanguageSheetSubtitle => _en
      ? 'Your choice will be saved for the next launch too.'
      : 'Se\u00e7imin bir sonraki a\u00e7\u0131l\u0131\u015fta da korunur.';
  String get feedbackSheetTitle =>
      _en ? 'Send Feedback' : 'Geri Bildirim G\u00f6nder';
  String get feedbackSheetSubtitle => _en
      ? 'Tell us what you liked or what we should improve.'
      : 'Neyi sevdi\u011fini ya da neyi geli\u015ftirmemizi istedi\u011fini yaz.';
  String get feedbackFieldHint => _en
      ? 'For example: the sleep sounds are great, but I want more stories.'
      : '\u00d6rnek: uyku sesleri \u00e7ok g\u00fczel ama daha fazla masal istiyorum.';
  String get saveFeedback =>
      _en ? 'Save Feedback' : 'Geri Bildirimi Kaydet';
  String get cancel => _en ? 'Cancel' : 'Vazge\u00e7';
  String get close => _en ? 'Close' : 'Kapat';
  String get signOutConfirmTitle =>
      _en ? 'Sign out now?' : '\u015eimdi \u00e7\u0131k\u0131\u015f yap\u0131ls\u0131n m\u0131?';
  String get signOutConfirmBody => _en
      ? 'You will return to the login and onboarding screens.'
      : 'Giri\u015f ve kar\u015f\u0131lama ekranlar\u0131na geri d\u00f6nersin.';
  String get signOutConfirmAction =>
      _en ? 'Sign Out' : '\u00c7\u0131k\u0131\u015f Yap';
  String get ratingTitle =>
      _en ? 'Rate Story World' : 'Masal D\u00fcnyas\u0131na puan verin';
  String get ratingThanks => _en
      ? 'Thanks, your rating has been saved.'
      : 'Te\u015fekk\u00fcrler, puan\u0131n kaydedildi.';
  String get lastFeedbackSaved => _en
      ? 'Your latest feedback is saved.'
      : 'Son geri bildirimin kaydedildi.';
  String get privacyIntro => _en
      ? 'We keep only the information needed to personalize your story world.'
      : 'Masal d\u00fcnyan\u0131 ki\u015fiselle\u015ftirmek i\u00e7in yaln\u0131zca gerekli bilgileri saklar\u0131z.';
  String get privacyBullets => _en
      ? 'Name, avatar, language, reading progress and badges are stored on this device. If Firebase is available, the library sync may also back up progress securely.'
      : '\u0130sim, avatar, dil, okuma ilerlemesi ve rozetler bu cihazda saklan\u0131r. Firebase a\u00e7\u0131ksa k\u00fct\u00fcphane ilerlemesi g\u00fcvenli bi\u00e7imde yedeklenebilir.';
  String get privacyNoSell => _en
      ? 'We do not sell personal data, and you can clear your session anytime by signing out.'
      : 'Ki\u015fisel verileri satmay\u0131z; istersen \u00e7\u0131k\u0131\u015f yaparak oturumunu istedi\u011fin an kapatabilirsin.';
  String get footerStudio => 'Yadem Studio - 2026';
  String get premium => _en ? 'Premium' : 'Premium';
  String get achievements => _en ? 'Badges' : 'Rozetler';
  String get freeAccount => _en ? 'Free account' : '\u00dccretsiz hesap';
  String get premiumActive => _en ? 'Premium active' : 'Premium aktif';

  String get welcomePreparing => _en
      ? 'Your story world is getting ready...'
      : 'Masal d\u00fcnyan haz\u0131rlan\u0131yor...';
  String welcome(String name) =>
      _en ? 'Welcome, $name' : 'Ho\u015f geldin, $name';
}
