import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_weather_app/app/modules/home/model/weather_data.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_exception.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_service.dart';

class HomeController extends GetxController with StateMixin<WeatherData> {
  HomeController(this.repo);

  final cityController = TextEditingController(text: 'dhaka');
  final history = <String, WeatherData>{};
  final isLoading = false.obs;
  final WeatherService repo;

  @override
  void onInit() {
    super.onInit();
    change(state, status: RxStatus.empty());
  }

  void searchWeather() async {
    final city = cityController.text.trim().toLowerCase();
    if (history.containsKey(city)) {
      return change(history[city], status: RxStatus.success());
    }

    change(null, status: RxStatus.loading());
    isLoading.value = true;
    String? errMsg;

    if (city.isEmpty) {
      errMsg = 'City name cant be empty';
    } else if (city.isNumericOnly) {
      errMsg = 'Invalid city name';
    } else {
      try {
        final response = await repo.fetchWeather(city);
        change(response, status: RxStatus.success());
        history[city] = response;
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
    change(state, status: RxStatus.error(errMsg));
  }
}
