import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:quick_weather_app/app/core/network/api_service.dart';
import 'package:quick_weather_app/app/core/network/connectivity_service.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    Get.put<ApiService>(
      ApiService(dotenv.env['BASE_URL']!, Get.find()),
      permanent: true,
    );
  }
}
