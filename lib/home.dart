import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? city = "Vita,IN";
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                controller: _ctrl,
                onSubmitted: (_city) {
                  setState(
                    () {
                      city = _city;
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: "City",
                  filled: true,
                ),
                maxLength: 25,
              ),
            ),
            if (city?.trim().isNotEmpty ?? false)
              Expanded(
                child: FutureBuilder<Response<Map<String, dynamic>>>(
                  future: Dio().get(
                      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=11945971f1b746ceaa569a887f11ddf7&units=metric"),
                  builder: (_, snap) {
                    if (snap.hasError) {
                      return Center(
                        child: Chip(
                          label: Text(
                            ((snap.error as DioError).response!.data
                                    as Map<String, dynamic>)['message']
                                .toString()
                                .toUpperCase(),
                          ),
                        ),
                      );
                    }
                    if (!snap.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final res = snap.data!.data;

                    return Column(
                      children: [
                        //City
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "http://openweathermap.org/img/wn/${res?['weather'][0]['icon']}@2x.png"),
                            ),
                            title: Text("${res?["name"] ?? "Name"}"),
                            subtitle:
                                Text("${res?["sys"]["country"] ?? "Country"}"),
                            trailing: Chip(
                              label: Text.rich(TextSpan(children: [
                                TextSpan(
                                  text: "${res?['weather'][0]['main']} "
                                      .toUpperCase(),
                                ),
                                TextSpan(
                                  text: "(${res?['weather'][0]['description']})"
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .fontSize,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              ])),
                            ),
                          ),
                        ),
                        //Temp
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.thermometer_exterior,
                                    ),
                                  ),
                                  title: Text("${res?["main"]["temp_min"]} °C"),
                                  subtitle: Text("Temp Min"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.celsius,
                                    ),
                                  ),
                                  title: Text("${res?["main"]["temp"]} °C"),
                                  subtitle: Text("Temp"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.thermometer,
                                    ),
                                  ),
                                  title: Text("${res?["main"]["temp_max"]} °C"),
                                  subtitle: Text("Temp Max"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Humidity
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.earthquake,
                                    ),
                                  ),
                                  title:
                                      Text("${res?["main"]["grnd_level"]} hPa"),
                                  subtitle: Text("Grnd Lvl"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.hurricane,
                                    ),
                                  ),
                                  title:
                                      Text("${res?["main"]["pressure"]} hPa"),
                                  subtitle: Text("Pressure"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.humidity,
                                    ),
                                  ),
                                  title: Text("${res?["main"]["humidity"]} %"),
                                  subtitle: Text("Humidity"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.flood,
                                    ),
                                  ),
                                  title:
                                      Text("${res?["main"]["sea_level"]} hPa"),
                                  subtitle: Text("Sea Lvl"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Sun & Wind
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.sunrise,
                                    ),
                                  ),
                                  title: Text(
                                    DateFormat.jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        Duration(
                                                seconds: res?["sys"]["sunrise"])
                                            .inMilliseconds,
                                        isUtc: true,
                                      ).toLocal(),
                                    ),
                                  ),
                                  subtitle: Text("Sunrise"),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: WindIcon(
                                      degree: res?["wind"]["deg"] ?? 0,
                                    ),
                                  ),
                                  title: Text(
                                      "${((res?["wind"]["speed"] ?? 0) * 1.60934).toStringAsFixed(2) ?? "Wind Speed"} m/s"),
                                  subtitle: Text("WindSpeed"),
                                  trailing: Chip(
                                    label: Text("${res?["wind"]["deg"] ?? 0}°"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: BoxedIcon(
                                      WeatherIcons.sunset,
                                    ),
                                  ),
                                  title: Text(
                                    DateFormat.jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        Duration(seconds: res?["sys"]["sunset"])
                                            .inMilliseconds,
                                        isUtc: true,
                                      ).toLocal(),
                                    ),
                                  ),
                                  subtitle: Text("Sunset"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Extra
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        child: BoxedIcon(
                                          TimeIcon.fromDate(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              Duration(seconds: res?["dt"])
                                                  .inMilliseconds,
                                              isUtc: true,
                                            ).toLocal(),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            Duration(seconds: res?["dt"])
                                                .inMilliseconds,
                                            isUtc: true,
                                          ).toLocal(),
                                        ),
                                      ),
                                      subtitle: Text("DateTime"),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        child: BoxedIcon(
                                          TimeIcon.fromDate(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              Duration(
                                                      seconds: res?["timezone"])
                                                  .inMilliseconds,
                                              isUtc: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        DateFormat.Hm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            Duration(seconds: res?["timezone"])
                                                .inMilliseconds,
                                            isUtc: true,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text("Timezone"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        child: Text("E"),
                                      ),
                                      title: Text(
                                          "${res?["coord"]["lon"] ?? "Longitude"}° E"),
                                      subtitle: Text("Longitude"),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        child: Text("N"),
                                      ),
                                      title: Text(
                                          "${res?["coord"]["lat"] ?? "Latitude"}° N"),
                                      subtitle: Text("Latitude"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              )
            else
              Spacer(),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: Text("Made by Mayank Diwate with Flutter")),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
