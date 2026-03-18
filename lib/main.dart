import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/bindings/initial_bindings.dart';
import 'routes/route_helper.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      initialRoute: RouteHelper.getSplashRoute(),
      getPages: RouteHelper.routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
    ));
  }
}