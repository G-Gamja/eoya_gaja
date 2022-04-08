import 'package:cloud_firestore/cloud_firestore.dart';

class MeMoData {
  final int? food;
  //final String fullName;
  final String? memoContent;

  final Timestamp? date;
  final int? tagcolor;
  //final String? docId;
  MeMoData(
      {this.food,
      // required this.fullName,
      this.memoContent,
      this.date,
      this.tagcolor
      //this.docId,
      });
  MeMoData.fromData(Map<String, dynamic> data)
      : food = data['food'],
        //fullName = data['fullName'],
        memoContent = data['memoContent'],
        date = data['date'],
        tagcolor = data['tagcolor'];
  //docId = data['docId'];

  Map<String, dynamic> toJson() {
    return {
      'food': food,
      // 'fullName': fullName,
      'memoContent': memoContent,

      'date': date,
      'tagcolor': tagcolor,
      //'docId': docId,
    };
  }
}
