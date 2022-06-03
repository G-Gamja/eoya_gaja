import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

import '../ screen/getstate/fetchdata.dart';
import '../model/firestorage.dart';
import '../model/userdata.dart';

// ignore: camel_case_types
class reviseProfileImage extends StatefulWidget {
  @override
  _reviseProfileImageState createState() => _reviseProfileImageState();
}

// ignore: camel_case_types
class _reviseProfileImageState extends State<reviseProfileImage> {
  File? _pickedimage;
  ImagePicker _picker = ImagePicker();
  late String imageurlroute;
  FileStorage _fileStorage = Get.put(FileStorage());

  FocusNode? _masterNameFocusNode;
  FocusNode? _dogNameFocusNode;
  // final _ageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String? dogname;
  String? dogbreed;
  String? masterName;
  //견종 리스트
  List<String>? breedList = ["포메라니안", "비숑", "푸들", '믹스'];
  //생년 월일 데이터(db보내기 전)
  DateTime _selectedDate = DateTime.now();
  //(db에 넣을 타임스탬프)
  //Timestamp? birthTimestamp = Timestamp.fromDate(_selectedDate);
  //*파일 자체를 스토리지에 저장후 저장된 url을 바깥으로 꺼내 그 url을 db에 저장
  void getimageCamera() async {
    var image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 150,
    );
    File tmpfile = File(image!.path);
    //_pickedimage = tmpfile;
    // final ref = FirebaseStorage.instance
    //     .ref()
    //     .child('user_image')
    //     .child('${FirebaseAuth.instance.currentUser?.uid}' + '.jpg');
    //해당경로에 인자로 넣은 파일을 저장
    //onComplete는 future로 만들어줌

    String url = await _fileStorage.uploadFile(tmpfile.path,
        'user_image/' + '${FirebaseAuth.instance.currentUser?.uid}' + '.jpg');
    setState(() {
      imageurlroute = url;
      _pickedimage = tmpfile;
    });
    // updateUser(
    //   UserData(
    //     imgurl: imageurlroute,
    //   ),
    // );
    //imageurlroute = url;
    //! 기존 프로젝트랑 비교해서 사진 그냥 File로 받을 수 있도록 수정하기
    // await ref.putFile(image as File);
    //업로드된 사진의 url을 가져오기
    //final imageUrl = await ref.getDownloadURL();
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(tmpfile.path);

    // setState(() {
    //   imageurlroute = url;
    //   //imageurlroute = imageUrl;
    // });
  }

  void getimageGallery() async {
    var image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 150,
    );
    File tmpfile = File(image!.path);
    // final ref = FirebaseStorage.instance
    //     .ref()
    //     .child('user_image')
    //     .child('${FirebaseAuth.instance.currentUser?.uid}' + '.jpg');
    //해당경로에 인자로 넣은 파일을 저장
    //onComplete는 future로 만들어줌
    String url = await _fileStorage.uploadFile(tmpfile.path,
        'user_image/' + '${FirebaseAuth.instance.currentUser?.uid}' + '.jpg');
    setState(() {
      imageurlroute = url;
    });
    //! 기존 프로젝트랑 비교해서 사진 그냥 File로 받을 수 있도록 수정하기
    // await ref.putFile(image as File);
    //업로드된 사진의 url을 가져오기
    //final imageUrl = await ref.getDownloadURL();
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(tmpfile.path);

    // setState(() {
    //   imageurlroute = url;
    //   //imageurlroute = imageUrl;
    // });
  }

  @override
  void initState() {
    super.initState();
    _masterNameFocusNode = FocusNode();
    _dogNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _masterNameFocusNode?.dispose();
    _dogNameFocusNode?.dispose();
    super.dispose();
  }

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

  void saveForm() {
    //birthTimestamp = Timestamp.fromDate(_selectedDate);
    //_formKey.currentState?.save();
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentuser = FirebaseAuth.instance.currentUser;
    //Get.find<FetchdDbController>().assignDB();
    Get.put(FetchdDbController()).assignDB();
    //! 임시로 테스트 해볼라고 설정해놓은건데 아이콘 버튼 만들면 거기로 옮기자
    Timestamp? birthTimestamp = Timestamp.fromDate(_selectedDate);
    //final _breedFocusNode = FocusNode();
    return GetBuilder<FetchdDbController>(
      builder: (fetchedDb) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              '프로필 수정',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo[400],
              ),
            ),
            backgroundColor: Color(0xFFD4E7FE),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.keyboard_backspace_rounded,
                color: Colors.indigo[400],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  saveForm();
                  createUser(
                    //* 수정할 놈만 파라미터로 넘겨야하는데 빈 놈도 넘겨버리니까 null로 업데이틑 되는거임
                    UserData(
                        id: currentuser?.uid,
                        email: currentuser?.email,
                        imgurl: imageurlroute,
                        dogName: dogname,
                        dogBreed: dogbreed,
                        masterName: masterName,
                        birthDay: birthTimestamp),
                  );

                  Get.back();
                  Get.snackbar('프로필 수정 완료', '프로필이 수정되었어요!');
                },
                icon: Icon(Icons.save_rounded, color: Colors.indigo[400]),
              ),
            ],
          ),
          body: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //todo dbd에 저장된 이미지 패스가 아니라 즉각적으로 이미지 바뀌도록 조건문 하나 더 달기
                //*이미지
                Stack(
                  children: [
                    fetchedDb.dburl == null
                        // &&
                        // ignore: unnecessary_null_comparison
                        //imageurlroute == null
                        ? Container(
                            width: 150,
                            height: 200,
                            child: Icon(
                              Icons.upload_file_sharp,
                              size: 100,
                            ),
                          )
                        : fetchedDb.dburl != null && _pickedimage == null
                            ? Container(
                                width: 150,
                                height: 200,
                                //child: Text('hi'),
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      //image:
                                      // FileImage(
                                      //   File(_pickedimage?.path as String
                                      //       //currentuser?.photoURL
                                      //       ),
                                      // ),
                                      image:
                                          //FileImage(File(_pickedimage.path)),
                                          NetworkImage(
                                              fetchedDb.dburl as String),
                                      //image: AssetImage('assets/images/gamjaprofile.jpeg'),
                                      fit: BoxFit.fill),
                                ),
                              )
                            : Container(
                                width: 150,
                                height: 200,
                                //child: Text('hi'),
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      //image:
                                      // FileImage(
                                      //   File(_pickedimage?.path as String
                                      //       //currentuser?.photoURL
                                      //       ),
                                      // ),
                                      image: FileImage(
                                          File(_pickedimage?.path as String)),
                                      // NetworkImage(fetchedDb.dburl as String),
                                      //image: AssetImage('assets/images/gamjaprofile.jpeg'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                    Positioned(
                        right: 1,
                        bottom: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            //todo 가운데 정렬 시키기
                            //todo 실행 후 저절로 내려가게 -> 코드 수정했으니 디버깅 해보세요 | 수정완료
                            showAdaptiveActionSheet(
                              context: context,
                              actions: <BottomSheetAction>[
                                BottomSheetAction(
                                  title: const Text(
                                    '카메라',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    getimageCamera();
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  leading: const Icon(
                                      Icons.camera_enhance_rounded,
                                      size: 25),
                                ),
                                BottomSheetAction(
                                  title: const Text(
                                    '갤러리',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    getimageGallery();
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  leading: const Icon(
                                    Icons.picture_in_picture_alt_rounded,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                              cancelAction: CancelAction(
                                title: const Text('Cancel'),
                              ),
                            );
                          },
                          child: Icon(Icons.add_rounded),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            //shadowColor: Theme.of(context).primaryColor,
                          ),
                        ))
                    //IconButton(onPressed: null, icon: Icon(Icons.plus_one_rounded))
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          //강아지이름,나이,견종, 집사이름
                          children: [
                            textformfield(context,
                                focusNode: _dogNameFocusNode,
                                nextNode: _masterNameFocusNode, onsaved: (val) {
                              setState(() {
                                this.dogname = val;
                              });
                            }, hint: '강아지 이름'),
                            SizedBox(
                              height: 10,
                            ),
                            textformfield(context,
                                focusNode: _masterNameFocusNode,
                                onsaved: (val) {
                              setState(() {
                                this.masterName = val;
                              });
                              // this.masterName = val;
                            }, hint: '집사 이름'),
                            SizedBox(
                              height: 10,
                            ),
                            //todo 사용법 더 알아내기
                            DropdownSearch<String>(
                              validator: (v) => v == null ? "견종을 안 정했어요" : null,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "견종을 선택하세요",
                                labelText: "주인님의 가문",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                //todo 다른 텍스트 폼 필드랑 디자인 맞추기
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              mode: Mode.DIALOG,
                              showSelectedItems: true,
                              items: this.breedList,
                              showClearButton: true,
                              //* 여기에 db에 넣을 값 setstate 해주면 되겠당
                              onChanged: (val) {
                                setState(() {
                                  this.dogbreed = val;
                                });
                              },
                              popupItemDisabled: (String? s) =>
                                  s?.startsWith('I') ?? false,
                              clearButtonSplashRadius: 20,
                              //selectedItem: "Tunisia",
                              onBeforeChange: (a, b) {
                                if (b == null) {
                                  AlertDialog alert = AlertDialog(
                                    title: Text("다시 선택하실려구요?"),
                                    content: Text(
                                        "...you want to clear the selection"),
                                    actions: [
                                      TextButton(
                                        child: Text("넹"),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("아니용 ㅠ"),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                    ],
                                  );

                                  return showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      });
                                }

                                return Future.value(true);
                              },
                            ),

                            //todo 텍폼필에서 데이트 피커 구현한거 찾아보자
                            //? 그냥 텍폼필 말고 아이콘버튼으로 구현해버리자 이미지픽커처럼 그럼 onsaved문제 없어
                            // textformfield(context,
                            //     datex: _getdate,
                            //     onsaved: (val) => this._selectedDate = val,
                            //     hint: DateFormat.yMMMd('ko_KR')
                            //         .format(_selectedDate))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      init: FetchdDbController(),
    );
  }

  _getdate() async {
    DateTime? _pickerDate = await showDatePicker(
      //한글 쓰려면 https://suyou.tistory.com/tag/DatePicker 이 사이트 참고해서 다시 빌드업해
      locale: Locale('ko'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF8CE7F1),
            accentColor: const Color(0xFF8CE7F1),
            colorScheme: ColorScheme.light(primary: const Color(0xFF8CE7F1)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        // birthTimestamp = Timestamp.fromDate(_selectedDate);
      });
    } else {
      print('its null');
    }
  }

  Widget textformfield(BuildContext context,
      {FocusNode? focusNode,
      FocusNode? nextNode,
      FormFieldSetter? onsaved,
      String? hint,
      dynamic datex}) {
    assert(onsaved != null);
    return TextFormField(
      //읽기전용여부/읽기전용이면 날짜 선택 아이콘 만 활성화됨
      readOnly: datex == null ? false : true,
      //*각 폼필드에 입력된 값을 getvalue에 저장(getvalue는 프로필 속성)
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: onsaved,
      onTap: datex,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '빈칸으로 두시면 안돼요!';
        }
        return null;
      },
      //readOnly: datex == null ? false : true,
      focusNode: focusNode,
      //입력 완료시 지정된 다음 포커스 노드로 이동
      onFieldSubmitted: (_) {
        //!원래는 다음 입력창의 포커스 노드를 썼었음
        FocusScope.of(context).requestFocus(nextNode);
      },
      autofocus: false,
      cursorColor: Colors.orange,
      //controller: txtcontroller,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.indigo[400],
      ),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.blue,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey, width: 3),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        hintText: hint,
        //labelText: hint,
        hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        //밑줄 색깔

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          // borderSide: BorderSide(
          //   //color: Colors.indigo.shade100,
          //   width: 2.0,
          // ),
        ),
      ),
    );
  }
}
