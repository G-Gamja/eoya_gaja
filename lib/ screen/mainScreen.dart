import 'package:fancy_bar/fancy_bar.dart';
import 'package:flutter/material.dart';

import '../custom/custom_icons_icons.dart';
import 'CalendarPage/calendarScreen.dart';
import 'Tracking/Tracking.dart';
import 'diary.dart';
import 'statisticsScreen.dart';

//import 'package:geolocator/geolocator.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/mainscreen';

  // String userName;
  //MainScreen(this.weather);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //! 모델에서 바로 뽑아올 수 있도록 수정

  // * late code를 추가 해줘어서 바로 날씨 정보 전달할 수 있도록 했다
  late List<Map<String, Object>> _pages = [
    {
      //todo 모델로 만들어놓은 아이콘 넘겨서 만들어 지도록 컨스트럭터에 선언 떄리기
      'page': DiaryScreen(),
      'title': 'Home',
    },
    {
      'page': Calendar(),
      'title': 'Calendar',
    },
    {
      //*임시로 바로 트래킹 스크린으로 가는것으로 만듬 ui완성해야함
      'page': TrackingScreen(),
      //'page': TrackingMapScreen(),

      'title': 'Sanchack',
    },
    {
      'page': StatsScreen(),
      'title': 'Setting',
    },
  ];
  int _selectedPageIndex = 0;

  // @override
  // void initState() {
  //   _pages = [
  //     {
  //       'page': SettingScreen(),
  //       'title': 'Setting',
  //     },
  //     {
  //       'page': CalendarScreen(),
  //       'title': 'Calendar',
  //     },
  //     {
  //       'page': SanchackScreen(),
  //       'title': 'Sanchack',
  //     },
  //     // SettingScreen(),
  //     // SanchackScreen(),
  //     // CalendarScreen(),
  //   ];
  //   super.initState();
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var pagewidget = _pages[_selectedPageIndex]['page'];

    // queryWeather();

    return Scaffold(
      // appBar: AppBar(
      //   //title: Text(pages[_selectedPageIndex]['page'] as String),
      //   //
      //   title: Text('test'),
      // ),
      body: pagewidget as Widget,
      bottomNavigationBar: FancyBottomBar(
        selectedIndex: _selectedPageIndex,
        onItemSelected: _selectPage,
        type: FancyType.FancyV2,
        items: [
          FancyItem(
              title: 'Home',
              icon: Icon(CustomIcons.apps_3),
              textColor: Color(0xffc5CAE9)),
          FancyItem(
              title: 'Calendar',
              icon: Icon(CustomIcons.access_alarm),
              textColor: Color(0xffc5CAE9)),
          // FancyItem(
          //     title: 'Home',
          //     icon: Icon(Icons.settings),
          //     textColor: Colors.yellow),
          FancyItem(
              title: '산책', icon: Icon(Icons.map), textColor: Color(0xffc5CAE9)),
          FancyItem(
              title: '설정',
              icon: Icon(Icons.settings),
              textColor: Color(0xffc5CAE9)),
        ],
      ),
    );
  }
}
