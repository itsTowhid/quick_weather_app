import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_weather_app/app/modules/home/model/weather_data.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_exception.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_service.dart';

class HomeController extends GetxController with StateMixin<WeatherData> {
  HomeController(this.repo);

  final cityController = TextEditingController();
  final history = <String, WeatherData>{};
  final isAnimating = false.obs;
  final isLoading = false.obs;
  final WeatherService repo;
  final focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    change(state, status: RxStatus.empty());
    Future.delayed(const Duration(seconds: 6), playPauseAnim);
    focusNode.addListener(() {
      if (focusNode.hasFocus && isAnimating.value) playPauseAnim();
    });
  }

  @override
  void onClose() {
    focusNode.dispose();
    if (isAnimating.value) playPauseAnim();
    cityController.dispose();
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
        errMsg = 'City not found.\nPlease check the city name.';
      } on WeatherServiceException catch (e) {
        errMsg = e.message;
      } catch (e) {
        errMsg = '$e\nPlease try again';
      }
    }
    isLoading.value = false;
    change(state, status: RxStatus.error(errMsg));
  }

  final locations = ['Bangladesh', 'Indonesia', 'Singapore', 'Dhaka'];

  void playPauseAnim() {
    isAnimating.value = !isAnimating.value;
    if (isAnimating.value) _animLoop();
  }

  void _animLoop() async {
    if (!isAnimating.value) return;
    cityController.clear();
    final txt = locations[Random().nextInt(locations.length)];
    for (int i = 0; i < txt.length; i++) {
      if (!isAnimating.value) return;
      await Future.delayed(
        const Duration(milliseconds: 99),
        () => cityController.text = txt.substring(0, i + 1),
      );
      if (isAnimating.value && cityController.text == txt) {
        Future.delayed(const Duration(seconds: 4), _animLoop);
        Future.delayed(const Duration(seconds: 1), searchWeather);
      }
    }
  }
}
