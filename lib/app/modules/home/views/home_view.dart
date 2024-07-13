import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Weather App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: controller.obx(
                  (state) => buildWeatherDataView(state),
                  onEmpty: const Text('Enter your city name'),
                  onError: (error) => Text(
                    error ?? 'Something went wrong',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onSubmitted: (_) => controller.searchWeather(),
                    controller: controller.cityController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: controller.searchWeather,
                            child: const Text('Search'),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildWeatherDataView(Map<String, dynamic>? state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state?['name'],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${(state?['main']['temp'] - 273.15).toStringAsFixed(2)} °C',
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          state?['weather'][0]['description'],
          style: const TextStyle(fontSize: 20),
        ),
        Image.network(
          'http://openweathermap.org/img/w/${state?['weather'][0]['icon']}.png',
        ),
      ],
    );
  }
}
