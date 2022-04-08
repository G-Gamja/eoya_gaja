import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingData {
  //* 산책시간기록(분단위)
  final int? runningTime;
  //* 산책한 거리(km단위)
  final String? runningRecord;
  final Timestamp? date;
  //todo 산책 맵 사진도 같이 저장해야함
  TrackingData({
    this.runningTime,
    this.runningRecord,
    this.date,
  });
  TrackingData.fromData(Map<String, dynamic> data)
      : runningTime = data['food'],
        //fullName = data['fullName'],
        runningRecord = data['snacks'],
                date = data['date'];

  Map<String, dynamic> toJson() {
    return {
      'runningTime': runningTime,
      // 'fullName': fullName,
      'runningRecord': runningRecord,
      'date': date
    };
  }
}
