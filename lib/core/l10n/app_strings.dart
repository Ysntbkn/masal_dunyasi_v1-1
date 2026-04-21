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
