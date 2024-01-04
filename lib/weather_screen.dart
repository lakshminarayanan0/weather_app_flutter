import 'dart:convert';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_one/additional_info.dart';
import 'package:new_one/hourly_weather_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentLocationWeather();
  }

  late String errorMsg = "";
  late String cityName = "karaikudi";
  final TextEditingController _textEditingController = TextEditingController();

  Future<void> getCurrentLocationWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      await getWeatherDataByLocation(position.latitude, position.longitude);
    } catch (e) {
      getWeatherData(cityName);
    }
  }

  Future<void> getWeatherDataByLocation(double lat, double lon) async {
    String apiKey = "84cd17bc5eb2dca3cece7d4c559c1d06";
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      final data = jsonDecode(response.body);

      if (data['cod'] != "200") {
        throw "An unexpected error occurred!";
      }

      setState(() {
        cityName = data["city"]["name"].toString().toUpperCase();
      });
    } catch (error) {
      setState(() {
        errorMsg = error.toString();
      });
    }
  }

  Future<Map<String, dynamic>> getWeatherData(String city) async {
    // String city = cityName;
    String apiKey = "84cd17bc5eb2dca3cece7d4c559c1d06";
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      final data = jsonDecode(response.body);

      if (data['cod'] != "200") {
        throw "An unexpected error occured!";
      }
      return data;
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 58, 31),
          title: const Text(
            "Weather App",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textEditingController,
                              onSubmitted: (String value) {
                                setState(() {
                                  cityName = value;
                                  _textEditingController.clear();
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter City",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                  ),
                                  hintStyle:
                                      const TextStyle(color: Colors.black),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 16)),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 4, 56, 6),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                //    padding: EdgeInsets.symmetric(vertical: 20),
                              ),
                              onPressed: () {
                                setState(() {
                                  cityName = _textEditingController.text;
                                  _textEditingController.clear();
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      Text(
                        errorMsg,
                        style: const TextStyle(color: Colors.red),
                      )
                    ]),
                  ),
                ),
              ),
              FutureBuilder(
                future: getWeatherData(cityName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  final data = snapshot.data!;
                  final currentWeatherData = data['list'][0];
                  final currentTemp = currentWeatherData['main']['temp'];
                  final currentWeather =
                      currentWeatherData['weather'][0]['main'];
                  final currentHumidity =
                      currentWeatherData['main']['humidity'];
                  final currentPressure =
                      currentWeatherData['main']['pressure'];
                  final currentWindSpeed = currentWeatherData['wind']['speed'];
                  final currentCity =
                      data["city"]["name"].toString().toUpperCase();

                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //main card

                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(currentCity,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text("$currentTemp K",
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Icon(
                                        (currentWeather == "Clouds" ||
                                                currentWeather == "Sunny")
                                            ? Icons.cloud
                                            : Icons.sunny,
                                        size: 50,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        currentWeather,
                                        style: const TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        //weather cards
                        const Text(
                          "Hourly Forecast",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                              itemCount: 15,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final hourlyForecast = data['list'][index + 1];
                                final hourlyWeather =
                                    hourlyForecast['weather'][0]['main'];
                                final hourlyWeatherCondition =
                                    hourlyWeather == "Clouds" ||
                                        hourlyWeather == "Sunny";
                                final hourlyTemperature =
                                    hourlyForecast['main']['temp'];
                                final time =
                                    DateTime.parse(hourlyForecast['dt_txt']);
                                final formatedTime =
                                    DateFormat.j().format(time);
                                return HourlyForCastItem(
                                    time: formatedTime.toString(),
                                    icon: hourlyWeatherCondition
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    temperature: hourlyTemperature.toString());
                              }),
                        ),
                        const SizedBox(height: 20),

                        //additional info
                        const Text("Additional Information",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditionalInfoItem(
                                icon: Icons.water_drop,
                                title: "Humidity",
                                data: currentHumidity.toString()),
                            AdditionalInfoItem(
                                icon: Icons.air_outlined,
                                title: "Wind Speed",
                                data: currentWindSpeed.toString()),
                            AdditionalInfoItem(
                                icon: Icons.shield_moon,
                                title: "Pressure",
                                data: currentPressure.toString()),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
