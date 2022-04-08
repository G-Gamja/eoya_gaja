import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class MeMoWidget extends StatefulWidget {
  String? selectedDate;
  MeMoWidget(this.selectedDate);
  @override
  _MeMoWidgetState createState() => _MeMoWidgetState();
}

class _MeMoWidgetState extends State<MeMoWidget> {
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
  Widget build(BuildContext context) {
    var currentuser = FirebaseAuth.instance.currentUser;
    // Get.find<WeatherControlloer>().queryWeather();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentuser?.uid)
          .collection('dailydata')
          .doc(widget.selectedDate)
          .collection('eats')
          .orderBy('date', descending: true)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> dailysnapshot) {
        if (dailysnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (dailysnapshot.data!.docs.length == 0) {
          //* 선택날짜 당일 기록이 아무것도 없으면 출력될 위젯
          return Center(
            child: Column(
              children: [
               Text(
                        '오늘은 기록된게 아직 없어요'
                        ,
                        style: GoogleFonts.firaSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                Text(
                        '집사님이 배가 고파하지는 않으실까요? :('
                        ,
                        style: GoogleFonts.firaSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          );
        } else if (dailysnapshot.hasData || dailysnapshot.data != null) {
          final dailydoc = dailysnapshot.data!.docs;
          return ListView.builder(
            //아이템수
            itemCount: dailydoc.length,
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
                      deleteTodo(dailysnapshot.data!.docs[index].reference.id);
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
                    child: Text(
                      //* 텍스트 위치
                      dailydoc[index]['snacks'],
                      style: TextStyle(fontSize: 30),
                    ),
                    color: Colors.indigo[400],
                  ),
                ),
              );
            },
          );
        }
        return Center(
          //*알수없는 오류
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
