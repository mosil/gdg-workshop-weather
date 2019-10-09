import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gdg_workshop_weather/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white));
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather",
      theme: ThemeData(primaryColor: Colors.blue),
      home: WeatherWidget(),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _city = "城市";
  double _temp = 0.0;
  String _tempRange = "";
  String _updateTime = "更新時間";
  String _appId = "YOUR_APPID_ON_OPEN_WHEATHER";
  int _humidity = 0;
  double _windSpeed = 0.0;

  getData() async {
    var url =
        "http://api.openweathermap.org/data/2.5/weather?q=Taichung,tw&appid=$_appId";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      Weather weather = Weather.formJson(jsonResponse);
      final Main main = weather.main;

      final now = DateTime.now();
      final time = DateFormat("yyyy年MM月dd日 HH:mm:ss").format(now);

      setState(() {
        _temp = main.getTemp();
        _city = weather.name;
        _updateTime = time;
        _tempRange = "${main.getTempMin()}~${main.getTempMax()}";
        _humidity = weather.main.humidity;
        _windSpeed = weather.wind.speed;
      });

      print("\n\n~~ API Response:");
      print("id: ${weather.id}");
      print("name: ${weather.name}");
      print("temp: ${main.getTemp()}");
      print("\n\n");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[900],
              Colors.deepPurple[200],
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                // 整個畫面用 [Column] 垂直拉成三個部份
                // 為了好計算，以 10 等份由上而下，的佔比分別是 2, 6, 2
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$_city",
                            style: TextStyle(
                              fontSize: 36.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "$_updateTime",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$_temp 度",
                            style: TextStyle(
                              fontSize: 56.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "$_tempRange",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: getContainer(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getContainer() {
    final String wind = 'assets/wind.svg';
    final String droplet = 'assets/droplet.svg';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Card(
              color: Colors.white10,
              child: Center(
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "重整",
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                          icon: Icon(Icons.refresh),
                          color: Colors.white,
                          onPressed: () {
                            getData();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          getItem("溼度", _humidity, droplet),
          getItem("風速", _windSpeed, wind),
        ],
      ),
    );
  }

  getItem(String title, value, String icon) {
    return Expanded(
      child: Card(
        color: Colors.transparent,
        child: Center(
          child: IntrinsicHeight(
            child: Column(
              children: <Widget>[
                SvgPicture.asset(
                  icon,
                  color: Colors.white,
                ),
                Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  value.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
