import 'package:cloud_firestore/cloud_firestore.dart';

class DailyData {
  final int? food;
  //final String fullName;
  final String? snacks;

  final Timestamp? date;
  final int? tagcolor;
  //final String? docId;
  DailyData(
      {this.food,
      // required this.fullName,
      this.snacks,
      this.date,
      this.tagcolor
      //this.docId,
      });
  DailyData.fromData(Map<String, dynamic> data)
      : food = data['food'],
        //fullName = data['fullName'],
        snacks = data['snacks'],
        date = data['date'],
        tagcolor = data['tagcolor'];
  //docId = data['docId'];

  Map<String, dynamic> toJson() {
    return {
      'food': food,
      // 'fullName': fullName,
      'snacks': snacks,

      'date': date,
      'tagcolor': tagcolor,
      //'docId': docId,
    };
  }
}
