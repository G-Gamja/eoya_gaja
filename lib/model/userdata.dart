import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? id;
  //final String fullName;
  final String? email;
  final String? imgurl;
   final String? dogName;
  final String? dogBreed;
  final String? masterName;
  final Timestamp? birthDay;
  UserData({
    this.id,
    // required this.fullName,
    this.email,
    this.imgurl,
    this.dogName,
    this.dogBreed,
    this.masterName,
    this.birthDay,
  });
  UserData.fromData(Map<String, dynamic> data)
      : id = data['id'],
        //fullName = data['fullName'],
        email = data['email'],
        imgurl = data['imgurl'],
        dogName = data['dogName'],
        dogBreed = data['dogBreed'],
        masterName = data['masterName'],
        birthDay = data['birthDay']
        ;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'fullName': fullName,
      'email': email,
      'imgurl': imgurl,
      'dogName': dogName,
      'dogBreed': dogBreed,
      'masterName': masterName,
      'birthDay': birthDay
    };
  }
}
