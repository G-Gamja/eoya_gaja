import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'getstate/weatherstate.dart';

// ignore: must_be_immutable
class TestWeather extends StatefulWidget {
  int? pageindex;
  bool? isLoading;
  TestWeather(this.pageindex, this.isLoading);

  @override
  State<TestWeather> createState() => _TestWeatherState();
}

class _TestWeatherState extends State<TestWeather> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(WeatherControlloer());
    Get.find<WeatherControlloer>().queryWeather();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherControlloer>(
      builder: (controller) {
        return //isLoading! ? ShimmerScreen()
            controller.weatherIcon == null
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(0),
                    child: Icon(Icons.water_damage),
                  )
                : widget.pageindex == 0
                    ? Container(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //controller.w!.weatherDescription!
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.mapMarker,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(controller.w!.areaName!,
                                        style: GoogleFonts.nanumGothic(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ],
                                ),
                                Container(child: controller.weatherIcon),
                                Text(controller.w!.weatherDescription!,
                                    style: GoogleFonts.nanumGothic(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${controller.w!.temperature!.celsius!.truncate()}',
                                      style: GoogleFonts.nanumGothic(
                                        textStyle: TextStyle(
                                            color: controller.w!.temperature!
                                                        .celsius!
                                                        .truncate() >
                                                    5
                                                ? Colors.white
                                                : //weathercheck(),
                                                Colors.redAccent[100],
                                            fontSize: 80,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text('°',
                                        style: GoogleFonts.nanumGothic(
                                          textStyle: TextStyle(
                                              color: controller.w!.temperature!
                                                          .celsius!
                                                          .truncate() >
                                                      5
                                                  ? Colors.white
                                                  : //weathercheck(),
                                                  Colors.redAccent[100],
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                                Text(
                                    '체감 온도 ${controller.w!.tempFeelsLike!.celsius!.truncate()}°',
                                    style: GoogleFonts.nanumGothic(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )),
                                // Text(
                                //   DateFormat.M().format(
                                //     DateTime.now(),
                                //   ),
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 15,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : widget.pageindex == 1
                        ? Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  '${controller.w!.areaName}',
                                  style: TextStyle(
                                      // color: w!.temperature!.celsius!.truncate() > 5
                                      //     ? Colors.white
                                      //     : weathercheck(),
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                // Text(
                                //   '${controller.forecastT![10].date}',
                                //   style: TextStyle(
                                //       // color: w!.temperature!.celsius!.truncate() > 5
                                //       //     ? Colors.white
                                //       //     : weathercheck(),
                                //       color: Colors.white,
                                //       fontSize: 10,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // Text(
                                //   '${controller.forecastT![10].weatherDescription}',
                                //   style: TextStyle(
                                //       // color: w!.temperature!.celsius!.truncate() > 5
                                //       //     ? Colors.white
                                //       //     : weathercheck(),
                                //       color: Colors.white,
                                //       fontSize: 10,
                                //       fontWeight: FontWeight.bold),
                                // ),
                              ],
                            ),
                          );
      },
      init: WeatherControlloer(),
    );
  }
}
