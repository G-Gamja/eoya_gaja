import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:eoyagaja/widgets/meMo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:get/get.dart';

import '../../widgets/floationactbutt.dart';
import '../CalendarPage/adddaily.dart';
import '../CalendarPage/meMo3.dart';
import '../getstate/getdailydata.dart';

class OldCalendar extends StatefulWidget {
  static const routeName = '/oldcalendar';
  @override
  _OldCalendarState createState() => _OldCalendarState();
}

class _OldCalendarState extends State<OldCalendar> {
  late DateTime _selectedDate;
  String? dbdate;
  // Future deleteDaily() async {
  //   try {
  //     //* 신상정보 입력
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .collection('dailydata')
  //         .doc('eats')
  //         .delete();
  //   } catch (e) {
  //     return e.printError();
  //   }
  // }

  // @override
  // void initState() {
  //   setState(() {
  //     selectedDate = DateTime.now();
  //   });
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    //_selectedDate = DateTime.now().add(Duration(days: 5));
    if (mounted) {
      setState(() {
        _selectedDate = DateTime.now();
        dbdate = DateFormat('yyyy-MM-dd,EEE').format(_selectedDate);
      });
    }
  }

  FutureOr onGoBack(dynamic value) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // var currentuser = FirebaseAuth.instance.currentUser;
    // Get.put(DailyDataController()).fetchdailyDB();
    return GetBuilder<DailyDataController>(
      init: DailyDataController(),
      builder: (controller) {
        return Scaffold(
          floatingActionButton: FloationgActButton(
              () {
                Get.to(addDailyPage());
              },
              '알림추가',
              () {
                //Get.to(addDailyPage());
              },
              '알림수정'),
          appBar: CalendarAppBar(
            padding: 90,
            onDateChanged: (date) {
              if (mounted) {
                setState(() {
                  _selectedDate = date!;
                  dbdate = DateFormat('yyyy-MM-dd,EEE').format(_selectedDate);
                });
              }
            },
            //(value) => setState(() => selectedDate = value),
            firstDate: DateTime.now().subtract(Duration(days: 140)),
            selectedDate: _selectedDate, //DateTime.now(),
            lastDate: DateTime.now(),
            //DateTime.now().add(const Duration(days: 5)),
            fullCalendar: true,
            //해당 날짜에 이벤트 마크 표시하는 거 어느 날짜로 할 지를 할당
            events: List.generate(10,
                (index) => DateTime.now().subtract(Duration(days: index * 2))),
            locale: 'ko',
            backButton: true,
            accent: Colors.indigo[400],
          ),
          //todo 메모위젯은 그냥 스트림빌더로 구현한건데 날짜 변경시 마다 리빌딩됨
          //getx로 구현한거는 리빌딩 안되긴하는데
          // body: MeMoWidget());

          body: Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: MeMo3Widget(
                      dbdate!, _selectedDate), //MeMo2Widget(dbdate!),
                ),
              ),
            ],
          ),

          //     SingleChildScrollView(
          //   child: SwipeableTile.card(
          //     color: Colors.indigo,
          //     shadow: BoxShadow(
          //       color: Colors.black.withOpacity(0.35),
          //       blurRadius: 4,
          //       offset: Offset(2, 2),
          //     ),
          //     horizontalPadding: 16,
          //     verticalPadding: 8,
          //     direction: SwipeDirection.startToEnd,
          //     onSwiped: (direction) {
          //       if (direction == SwipeDirection.startToEnd) {
          //         deleteDaily();
          //       }
          //     },
          //     backgroundBuilder: (context, direction, progress) {
          //       // You can animate background using the progress
          //       return AnimatedBuilder(
          //         animation: progress,
          //         builder: (context, child) {
          //           return AnimatedContainer(
          //             duration: const Duration(milliseconds: 400),
          //             color: progress.value > 0.4
          //                 ? Color(0xFFed7474)
          //                 : Color(0xFFeded98),
          //           );
          //         },
          //       );
          //     },
          //     key: UniqueKey(),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 0.0),
          //       child: Container(
          //         height: 100,
          //         width: MediaQuery.of(context).size.width - 50,
          //         child: Text(
          //           controller.snacks != null
          //               ? controller.snacks as String
          //               : 'nothing',
          //           style: TextStyle(fontSize: 30),
          //         ),
          //         color: Colors.indigo[400],
          //       ),
          //     ),
          //   ),
          // ),
        );

        //   //   // FutureBuilder(
        //   //   future: FirebaseFirestore.instance
        //   //       .collection('users')
        //   //       .doc(currentuser?.uid)
        //   //       .collection('dailydata')
        //   //       .doc('eats')
        //   //       .get(),
        //   //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //   //     if (snapshot.connectionState == ConnectionState.waiting) {
        //   //       return CircularProgressIndicator();
        //   //     } else if (snapshot.hasData && !snapshot.data!.exists) {
        //   //       return Container();
        //   //     } else
        //   //       return Container(
        //   //         child: SwipeableTile.card(
        //   //           color: Colors.indigo,
        //   //           shadow: BoxShadow(
        //   //             color: Colors.black.withOpacity(0.35),
        //   //             blurRadius: 4,
        //   //             offset: Offset(2, 2),
        //   //           ),
        //   //           horizontalPadding: 16,
        //   //           verticalPadding: 8,
        //   //           direction: SwipeDirection.startToEnd,
        //   //           onSwiped: (direction) {
        //   //             if (direction == SwipeDirection.startToEnd) {
        //   //               deleteDaily();
        //   //             }
        //   //           },
        //   //           backgroundBuilder: (context, direction, progress) {
        //   //             // You can animate background using the progress
        //   //             return AnimatedBuilder(
        //   //               animation: progress,
        //   //               builder: (context, child) {
        //   //                 return AnimatedContainer(
        //   //                   duration: const Duration(milliseconds: 400),
        //   //                   color: progress.value > 0.4
        //   //                       ? Color(0xFFed7474)
        //   //                       : Color(0xFFeded98),
        //   //                 );
        //   //               },
        //   //             );
        //   //           },
        //   //           key: UniqueKey(),
        //   //           child: Padding(
        //   //             padding: const EdgeInsets.symmetric(vertical: 0.0),
        //   //             child: Container(
        //   //               height: 100,
        //   //               width: MediaQuery.of(context).size.width - 50,
        //   //               child: Text(
        //   //                 snapshot.data['snacks'],
        //   //                 style: TextStyle(fontSize: 30),
        //   //               ),
        //   //               color: Colors.indigo[400],
        //   //             ),
        //   //           ),
        //   //         ),
        //   //       );
        //   //   },
        //   // ),
        // ));
      },
    );
  }
}
