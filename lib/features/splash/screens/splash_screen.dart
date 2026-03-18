import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splashController = Get.put(SplashController());

    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final bool isDark = themeController.isDarkMode;
        final textTheme = isDark
            ? AppTextTheme.darkTextTheme
            : AppTextTheme.lightTextTheme;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.darkBackgroundColor, AppColors.darkCardColor]
                    : [AppColors.primaryColor, AppColors.secondaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.5, end: 1),
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        final clampedOpacity = value.clamp(0.0, 1.0); // ⚡ fix
                        return Transform.scale(
                          scale: value,
                          child: Opacity(opacity: clampedOpacity, child: child),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.darkAccentColor.withOpacity(0.2)
                              : Colors.white.withOpacity(0.3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.info_outline,
                          size: 100,
                          color: isDark
                              ? AppColors.darkAccentColor
                              : AppColors.accentColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Obx(
                          () => Visibility(
                        visible: splashController.isLoading.value,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: isDark
                              ? AppColors.darkAccentColor
                              : AppColors.accentColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "User App",
                      style: textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: isDark
                            ? AppColors.darkTextColorPrimary
                            : AppColors.textColorPrimary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Your Favorite App",
                      style: textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppColors.darkTextColorSecondary
                            : AppColors.textColorSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
