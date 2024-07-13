import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quick_weather_app/app/core/network/api_service.dart';
import 'package:quick_weather_app/app/modules/home/model/weather_data.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_exception.dart';

class WeatherService {
  WeatherService(this._apiService);

  final ApiService _apiService;

  Future<WeatherData> fetchWeather(String city) async {
    final query = {'q': city, 'appid': dotenv.env['WEATHER_API_KEY']};

    try {
      final response = await _apiService.get('/data/2.5/weather', query);
      return WeatherData.fromJson(response.data);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        switch (dioError.response?.statusCode) {
          case 404:
            throw CityNotFoundException();
          default:
            throw WeatherServiceException(
                'Failed to load weather data: ${dioError.response?.statusMessage}');
        }
      } else {
        throw WeatherServiceException(
            'Failed to load weather data: ${dioError.message}');
      }
    } catch (e) {
      throw WeatherServiceException('An unexpected error occurred: $e');
    }
  }
}
