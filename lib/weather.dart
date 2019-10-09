class Weather {
  int id;
  String name;
  Main main;
  Wind wind;

  Weather({this.id, this.name, this.main, this.wind});

  factory Weather.formJson(Map<String, dynamic> json) {
    Main _main = Main.fromJson(json["main"]);
    Wind _wind = Wind.fromJson(json["wind"]);
    return Weather(
        id: json["id"], name: json["name"], main: _main, wind: _wind);
  }
}

class Main {
  double temp;
  int pressure;
  int humidity;
  double tempMin;
  double tempMax;

  getTemp() {
    return _calculator(this.temp);
  }

  getTempMax() {
    return _calculator(this.tempMax);
  }

  getTempMin() {
    return _calculator(this.tempMin);
  }

  _calculator(double temp) {
    return num.parse((temp - 273.15).toStringAsFixed(2));
  }

  Main({this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax});

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
        temp: json["temp"],
        pressure: json["pressure"],
        humidity: json["humidity"],
        tempMin: json["temp_min"],
        tempMax: json["temp_max"]);
  }
}

class Wind {
  double speed;
  int deg;

  Wind({this.speed, this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json["speed"],
      deg: json["deg"],
    );
  }
}
