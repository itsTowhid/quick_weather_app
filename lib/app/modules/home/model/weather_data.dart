class WeatherData {
  final String? city, temp, condition, icon;

  WeatherData({this.city, this.temp, this.condition, this.icon});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'],
      temp: '${(json['main']['temp'] - 273.15).toStringAsFixed(2)} °C',
      condition: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/w/$icon.png';
}
