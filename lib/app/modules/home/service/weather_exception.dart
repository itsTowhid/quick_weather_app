class WeatherServiceException implements Exception {
  final String message;

  WeatherServiceException(this.message);

  @override
  String toString() => 'WeatherServiceException: $message';
}

class CityNotFoundException extends WeatherServiceException {
  CityNotFoundException() : super('City not found');
}
