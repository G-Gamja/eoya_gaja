import 'dart:async';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eoya_gaja/%20screen/planeReFresh.dart';
import 'package:eoya_gaja/model/dbHelper.dart';
import 'package:eoya_gaja/model/memoDateModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermoji/fluttermoji_assets/fluttermojimodel.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../widgets/floationactbutt.dart';
import '../WarpRefresh.dart';
import '../getstate/getdailydata.dart';
import 'addMeMo.dart';
import 'adddaily.dart';
import 'meMo3.dart';

//todo 캘린더 뷰 패키지 써서 캘린더 형식으로도 볼 수 있도록 해보자 https://pub.dev/packages/calendar_view
//https://pub.dev/packages/calendar_timeline
class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _selectedDate;
  String? dbdate;
  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
    getAllDate();

    //print('hi');
    //adddateSQL();
    //fetchdailyList();
    // Get.put(DailyDataController()).fetchdailyList;
  }

  List<DateTime>? totalDocList = [DateTime.now()];

  // late QuerySnapshot<Map<String, dynamic>> fetchedDailyDataDate;
  // void fetchdailyList() async {
  //   // Future<List<memoDateModel>> a = DBhelper!.getmemoDate();
  //   // Get docs from collection reference
  //   var fetchedDailyDataDate = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('dailydata')
  //       .snapshots();
  //   var a = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('dailydata');
  //   a.doc().id;
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('dailydata')
  //       .snapshots()
  //       .cast();
  //   print(totalDocList![0]);
  //   // Get data from docs and convert map to List

  //   // totalDocList = querySnapshot.docs.map((doc) => doc.data()).toList();

  //   //for a specific field
  //   // final allData =
  //   //     querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();

  //   DocumentReference doc_ref = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('dailydata')
  //       .doc();

  //   DocumentSnapshot docSnap = await doc_ref.get();
  //   // var doc_id2 = docSnap.reference.;
  // }

  void _resetSelectedDate() {
    //_selectedDate = DateTime.now().add(Duration(days: 5));
    if (mounted) {
      setState(() {
        _selectedDate = DateTime.now();
        dbdate = DateFormat('yyyy-MM-dd,EEE').format(_selectedDate);
      });
    }
  }

  //sql로 저장한 날짜값들을 불러오는 과정

  //todo 지금 불러오기가 안돼 setstate써서 데이터 옮겨봐
  void getAllDate() async {
    // var a = await DatabaseHelper.instance.getmemoDate();
    //a.map((memo) => totalDocList!.add(DateTime.parse(memo.enrolledDate)));
    //!! 이거로 진행해
    DatabaseHelper.instance.getmemoDate().then((value) => value.map((element) {
          if (mounted) {
            print(element.enrolledDate);
            print('hi');
            setState(() {
              totalDocList!.add(DateTime.parse(element.enrolledDate));
            });
          }

          // totalDocList!.add(DateTime.parse(element.enrolledDate));
        }));
    // print(totalDocList);
  }

  //되돌아오기할 때 원래 getoff써도 하단 바 살아있게 back할라고.. get.back은 스택 남으니까..
  //저장하고 나서 setstate용도
  FutureOr onGoBack(dynamic value) {
    if (mounted) {
      setState(() {});
    }
  }

  //final Color Theme.of(context).primaryColor = const Color(0xff2e3c81);

  final Color _textColor = const Color(0xff3d4373);

  @override
  Widget build(BuildContext context) {
    //DatabaseHelper.instance.add(memoDateModel(enrolledDate: 'googamja'));

    return WarpIndicator(
        selectedDate: dbdate as String,
        child:
            // FutureBuilder<List<memoDateModel>>(
            //   future: DatabaseHelper.instance.getmemoDate(),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<List<memoDateModel>> snapshot) {
            //     !snapshot.hasData
            //         ? Center(child: Text('hi'))
            //         : snapshot.data!.map((memoDateModel) =>
            //             // totalDocList!.add(DateTime.parse(memoDateModel.enrolledDate
            //             // )),
            //             print('hihihihi'));
            //  return
            Scaffold(
          appBar: CalendarAppBar(
              padding: 50,
              onDateChanged: (date) {
                if (mounted) {
                  setState(() {
                    _selectedDate = date!;
                    dbdate = DateFormat('yyyy-MM-dd,EEE').format(_selectedDate);
                  });
                }
              },
              //(value) => setState(() => selectedDate = value),
              firstDate: DateTime.now().subtract(const Duration(days: 140)),
              selectedDate: _selectedDate, //DateTime.now(),
              lastDate: DateTime.now(),
              //DateTime.now().add(const Duration(days: 5)),
              fullCalendar: true,
              //해당 날짜에 이벤트 마크 표시하는 거 어느 날짜로 할 지를 할당
              events: totalDocList,
              locale: 'ko',
              backButton: false,
              accent: Theme.of(context).primaryColor //Colors.indigo[400],
              ),
          floatingActionButton: FloationgActButton(
              () {
                Get.to(() => addDailyPage(),
                        arguments: _selectedDate,
                        transition: Transition.rightToLeft)!
                    .then(onGoBack);
              },
              '알림추가',
              () {
                //todo 단순메모도 적을 수  있게
                Get.to(() => addMoMoPage(),
                        arguments: _selectedDate,
                        transition: Transition.rightToLeft)!
                    .then(onGoBack);
              },
              '메모작성'),
          backgroundColor: Theme.of(context).primaryColor, //Colors.indigo,
          //appBar:
          // AppBar(
          //   // shape: const RoundedRectangleBorder(
          //   //   borderRadius: BorderRadius.vertical(
          //   //     bottom: Radius.circular(30),
          //   //   ),
          //   // ),
          //   elevation: 0,
          //   backgroundColor: const Color(0xfff5f8ff), //Color(0xFF333A47),
          //   // leading: IconButton(
          //   //   onPressed: () {
          //   //     Get.back();
          //   //   },
          //   //   icon: Icon(Icons.backspace),
          //   // ),
          //   title: Text(
          //     '메모장',
          //     style: GoogleFonts.nanumGothic(
          //       textStyle: TextStyle(
          //           color: Colors.indigo[400],
          //           fontSize: 25,
          //           fontWeight: FontWeight.bold),
          //     ),
          //   ),
          //   centerTitle: true,
          // ),
          body: SafeArea(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(16),
                //   child: Text(
                //     'Calendar Timeline',
                //     style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.tealAccent[100]),
                //   ),
                // ),

                //* 기존 캘린더 타임라인
                // CalendarTimeline(
                //   //showYears: true,
                //   initialDate: _selectedDate,
                //   //todo 왼쪽으로 1월까지 표시되도록 알고리즘 계산할것
                //   firstDate: DateTime.now().subtract(
                //     const Duration(
                //       // days: int.parse(
                //       //   DateFormat('dd').format(_selectedDate),
                //       days: 365,
                //     ),
                //   ),
                //   lastDate: DateTime.now().add(const Duration(days: 365)),
                //   onDateSelected: (date) {
                //     if (mounted) {
                //       setState(() {
                //         _selectedDate = date!;
                //         dbdate =
                //             DateFormat('yyyy-MM-dd,EEE').format(_selectedDate);
                //       });
                //     }
                //   },
                //   leftMargin: 20,
                //   monthColor: Colors.white,
                //   dayColor: Colors.white, //Colors.teal[200],
                //   dayNameColor:
                //       Theme.of(context).primaryColor, //Color(0xFF333A47),
                //   activeDayColor: Theme.of(context).primaryColor, //Colors.white,
                //   activeBackgroundDayColor: Colors.white, //Colors.redAccent[100],
                //   dotsColor:
                //       Theme.of(context).highlightColor, //Color(0xFF333A47),
                //   // selectableDayPredicate: (date) => date.day != 23,
                //   locale: 'ko',
                // ),
                //const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.only(left: 16),
                //   child: TextButton(
                //     style: ButtonStyle(
                //         backgroundColor:
                //             MaterialStateProperty.all(Colors.teal[200])),
                //     child:
                //         Text('RESET', style: TextStyle(color: Color(0xFF333A47))),
                //     onPressed: () => setState(() => _resetSelectedDate()),
                //   ),
                // ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: MeMo3Widget(
                        dbdate!, _selectedDate), //MeMo2Widget(dbdate!),
                  ),
                ),
                //todo 선택된 데이터에 맞는 날짜의 데이터를 보여주면 되겠네!
              ],
            ),
          ),
        )
        //  },
//),
        );
  }
}
