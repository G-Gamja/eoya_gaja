import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import './addtaskpage.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:table_calendar/table_calendar.dart';

class TaskManagerScreen extends StatefulWidget {
  static const routeName = '/taskmanagerss';
  @override
  _TaskManagerScreenState createState() => _TaskManagerScreenState();
}
//DateFormat.yMMMMd(DateTime.now().toString())

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  // FirebaseFirestore firebase = FirebaseFirestore.instance.collection;
  // void printfire () async {
  //   final dataa = await firebase.collection('User').doc('userdata');
  //   print(dataa.id);
  // }
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'name': 'ahnsihun', // John Doe
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //상태변경용

  String filtertype = 'today';
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFD4E7FE),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.backspace),
        ),
      ),
      body: Container(
        color: Color(0xFFD4E7FE),
        child: Column(
          children: [
            //앱바 아래 오늘 날짜,버button
            Expanded(
              flex: 2,
              child: Container(
                //color: Colors.black,
                decoration: BoxDecoration(
                  color: Colors.indigo[900],
                  //color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 0.75))
                  ],
                ),
                //margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //오늘 날짜
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMd('ko').format(
                                DateTime.now(),
                              ),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '오늘',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        //버튼
                        GestureDetector(
                          onTap: () {
                            Get.to(AddTaskPage(), transition: Transition.zoom);
                          },
                          child: Container(
                            //컨테이너 내부 텍스트 위젯이나 등등의 위젯의 정렬
                            alignment: Alignment.center,
                            //margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              '+ add',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //데이트 픽카
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20),
                      child: DatePicker(
                        DateTime.now(),
                        height: 100,
                        width: 80,
                        initialSelectedDate: DateTime.now(),
                        selectedTextColor: Colors.white,
                        selectionColor: Theme.of(context).primaryColor,
                        dateTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                        locale: "ko_KR",
                        dayTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                        monthTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                        onDateChange: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
               // color: Colors.indigo[400],
                child: Column(
                  
                  children: [
                    SwipeableTile(
                        color: Colors.white,
                        swipeThreshold: 0.2,
                        direction: SwipeDirection.horizontal,
                        onSwiped: (direction) {
                          // Here call setState to update state
                        },
                        backgroundBuilder: (context, direction, progress) {
                          if (direction == SwipeDirection.endToStart) {
                            // return your widget
                          } else if (direction == SwipeDirection.startToEnd) {
                            // return your widget
                          }
                          return Container();
                        },
                        key: UniqueKey(),
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Text(
                            'hi',
                            style: TextStyle(fontSize: 30),
                          ),
                          color: Colors.purple,
                        ) // Here Tile which will be shown at the top
                        ),
                    SwipeableTile.card(
                      color: Colors.indigo,
                      shadow: BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                      horizontalPadding: 16,
                      verticalPadding: 8,
                      direction: SwipeDirection.horizontal,
                      onSwiped: (direction) {
                        // Here call setState to update state
                      },
                      backgroundBuilder: (context, direction, progress) {
                        // You can animate background using the progress
                        return AnimatedBuilder(
                          animation: progress,
                          builder: (context, child) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              color: progress.value > 0.4
                                  ? Color(0xFFed7474)
                                  : Color(0xFFeded98),
                            );
                          },
                        );
                      },
                      key: UniqueKey(),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width-50,
                            child: Text(
                              'hi',
                              style: TextStyle(fontSize: 30),
                            ),
                            color: Colors.indigo[400],
                          )),
                    ),
                    TextButton(onPressed: addUser, child: Text('firebase'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      //https://www.youtube.com/watch?v=N0ey96u8XmE&feature=share
      // body: Stack(
      //   children: [
      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         AppBar(
      //           elevation: 0,
      //           leading: IconButton(
      //             onPressed: () => Navigator.of(context).pop(),
      //             icon: Icon(Icons.backspace),
      //           ),
      //           title: Text(
      //             '다이어리',
      //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //         Container(
      //           color: Colors.amber,
      //           height: 60,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             children: [
      //               //오늘,달력 선택창
      //               Column(
      //                 mainAxisAlignment: MainAxisAlignment.end,
      //                 children: [
      //                   InkWell(
      //                     onTap: () {
      //                       changefilter('today');
      //                     },
      //                     child: Text(
      //                       '오늘',
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: 15,
      //                   ),
      //                   Container(
      //                     color: (filtertype == 'today')
      //                         ? Colors.white
      //                         : Colors.transparent,
      //                     height: 4,
      //                     width: 120,
      //                     //child: Text('hi'),
      //                   )
      //                 ],
      //               ),
      //               Column(
      //                 mainAxisAlignment: MainAxisAlignment.end,
      //                 children: [
      //                   InkWell(
      //                     onTap: () {
      //                       changefilter('calendar');
      //                     },
      //                     child: Text(
      //                       '달력',
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: 15,
      //                   ),
      //                   Container(
      //                     color: (filtertype == 'calendar')
      //                         ? Colors.white
      //                         : Colors.transparent,
      //                     height: 4,
      //                     width: 120,
      //                     //child: Text('hi'),
      //                   )
      //                 ],
      //               )
      //             ],
      //           ),
      //         ),
      //         (filtertype == 'calendar')
      //             ? TableCalendar(
      //                 //locale: 'ko_KR',
      //                 firstDay: DateTime.utc(2010, 10, 16),
      //                 lastDay: DateTime.utc(2030, 3, 14),
      //                 focusedDay: DateTime.now(),
      //                 startingDayOfWeek: StartingDayOfWeek.monday,
      //                 calendarFormat: CalendarFormat.week,
      //                 //onFormatChanged: Cak,
      //               )
      //             : Container()
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  //앱바 하단의 오늘,달력 선택용 함수
  changefilter(String input) {
    filtertype = input;
    setState(() {
      //filtertype = 'input';
    });
  }
}
