import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:swipeable_tile/swipeable_tile.dart';

import '../getstate/getdailydata.dart';

//todo 처음 진입하면 Null check operator used on a null value 오류
//todo 스케쥴 입력 후 리렌더링이 안됨
class MeMo2Widget extends StatefulWidget {
  String selectedDate;
  MeMo2Widget(this.selectedDate);
  @override
  _MeMo2WidgetState createState() => _MeMo2WidgetState();
}

class _MeMo2WidgetState extends State<MeMo2Widget> {
  // Future deleteDaily() async {
  //   try {
  //     //* 신상정보 입력
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .collection('dailydata')
  //         //todo 여기 각 개별 아이디 파라미터로 받아서 지우는거야
  //         .doc()
  //         .delete();
  //   } catch (e) {
  //     return;
  //   }
  // }

  deleteTodo(docId) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('dailydata')
        .doc(widget.selectedDate)
        .collection('eats')
        .doc(docId);

    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get.find<WeatherControlloer>().queryWeather();
    Get.put(DailyDataController()).fetchdailyDB(widget.selectedDate);
    return GetBuilder<DailyDataController>(
      init: DailyDataController(),
      builder: (controller) {
        return controller.docList == null
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: CircularProgressIndicator())
            : ListView.builder(
                //아이템수
                itemCount: controller.docLength,
                itemBuilder: (BuildContext context, int index) {
                  return SwipeableTile.card(
                    color: Colors.black,
                    shadow: BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                    horizontalPadding: 16,
                    verticalPadding: 8,
                    direction: SwipeDirection.startToEnd,
                    onSwiped: (direction) {
                      if (direction == SwipeDirection.startToEnd) {
                        setState(() {
                          deleteTodo(controller
                              .fetchedDailyData.docs[index].reference.id);
                          // controller.fetchedDailyData.docs[index].reference.id
                          // deleteTodo(dailysnapshot.data!.docs[index].reference.id);
                        });
                      }
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
                        width: MediaQuery.of(context).size.width - 50,
                        child: Row(
                          children: [
                            Text(
                              //* 텍스트 위치
                              controller.docList![index]['snacks'],
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
