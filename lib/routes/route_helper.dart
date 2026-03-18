import 'package:get/get.dart';
import '../features/post/screens/user_list_screen.dart';
import '../features/post/screens/profile_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';

class RouteHelper {

  static String getSplashRoute() => AppRoutes.splash;
  static String getPostListRoute() => AppRoutes.userList;
  static String getProfileRoute() => AppRoutes.profile;

  static List<GetPage> routes = [

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.userList,
      page: () => UserListScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () {
        final user = Get.arguments;
        return ProfileScreen(user: user);
      },
      transition: Transition.rightToLeft,
    ),
  ];
}
