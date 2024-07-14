import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_weather_app/app/modules/home/controllers/home_controller.dart';
import 'package:quick_weather_app/app/modules/home/model/weather_data.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Weather'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(flex: 4, child: buildOutputSection(context)),
            Expanded(flex: 3, child: buildInputSection()),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () {
          final animating = controller.isAnimating.value;
          return FloatingActionButton(
            onPressed: controller.playPauseAnim,
            child: Icon(animating ? Icons.pause : Icons.play_arrow),
          );
        },
      ),
    );
  }

  Widget buildOutputSection(BuildContext context) {
    return Center(
      child: controller.obx(
        (state) => buildDataView(context, state),
        onEmpty: const Text('Enter your city name'),
        onError: (error) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.heart_broken_rounded,
              color: Colors.grey.shade300,
              size: 100,
            ),
            Text(
              error ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          focusNode: controller.focusNode,
          onSubmitted: (_) => controller.searchWeather(),
          controller: controller.cityController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'City Name',
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ElevatedButton(
            onPressed:
                controller.isLoading.value ? null : controller.searchWeather,
            child: const Text('Search'),
          ),
        ),
      ],
    );
  }

  Widget buildDataView(BuildContext context, WeatherData? w) {
    final tt = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            w?.city ?? '',
            style: tt.displayLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(w?.temp ?? '', style: tt.displayMedium),
          ),
          Text(w?.condition ?? '', style: tt.displaySmall),
          Image.network(
            w?.iconUrl ?? '',
            fit: BoxFit.fill,
            height: 80,
            width: 80,
          ),
        ],
      ),
    );
  }
}
