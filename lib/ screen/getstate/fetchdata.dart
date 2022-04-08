import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class FetchdDbController extends GetxController {
 String? dburl;
 late DocumentSnapshot<Map<String, dynamic>> fetchedData;
  void assignDB() async {
    var fetchedData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
     dburl = fetchedData['imgurl'];
     update();
    // setState(() {
    //   DBrul = fetchedData['imgurl'];
    // });
  }
}