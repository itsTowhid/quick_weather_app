import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:quick_weather_app/app/core/bindings/initial_bindings.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const QuickWeatherApp());
}

class QuickWeatherApp extends StatelessWidget {
  const QuickWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Quick Weather App",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBindings(),
    );
  }
}
