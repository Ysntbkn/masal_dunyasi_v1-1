abstract final class AppRoutes {
  static const login = '/login';
  static const name = '/onboarding/name';
  static const avatar = '/onboarding/avatar';
  static const trial = '/onboarding/trial';
  static const loading = '/onboarding/loading';

  static const home = '/home';
  static const library = '/library';
  static const sleep = '/sleep';
  static const watch = '/watch';
  static const profile = '/profile';

  static const categories = '/categories';
  static const categoryDetail = '/categories/:categoryId';
  static const storyDetail = '/story/:storyId';
  static const reading = '/story/:storyId/read';
  static const audioPlayer = '/audio';
  static const achievements = '/achievements';
  static const settings = '/settings';
  static const premium = '/premium';
  static const storyTrial = '/trial/:storyId';

  static String category(String categoryId) => '/categories/$categoryId';
  static String story(String storyId) => '/story/$storyId';
  static String readStory(String storyId) => '/story/$storyId/read';
  static String trialStory(String storyId) => '/trial/$storyId';
}
