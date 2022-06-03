import 'package:eoya_gaja/%20screen/statisticsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import 'CalendarPage/calendarScreen.dart';
import 'Tracking/Tracking.dart';
import 'diary.dart';

class MainScreen2 extends StatefulWidget {
  const MainScreen2({Key? key}) : super(key: key);

  @override
  _MainScreen2State createState() => _MainScreen2State();
}

class _MainScreen2State extends State<MainScreen2> {
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    /// [AnnotatedRegion<SystemUiOverlayStyle>] only for android black navigation bar. 3 button navigation control (legacy)

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        //todo bottom navigation bar blank color
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //animatedswitcher로 변경해보기
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            DiaryScreen(),
            Calendar(),
            TrackingScreen(),
            StatsScreen(),
          ],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius:
              //BorderRadius.circular(20),
              //BorderRadius.only()
              BorderRadius.vertical(top: Radius.circular(20)),
          // BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          child: WaterDropNavBar(
            waterDropColor:
                Theme.of(context).highlightColor, // Color(0xff1d256e),
            backgroundColor: navigationBarColor,
            onItemSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
              pageController.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad);
            },
            selectedIndex: selectedIndex,
            barItems: <BarItem>[
              BarItem(
                filledIcon: FontAwesomeIcons.drawPolygon,
                outlinedIcon: Icons.bookmark_border_rounded,
              ),
              BarItem(
                  filledIcon: Icons.favorite_rounded,
                  outlinedIcon: Icons.favorite_border_rounded),
              BarItem(
                filledIcon: Icons.email_rounded,
                outlinedIcon: Icons.email_outlined,
              ),
              BarItem(
                filledIcon: Icons.folder_rounded,
                outlinedIcon: Icons.folder_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
