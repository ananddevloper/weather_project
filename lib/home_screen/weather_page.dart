import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_project/utils/app_animation.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String latitiude = '19.1855';
  String longitude = '72.8587';

  var tempratureV = '';
  var wind = '';
  var pm10V = '';
  var pm2_5V = '';
  var carbonMonoV = '';
  var nitrogenDioxV = '';
  var sulphurDioxideV = '';

  List<String> dayList = [];

  List<String> miniMumTemperatureList = [];
  List<String> maxiMumTemperatureList = [];
  List<String> timeList = [];
  List<String> temperatureList = [];

  void getWeather() async {
    Uri uri = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$latitiude&longitude=$longitude&current_weather=true",
    );
    print(uri.toString());
    Response response = await get(uri);

    Map data = jsonDecode(response.body);

    Map current = data['current_weather'];

    num temp = current['temperature'];

    num windspeeds = current["windspeed"];

    tempratureV = temp.toString();

    wind = windspeeds.toString();

    setState(() {});
  }

  void fetchAirquality() async {
    Uri uri = Uri.parse(
      'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$latitiude&longitude=$longitude&hourly=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone,aerosol_optical_depth,dust&forecast_days=1&timezone=auto',
    );
    print(uri.toString());
    Response airQuality = await get(uri);

    Map hrAirQuality = jsonDecode(airQuality.body);

    Map allHourAir = hrAirQuality['hourly'];

    List hrAirTime = allHourAir['time'];
    List pm10List = allHourAir['pm10'];
    List pm2_5List = allHourAir['pm2_5'];
    List carbonMonoxideList = allHourAir['carbon_monoxide'];
    List nitrogenDioxideList = allHourAir['nitrogen_dioxide'];
    List sulphurDioxideList = allHourAir['sulphur_dioxide'];
    List ozoneList = allHourAir['ozone'];
    List aerosolOopticaldepth = allHourAir['aerosol_optical_depth'];
    List dustList = allHourAir['dust'];

    String time = hrAirTime[0];
    num pm10 = pm10List[12];
    num pm2_5 = pm2_5List[12];
    num carbon_monoxide = carbonMonoxideList[12];
    num nitrogen_dioxide = nitrogenDioxideList[12];

    num sulphur_dioxide = sulphurDioxideList[12];
    num ozone = ozoneList[12];
    num aerosol_optical_depth = aerosolOopticaldepth[12];
    num dust = dustList[12];

    pm10V = pm10.toString();
    pm2_5V = pm2_5.toString();
    nitrogenDioxV = nitrogen_dioxide.toString();
    sulphurDioxideV = sulphur_dioxide.toString();
    carbonMonoV = carbon_monoxide.toString();

    setState(() {});
  }

  void fetchDaily() async {
    Uri uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitiude&longitude=$longitude&daily=temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_sum,rain_sum,showers_sum,snowfall_sum,snow_depth_max,wind_speed_10m_max,wind_gusts_10m_max,uv_index_max,weathercode,sunrise,sunset&forecast_days=7&timezone=auto',
    );
    print(uri.toString());

    Response responseSe = await get(uri);
    Map dailyData = jsonDecode(responseSe.body);
    Map allDays = dailyData['daily'];

    List timeList = allDays['time'];
    List temperature2mMaxList = allDays['temperature_2m_max'];
    List temperature2mMinList = allDays['temperature_2m_min'];

    // List apparentTemperatureMaxList = allDays['apparent_temperature_max'];
    // List apparentTemperatureMinList = allDays['apparent_temperature_min'];
    // List precipitationSumList = allDays['precipitation_sum'];
    // List rainSumList = allDays['rain_sum'];
    // List showersSumList = allDays['showers_sum'];
    // List snowfallSumList = allDays['snowfall_sum'];
    // List snowDepthMaxList = allDays['snow_depth_max'];
    // List windSpeed10mMaxList = allDays['wind_speed_10m_max'];
    // List windGusts10mMaxList = allDays['wind_gusts_10m_max'];
    // List uvIndexMaxList = allDays['uv_index_max'];
    // List weatherCodeList = allDays['weathercode'];
    // List sunriseList = allDays['sunrise'];
    // List sunSetList = allDays['sunset'];

    // String time = timeList[2];
    // num temperature2mMax = temperature2mMaxList[1];
    // num temperatur2mMin = temperature2mMinList[1];
    // num apparentTemperatureMax = apparentTemperatureMaxList[1];
    // num apparentTemperatureMin = apparentTemperatureMinList[1];
    // num precipitationSum = precipitationSumList[1];
    // num rainSum = rainSumList[1];
    // num showersSum = showersSumList[1];
    // num snowfallSum = snowfallSumList[1];
    // num snowDepthMax = snowDepthMaxList[1];
    // num windSpeed10mMax = windSpeed10mMaxList[1];
    // num windGusts10mMax = windGusts10mMaxList[1];
    // num uvIndexMax = uvIndexMaxList[1];
    // num weatherCode = weatherCodeList[1];
    // num sunRise = sunriseList[1];
    // num sunSet = sunSetList[1];

    // Es step ko bolte hai list dynamok ko sting list me convort karna.

    dayList = timeList.map((e) => e.toString()).toList();
    miniMumTemperatureList = temperature2mMaxList
        .map((e) => e.toString())
        .toList();
    maxiMumTemperatureList = temperature2mMinList
        .map((e) => e.toString())
        .toList();

    setState(() {});
  }

  String getDayByDate(String date) {
    if (date.isEmpty) return '';
    DateTime? dateTime = DateTime.tryParse(date);
    if (dateTime == null) return '';
    int day = dateTime.weekday;
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
    }
    return '';
  }

  void fatchTimeAndTemprature() async {
    Uri uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitiude&longitude=$longitude&hourly=temperature_2m&forecast_days=1&timezone=auto',
    );
    print(uri.toString());

    Response timeTemprature = await get(uri);
    Map tempratureHrData = jsonDecode(timeTemprature.body);
    Map allHourly = tempratureHrData['hourly'];

    List timList = allHourly['time'];
    List temperatureLists = allHourly['temperature_2m'];

    timeList = timList.map((e) => e.toString()).toList();
    temperatureList = temperatureLists.map((e) => e.toString()).toList();

    setState(() {});
  }

  String extractTimeAmPm(String dateTimeString) {
  DateTime dt = DateTime.parse(dateTimeString);

  int hour = dt.hour;
  String minute = dt.minute.toString().padLeft(2, '0');

  String period = hour >= 12 ? "PM" : "AM";
  int hour12 = hour % 12;
  if (hour12 == 0) hour12 = 12;

  return "$hour12:$minute $period";
}


  @override
  void initState() {
    // TODO: implement initState
    getWeather();
    fetchAirquality();
    fetchDaily();
    fatchTimeAndTemprature();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(backgroundColor: Colors.black45),

      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    'Malad',
                    style: TextStyle(
                      fontSize: 38,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Card(
                color: Colors.white10,
                child: Row(
                  children: [
                    Lottie.asset(
                      AppJsonIcons.partly_cloudy_day,
                      height: 100,
                      width: 100,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$tempratureV °',
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                              ),
                            ),

                            Text(
                              'clear',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'F',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 135,
                child: Card(
                  color: Colors.white10,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String temp = temperatureList[index];
                        String time = timeList[index];


                        return getTimeDetails(
                          time: extractTimeAmPm(time),
                          icon: AppJsonIcons.clear_day,
                          degreee: '$temp °',
                        );

                      

                      },
                      separatorBuilder: (context, index) => SizedBox(width: 5),
                      itemCount: timeList.length,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              dayList.isNotEmpty &&
                      miniMumTemperatureList.isNotEmpty &&
                      maxiMumTemperatureList.isNotEmpty
                  ? SizedBox(
                      child: Card(
                        color: Colors.white10,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Forecast',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 13),
                              Row(
                                children: [
                                  Expanded(
                                    child: getDailyForcastRow(
                                      day: dayList[2],
                                      maxTemp: maxiMumTemperatureList[2],
                                      minTemp: miniMumTemperatureList[2],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: getDailyForcastRow(
                                      day: dayList[3],
                                      maxTemp: maxiMumTemperatureList[3],
                                      minTemp: miniMumTemperatureList[3],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: getDailyForcastRow(
                                      day: dayList[4],
                                      maxTemp: maxiMumTemperatureList[4],
                                      minTemp: miniMumTemperatureList[4],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: getDailyForcastRow(
                                      day: dayList[5],
                                      maxTemp: maxiMumTemperatureList[5],
                                      minTemp: miniMumTemperatureList[5],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.white10,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Lottie.asset(
                                  AppJsonIcons.wind,
                                  height: 30,
                                  width: 30,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Wind',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  wind,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'mph',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white10,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Lottie.asset(
                                  AppJsonIcons.raindrop,
                                  height: 30,
                                  width: 30,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Precipitation',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '0,00',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'in',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Card(
                color: Colors.white10,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Air Quality',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      getAirQuality(airName: 'PM10', airNmber: "$pm10V μg/m³"),
                      Divider(color: Colors.grey),
                      getAirQuality(
                        airName: 'PM2,5',
                        airNmber: '$pm2_5V μg/m³',
                      ),
                      Divider(color: Colors.grey),
                      getAirQuality(
                        airName: 'NO2',
                        airNmber: '$nitrogenDioxV μg/m³',
                      ),
                      Divider(color: Colors.grey),
                      getAirQuality(
                        airName: 'SO2',
                        airNmber: '$sulphurDioxideV μg/m³',
                      ),
                      Divider(color: Colors.grey),
                      getAirQuality(
                        airName: 'CO2',
                        airNmber: '$carbonMonoV μg/m³',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row getDailyForcastRow({
    required String day,
    required String minTemp,
    required String maxTemp,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            getDayByDate(day),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '${maxTemp}°/${minTemp}°',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Row getAirQuality({required String airName, required String airNmber}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            airName,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        Text(airNmber, style: TextStyle(fontSize: 15, color: Colors.white)),
      ],
    );
  }

  Column getTimeDetails({
    required String time,
    required String icon,
    required String degreee,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(time, style: TextStyle(color: Colors.white, fontSize: 15)),
        SizedBox(height: 8),
        Lottie.asset(icon, height: 30, width: 30),
        SizedBox(height: 8),
        Text(
          degreee,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
