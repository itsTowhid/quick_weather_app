import 'package:get/get.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_service.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherService>(() => WeatherService(Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
