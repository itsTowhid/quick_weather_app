import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_exception.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_service.dart';

class HomeController extends GetxController
    with StateMixin<Map<String, dynamic>> {
  HomeController(this.repo);

  final cityController = TextEditingController(text: 'dhaka');
  final history = <String, dynamic>{};
  final isLoading = false.obs;
  final WeatherService repo;

  @override
  void onInit() {
    super.onInit();
    change(state, status: RxStatus.empty());
  }

  void searchWeather() async {
    final city = cityController.text;
    if (history.containsKey(city)) {
      return change(history[city], status: RxStatus.success());
    }

    change(null, status: RxStatus.loading());
    Map<String, dynamic>? responseData;
    isLoading.value = true;
    String? errMsg;

    if (cityController.text.isEmpty) {
      errMsg = 'City name cant be empty';
    } else {
      try {
        final responseData = await repo.fetchWeather(city);
        change(responseData, status: RxStatus.success());
        history[city] = responseData;
        isLoading.value = false;
        return;
      } on CityNotFoundException {
        errMsg = 'City not found. Please check the city name.';
      } on WeatherServiceException catch (e) {
        errMsg = e.message;
      } catch (e) {
        errMsg = '$e\nPlease try again';
      }
    }
    isLoading.value = false;
    change(responseData, status: RxStatus.error(errMsg));
  }
}
