import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class DailyDataController extends GetxController {
  //간식 이름
  String? snacks;
  //하루동안 제공된 음식량
  int? food;
  Timestamp? saveddate;
  int? docLength;
  List? docList;

  List? dbDocList;
  //late DocumentSnapshot<Map<String, dynamic>> fetchedDailyData;
  late QuerySnapshot<Map<String, dynamic>> fetchedDailyData;
  late QuerySnapshot<Map<String, dynamic>> fetchedDailyDate;
  // late QuerySnapshot<Map<String, dynamic>> fetchedDailyDataDate;
  // void fetchdailyList() async {
  //   // Get docs from collection reference
  //   fetchedDailyDataDate = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('dailydata')
  //       .get();

  //   totalDocList = fetchedDailyData.docs.cast();
  //   // Get data from docs and convert map to List

  //   // totalDocList = querySnapshot.docs.map((doc) => doc.data()).toList();

  //   //for a specific field
  //   // final allData =
  //   //     querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();
  // }
  //todo 오류 메시지 throw
  void fetchdailyDB(String selectedDate) async {
    fetchedDailyData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('dailydata')
        .doc(selectedDate)
        .collection('eats')
        .orderBy('date')
        .get();

    docLength = fetchedDailyData.docs.length;
    docList = fetchedDailyData.docs.cast(); //* .cast를 붙여서 썻는데 왜 그런지는 모르겠음

    //snacks = fetchedDailyData['snacks'];
    //food = fetchedDailyData['food'];
    //saveddate = fetchedDailyData['date'];
    update();
  }
}
