// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../model/userdata.dart';
import '../widgets/profileImage.dart';
import '../widgets/reviseProfile.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  //* db저장할 url
  //  String urll;
  // late File _pickedimage;
  // late String imageurlroute;
  // void getimage() async {
  //   var image = await ImagePicker.platform.pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 50,
  //     maxWidth: 150,
  //   );
  //   setState(() {
  //     _pickedimage = image as File;
  //   });
  //   await FirebaseAuth.instance.currentUser!.updatePhotoURL(_pickedimage.path);
  // }
  // ignore: non_constant_identifier_names

  //* db에 저장된 url가져오기
  late String DBrul;
  //todo 마저 작업해라 https://medium.com/flutter-community/firebase-startup-logic-and-custom-user-profiles-6309562ea8b7
  Future createUser(UserData user) async {
    try {
      //* 신상정보 입력
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toJson());
    } catch (e) {
      return e.printError();
    }
  }

  //todo set이나 update 차이점 파악해서 프로필url만 빼고 끼어넣을 함수 찾아서 앱바 저장 아이콘에서 파베로 넘기는 기능 구현하기
  Future updateUser(UserData user) async {
    try {
      //* 신상정보 입력
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      return e.printError();
    }
  }

//*db에 저장된 url을 profile 위젯에서 꺼내오기 위한 함수
  // void geturl(String url) {
  //   setState(() {
  //      urll = url;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   assignDB();
  // }

  // late String urll;
  @override
  Widget build(BuildContext context) {
    var currentuser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      floatingActionButton: fab(currentuser),

      backgroundColor: Colors.red, //Color(0xFFD4E7FE),
      appBar: AppBar(
        centerTitle: true,
        title: Text('내 프로필', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFD4E7FE),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.indigo[400],
          ),
        ),

        // actions: [
        //   //수정 페이지 여부에 따른 저장 버튼
        //   revisePage == false
        //       ? Container()
        //       : IconButton(
        //           onPressed: () {
        //             //todo 페이지 변경하고 그냥 저장을 누르면 urll이 지정이 안된상태에서 하는거니까 null이 되어서 초기화가 필요하다고 뜨는거임
        //             //todo 새로 추가가 아니라 일부분만 바꾸는 update형식으로 바꿔보자,
        //             // createUser(
        //             //   UserData(
        //             //       id: currentuser?.uid,
        //             //       email: currentuser?.email,
        //             //       imgurl: urll),
        //             // );
        //             changeRevise(false);
        //             print('save button works');
        //           },
        //           icon: Icon(Icons.save_rounded))
        // ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: Colors.indigo[400], // Colors.white,Colors.indigo[400],
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD4E7FE),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    userProfileImage(),
                    // reviseProfileImage(geturl),
                    //Text('내 프로필'),
                    // Stack(
                    //   children: [
                    //     currentuser?.photoURL == null
                    //         ? Container(
                    //             width: 150,
                    //             height: 200,
                    //             child: Icon(
                    //               Icons.upload_file_sharp,
                    //               size: 100,
                    //             ),
                    //           )
                    //         : Container(
                    //             width: 150,
                    //             height: 200,
                    //             //child: Text('hi'),
                    //             decoration: BoxDecoration(
                    //               color: Colors.indigo,
                    //               borderRadius: BorderRadius.circular(100),
                    //               image: DecorationImage(
                    //                   //colorFilter: ColorFilter.mode(color, blendMode),
                    //                   image: AssetImage(
                    //                       'assets/images/gamjaprofile.jpeg'
                    //                       //currentuser.photoURL
                    //                       ),
                    //                   fit: BoxFit.cover),
                    //             ),
                    //           ),
                    //     Positioned(
                    //         right: 1,
                    //         bottom: 1,
                    //         child: ElevatedButton(
                    //           onPressed: () {
                    //             getimage();
                    //           },
                    //           child: Icon(Icons.add_rounded),
                    //           style: ElevatedButton.styleFrom(
                    //             shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(100)),
                    //             //shadowColor: Theme.of(context).primaryColor,
                    //           ),
                    //         ))
                    //     //IconButton(onPressed: null, icon: Icon(Icons.plus_one_rounded))
                    //   ],
                    // ),
                    Column(
                      children: [
                        Text(
                          '구감자',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text('대표집사: 안시헌'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentuser?.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return Text("Document does not exist");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //todo db에 데이터가 존재하지 않으면 오류생김 조건문 걸어서 다르게 렌더링 해야할듯
                              belowstats('생년월일', '6'),
                              verticaldivider(3.0, 30.0),
                              belowstats(
                                  '견종',
                                  data['dogBreed'] == null
                                      ? '빈칸'
                                      : data['dogBreed']),
                              verticaldivider(3.0, 30.0),
                              belowstats('등록된 가족', '3명'),
                            ],
                          );
                          //DBrul = data['imgurl'];
                          //Text("Full Name: ${data['email']} ${data['id']}");
                        }

                        return Text("loading");
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.indigo[400],
                child: Column(
                  children: [
                    Text(
                      '${FirebaseAuth.instance.currentUser!.displayName} hi',
                      //! 이거는 저장된 데이터 가져오는 그런거임
                      // '${FirebaseFirestore.instance.collection('users').doc(currentuser?.uid).get().then(
                      //   (DocumentSnapshot snapshot){
                      //     snapshot['email'];
                      //   }
                      // )}',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),

                    //todo Form 으로 다중 텍스트폼필드 처리 쉽게하기 https://blog.codefactory.ai/flutter/form/
                    //todo \
                    // Container(
                    //   child: Center(
                    //     child: _pickedimage == null
                    //         ? CircleAvatar(
                    //             backgroundColor: Colors.black,
                    //           )
                    //         : CircleAvatar(
                    //             backgroundColor: Colors.black,
                    //             backgroundImage: FileImage(
                    //               File(_pickedimage.path
                    //                   //currentuser?.photoURL
                    //                   ),
                    //             ),
                    //           ),
                    //   ),
                    // ),
                    //* firestore에 저장한 이미지,데이터베이스 파일 되찾아 오는거 공홈 코드 카피한것임
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentuser?.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return Text("Document does not exist");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return //DBrul = data['imgurl'];
                              Text(
                                  "Full Name: ${data['email']} ${data['id']} ${data['dogName']}");
                        }

                        return Text("loading");
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //*Floating action button
  SpeedDial fab(User? currentuser) {
    return SpeedDial(
      child: Icon(Icons.apps_rounded),
      closedForegroundColor: Colors.indigo[400],
      openForegroundColor: Colors.white,
      closedBackgroundColor: Colors.white,
      openBackgroundColor: Colors.indigo[400],
      //labelsStyle: //TextStyle(),//*버튼 옆  레이블,
      //controller:  /* Your custom animation controller goes here */,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: Icon(Icons.directions_run),
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          label: 'Let\'s start a run!',
          onPressed: () {
            // print('it works');
            // createUser(
            //   UserData(
            //       id: currentuser?.uid,
            //       email: currentuser?.email,
            //       imgurl: urll),
            // );
          },
          closeSpeedDialOnPressed: false,
        ),
        SpeedDialChild(
          child: Icon(Icons.home_repair_service_rounded),
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow,
          label: '프로필 수정하기',
          onPressed: () {
            Get.to(() => reviseProfileImage());
          },
        ),
        //  Your other SpeeDialChildren go here.
      ],
    );
  }

  Container verticaldivider(widthsize, heightsize) {
    return Container(
      width: widthsize,
      height: heightsize,
      decoration: BoxDecoration(
          color: Colors.indigoAccent, borderRadius: BorderRadius.circular(10)),
    );
  }

  Column belowstats(headtext, subtext) {
    return Column(
      children: [
        Text(
          headtext,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(subtext, style: TextStyle(fontSize: 14))
      ],
    );
  }
}
