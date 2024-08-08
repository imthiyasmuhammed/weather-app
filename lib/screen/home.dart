// ignore_for_file: unused_local_variable, prefer_final_fields, prefer_typing_uninitialized_variables, avoid_print, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/Data/imagepath.dart';
import 'package:weatherapp/ser/loc_provider.dart';
import 'package:weatherapp/ser/weather_ser_pro.dart';
import 'package:weatherapp/utilites/text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });
  }

  TextEditingController _cityController = TextEditingController();
  bool clicked = false;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationProvider = Provider.of<LocationProvider>(context);
    final weatherProvider = Provider.of<WeatherServiceProvider>(context);

    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ?? 0;
    
    DateTime sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              weatherProvider.weather?.weather?[0].main == "Clear"
                  ? Colors.blue
                  : Colors.grey[900]!,
              weatherProvider.weather?.weather?[0].main == "Rain"
                  ? Colors.blueGrey
                  : Colors.grey[700]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.white,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            data: locationProvider.currentLocationName?.administrativeArea ?? "Unknown Location",
                            color: Colors.white,
                            fw: FontWeight.w700,
                            size: 18,
                          ),
                          AppText(
                            data: DateFormat("hh:mm a").format(DateTime.now()),
                            color: Colors.white70,
                            fw: FontWeight.bold,
                            size: 14,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            clicked = !clicked;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  if (clicked)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await weatherProvider.fetchWeatherDataByCity(_cityController.text);
                            },
                            icon: Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Search by city",
                                hintStyle: TextStyle(color: Colors.white70),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 130,
                      width: 170,
                      child: Image.asset(
                        images(weatherProvider.weather?.weather?[0].main ?? "N/A") ?? "assets/cloudy.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AppText(
                    data: "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0)}\u00B0 C",
                    color: Colors.white,
                    fw: FontWeight.bold,
                    size: 18,
                  ),
                  AppText(
                    data: weatherProvider.weather?.name ?? "N/A",
                    color: Colors.white,
                    fw: FontWeight.bold,
                    size: 16,
                  ),
                  AppText(
                    data: weatherProvider.weather?.weather?[0].main ?? "N/A",
                    color: Colors.white70,
                    fw: FontWeight.bold,
                    size: 14,
                  ),
                  AppText(
                    data: DateFormat("hh:mm a").format(DateTime.now()),
                    color: Colors.white70,
                    fw: FontWeight.bold,
                    size: 14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.white),
                          AppText(
                            data: "Temp Max",
                            fw: FontWeight.bold,
                            size: 16,
                            color: Colors.white,
                          ),
                          AppText(
                            data: "${weatherProvider.weather?.main?.tempMax?.toStringAsFixed(0)}\u00b0 C",
                            color: Colors.white70,
                            fw: FontWeight.bold,
                            size: 14,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.white),
                          AppText(
                            data: "Temp Min",
                            fw: FontWeight.bold,
                            size: 16,
                            color: Colors.white,
                          ),
                          AppText(
                            data: "${weatherProvider.weather?.main?.tempMin?.toStringAsFixed(0) ?? "N/A"}\u00b0 C",
                            color: Colors.white70,
                            fw: FontWeight.bold,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.white),
                          AppText(
                            data: "Sunrise",
                            fw: FontWeight.bold,
                            size: 16,
                            color: Colors.white,
                          ),
                          AppText(
                            data: "${formattedSunrise} AM",
                            fw: FontWeight.bold,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.nightlight_round, color: Colors.white),
                          AppText(
                            data: "Sunset",
                            fw: FontWeight.bold,
                            size: 16,
                            color: Colors.white,
                          ),
                          AppText(
                            data: "${formattedSunset} PM",
                            fw: FontWeight.bold,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
