import 'package:get/get.dart';
import '../../features/post/controllers/user_controller.dart';
import '../../features/post/domain/repositories/user_repository.dart';
import '../../features/post/domain/repositories/user_repository_interface.dart';
import '../../features/post/domain/usecase/get_users_usecase.dart';
import '../../features/splash/controllers/splash_controller.dart';
import '../services/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Dio(), fenix: true);
    Get.lazyPut(() => Connectivity(), fenix: true);
    Get.lazyPut(() => ApiClient(), fenix: true);

    Get.lazyPut<UserRepositoryInterface>(() => UserRepository(Get.find<ApiClient>()), fenix: true,);
    Get.lazyPut(() => GetUsersUseCase(Get.find<UserRepositoryInterface>()), fenix: true);
    Get.lazyPut(() => UserController(Get.find<GetUsersUseCase>(),), fenix: true,);

    Get.lazyPut(() => SplashController(), fenix: true);
  }
}