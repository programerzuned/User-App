import 'dart:async';
import 'package:get/get.dart';
import '../../../routes/route_helper.dart';

class SplashController extends GetxController {
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _startSplash();
  }

  void _startSplash() {
    isLoading.value = true;
    Timer(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.offAllNamed(RouteHelper.getPostListRoute());
    });
  }

}