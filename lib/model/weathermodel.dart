import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//todo 괜찮은 날씨 이미지나 아이콘 찾아서 다운받깅
class WeatherModel {
  //todo static 문구 넣으니까 오류 수정되었는데 이거 static무슨 의미인지 파악해라잉
  static Widget? getWeatherIcon(int? condition) {
    if (condition! >= 200 && condition < 300) {
      return const FaIcon(
        FontAwesomeIcons.bolt,
        color: Colors.white,
        size: 50,
      );
      // SvgPicture.asset(
      //   'svg/climacon-colud_lightning.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    } else if (condition >= 300 && condition < 400) {
      return const FaIcon(
        FontAwesomeIcons.cloudRain,
        color: Colors.white,
        size: 50,
      );
      // SvgPicture.asset(
      //   'svg/climacon-colud_lightning.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    } else if (condition >= 500 && condition < 504) {
      return const FaIcon(
        FontAwesomeIcons.cloudRain,
        color: Colors.white,
        size: 50,
      );
      //  SvgPicture.asset(
      //   'assets/svg/climacon-cloud_rain.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    } else if (condition == 511) {
      return const FaIcon(
        FontAwesomeIcons.snowflake,
        color: Colors.white,
        size: 50,
      );
      // SvgPicture.asset(
      //   'assets/svg/climacon-sun.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    } else if (condition >= 520 && condition <= 531) {
      return const FaIcon(
        FontAwesomeIcons.cloudShowersHeavy,
        color: Colors.white,
        size: 50,
      );
      //  SvgPicture.asset(
      //   'assets/svg/climacon-cloud_rain.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    } else if (condition >= 600 && condition <= 622) {
      return const FaIcon(
        FontAwesomeIcons.snowflake,
        color: Colors.white,
        size: 50,
      );
      //  SvgPicture.asset(
      //   'assets/svg/climacon-cloud_rain.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    } else if (condition >= 501 && condition <= 781) {
      return const FaIcon(
        FontAwesomeIcons.smog,
        color: Colors.white,
        size: 50,
      );
      //  SvgPicture.asset(
      //   'assets/svg/climacon-cloud_rain.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    } else if (condition == 800) {
      return SvgPicture.asset(
        'assets/svg/sun_icon.svg',
        color: Colors.white,
        width: 50,
        height: 50,
      );
      // const FaIcon(
      //   FontAwesomeIcons.sun,
      //   color: Colors.white,
      //   size: 50,
      // );
      //  SvgPicture.asset(
      //   'assets/svg/climacon-cloud_rain.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    } else if (condition >= 801 && condition <= 804) {
      return const FaIcon(
        FontAwesomeIcons.cloud,
        color: Colors.white,
        size: 50,
      );
      //  SvgPicture.asset(
      //   'assets/svg/climacon-cloud_rain.svg',
      //   color: Colors.white,
      //   width: 50,
      //   height: 50,
      // );
    }
  }

  Widget? getAirIcon(int index) {
    if (index == 1) {
      return Image.asset(
        'image/good.png',
        width: 37.0,
        height: 35.0,
      );
    } else if (index == 2) {
      return Image.asset(
        'image/fair.png',
        width: 37.0,
        height: 35.0,
      );
    } else if (index == 3) {
      return Image.asset(
        'image/moderate.png',
        width: 37.0,
        height: 35.0,
      );
    } else if (index == 4) {
      return Image.asset(
        'image/poor.png',
        width: 37.0,
        height: 35.0,
      );
    } else if (index == 5) {
      return Image.asset(
        'image/bad.png',
        width: 37.0,
        height: 35.0,
      );
    }
  }

  Widget? getAirCondition(int index) {
    if (index == 1) {
      return const Text(
        '"매우좋음"',
        style: const TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (index == 2) {
      return const Text(
        '"좋음"',
        style: const TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (index == 3) {
      return const Text(
        '"보통"',
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (index == 4) {
      return const Text(
        '"나쁨"',
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (index == 5) {
      return const Text(
        '"매우나쁨"',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
