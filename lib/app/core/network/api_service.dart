import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:quick_weather_app/app/core/network/connectivity_service.dart';

class ApiService extends GetxController {
  final Dio _dio;
  final ConnectivityService connectivityService;

  ApiService(String baseUrl, this.connectivityService)
      : _dio = Dio()
          ..options.baseUrl = Uri.https(baseUrl).toString()
          ..options.responseType = ResponseType.json {
    if (kDebugMode) {
      _dio.interceptors
          .add(PrettyDioLogger(requestBody: true, requestHeader: true));
    }
  }

  Future<Response> get(String path, [Map<String, dynamic>? query]) async {
    final hasInternet = await connectivityService.isConnected();
    if (!hasInternet) return Future.error("No internet");

    try {
      return await _dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      debugPrint('ERR: $path : $e');
      return Future.error("Something Went Wrong!");
    }
  }
}
