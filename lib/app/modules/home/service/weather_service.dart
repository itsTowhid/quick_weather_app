import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quick_weather_app/app/core/network/api_service.dart';
import 'package:quick_weather_app/app/modules/home/service/weather_exception.dart';

class WeatherService {
  WeatherService(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final query = {'q': city, 'appid': dotenv.env['WEATHER_API_KEY']};
    final response = await _apiService.get('/data/2.5/weather', query);

    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 404) {
      throw CityNotFoundException();
    } else {
      throw WeatherServiceException('Something went wrong!');
    }
  }
}
