import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ej_stepper/ej_stepper.dart';
import 'package:eoya_gaja/widgets/backButton.dart';
import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../model/dailydata.dart';

//*하루의 산책량이나 제공한 간식,식사의 양을 기록하는 페이지
// ignore: camel_case_types
class addMoMoPage extends StatefulWidget {
  @override
  _addMoMoPageState createState() => _addMoMoPageState();
}

// ignore: camel_case_types
class _addMoMoPageState extends State<addMoMoPage> {
  final _formKey = GlobalKey<FormState>();
  //간식 종류
  String? _snackvariation;
  //밥량
  int? foodVolume;
  //해당 날짜
  Timestamp _selectedDate = Timestamp.fromDate(DateTime.now());
  //!제시할 간식종류/ 일단 예시로 한거라 수정하던가 말던강
  List<String> _snackvariationList = ['메모', '쫀디기', '아폴로'];
  // 스탭퍼용 변수 수정해서 쓸 것
  String? firstName;
  String? lastName;

  //String dbdate = DateFormat('eee-yyyy-MM-dd').format(DateTime.now());
  String? dbdate;
  Future createDaily(DailyData daily, String dbdate) async {
    try {
      //* 신상정보 입력
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('dailydata')
          .doc(dbdate)
          .collection('eats')
          .doc()
          .set(daily.toJson());
    } catch (e) {
      return e.printError();
    }
  }

  // String getdate = DateFormat('yyyy-MM-dd').format(Get.arguments) +
  //     '-' +
  //     DateTime.now().hour.toString() +
  //     '-' +
  //     DateTime.now().minute.toString();
  //  +
  //     ' ' +
  //     DateTime.now().hour.toString();
  void saveForm() {
    //birthTimestamp = Timestamp.fromDate(_selectedDate);
    //_formKey.currentState?.save();
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState?.save();
    }
  }

  //데이트 픽커에 시간까지 날라오게하기위한코드- 현재 작동X
  // String? _getdate;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   pickedDate(Get.arguments);
  //   print(_getdate);
  //   print(DateTime.now().toString());
  //   setState(() {});
  // }

  // void pickedDate(DateTime selectedDate) {
  //   setState(() {
  //     _getdate = DateFormat('yyyy-MM-dd').format(selectedDate) +
  //         ' ' +
  //         DateTime.now().hour.toString() +
  //         ':' +
  //         DateTime.now().minute.toString();
  //   });
  // }

  //ANCHOR 기존 선택 날짜 값 받아왔던거
  String _getdate = DateFormat('yyyy-MM-dd').format(Get.arguments);
  Color _pickerColor = Color(0xFFD4E7FE);
  final Color _deepBlue = const Color(0xff1d256e);
  final Color _lightPurple = const Color(0xff8a80fe);
  final Color _textColor = const Color(0xff3d4373);
  final Color _backGroungColor = const Color(0xfff5f8ff);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // final String selectDate =  DateFormat().format(Get.arguments);

    return Scaffold(
      //*키보드 입력창 때문에 오버플로우 걸리지 않도록
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: _backGroungColor,
          leading: BlueBackButton(
            deepBlue: _deepBlue,
            // onPressed: Get.back(),
          )),
      //* 키보드창이 올라오면 렌더오류가 생긴다면 이렇게 스크롤되는 창으로 만들고 리버스 값주면 맨아래가
      //붙어서 렌더링됨
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                //강아지이름,나이,견종, 집사이름
                children: [
                  textformfield(context,
                      // focusNode: _masterNameFocusNode,
                      onsaved: (val) {
                    setState(() {
                      this.foodVolume = int.parse(val);
                    });
                    // this.masterName = val;
                  }, hint: '밥 량'),
                  SizedBox(
                    height: 10,
                  ),
                  //todo 사용법 더 알아내기
                  DropdownSearch<String>(
                    validator: (v) => v == null ? "견종을 안 정했어요" : null,
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "견종을 선택하세요",
                      labelText: "간식 종류",
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      //todo 다른 텍스트 폼 필드랑 디자인 맞추기
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    mode: Mode.DIALOG,
                    showSelectedItems: true,
                    items: this._snackvariationList,
                    showClearButton: true,
                    //* 여기에 db에 넣을 값 setstate 해주면 되겠당
                    onChanged: (val) {
                      setState(() {
                        this._snackvariation = val;
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
                          content: Text("...you want to clear the selection"),
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
                  DateTimePicker(
                    locale: Locale('ko'),
                    type: DateTimePickerType.dateTimeSeparate,
                    // dateMask: 'yyyy, MMM DDD',
                    initialValue:
                        _getdate, // getdate, //+ DateTime.now().hour.toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: '날짜',
                    timeLabelText: "시간",
                    // selectableDayPredicate: (ddate) {
                    //   // Disable weekend days to select from the calendar
                    //   if (ddate.weekday == 6 || ddate.weekday == 7) {
                    //     return false;
                    //   }

                    //   return true;
                    // },
                    //onChanged: (val) => print(val),
                    // validator: (val) {
                    //   print(val);
                    //   return null;
                    // },
                    onSaved: //(val) => print(val),
                        (val) {
                      setState(
                        () {
                          this._selectedDate = Timestamp.fromDate(
                            DateTime.parse(val!),
                          );
                          dbdate = DateFormat('yyyy-MM-dd,EEE')
                              .format(DateTime.parse(val));
                        },
                      );
                    },
                  ),
                  EJStepper(
                    onLastStepConfirmTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                firstName != null &&
                                        firstName!.isNotEmpty &&
                                        lastName != null &&
                                        lastName!.isNotEmpty
                                    ? Icons.check_circle_outline
                                    : Icons.close,
                                size: 100,
                                color: firstName != null &&
                                        firstName!.isNotEmpty &&
                                        lastName != null &&
                                        lastName!.isNotEmpty
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              SizedBox(height: 8),
                              Text(
                                firstName != null &&
                                        firstName!.isNotEmpty &&
                                        lastName != null &&
                                        lastName!.isNotEmpty
                                    ? 'Done'
                                    : 'Fill all fields',
                                style: textTheme.headline5,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    steps: [
                      EJStep(
                        title: Text(
                          'First Name',
                          style: textTheme.bodyText1,
                        ),
                        subtitle: firstName != null && firstName!.isNotEmpty
                            ? Text(
                                firstName!,
                                style: textTheme.subtitle2
                                    ?.copyWith(color: Colors.grey),
                              )
                            : null,
                        leftWidget: Icon(
                          Icons.person,
                          size: 30,
                        ),
                        state: firstName != null && firstName!.isNotEmpty
                            ? EJStepState.complete
                            : EJStepState.enable,
                        content: TextField(
                          onChanged: (value) {
                            setState(() {
                              firstName = value;
                            });
                          },
                        ),
                      ),
                      EJStep(
                          title: Text(
                            'Last Name',
                            style: textTheme.bodyText1,
                          ),
                          subtitle: lastName != null && lastName!.isNotEmpty
                              ? Text(
                                  lastName ?? '',
                                  style: textTheme.subtitle2
                                      ?.copyWith(color: Colors.grey),
                                )
                              : null,
                          leftWidget: Icon(
                            Icons.perm_contact_calendar_rounded,
                            size: 30,
                          ),
                          state: lastName != null && lastName!.isNotEmpty
                              ? EJStepState.complete
                              : EJStepState.enable,
                          content: TextField(
                            onChanged: (value) {
                              setState(() {
                                lastName = value;
                              });
                            },
                          ),
                          stepEnteredLeftWidget:
                              Text('Hint: enter Your last Name')),
                    ],
                  ),
                  //* 기존에 사용했던 컬러픽커-다양한 색을 직접 뽑는거에 넣으면 좋을듯
                  // Row(
                  //   children: [
                  //     CircleAvatar(
                  //       backgroundColor: currentColor,
                  //     ),
                  //     TextButton(
                  //         onPressed: () {
                  //           showDialog(
                  //               context: context,
                  //               builder: (BuildContext context) {
                  //                 return AlertDialog(
                  //                   //todo ColorPicker titlestyle
                  //                   shape: RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.all(
                  //                           Radius.circular(30.0))),
                  //                   titleTextStyle: GoogleFonts.firaSans(
                  //                     textStyle: TextStyle(
                  //                         color: Colors.black,
                  //                         fontSize: 20,
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                   title: const Text('태그 컬러를 선택해주세요'),
                  //                   content: SingleChildScrollView(
                  //                     // child: ColorPicker(
                  //                     //   pickerColor: pickerColor,
                  //                     //   onColorChanged: changeColor,
                  //                     // ),
                  //                     // Use Material color picker:
                  //                     //
                  //                     // child: MaterialPicker(
                  //                     //   pickerColor: pickerColor,
                  //                     //   onColorChanged: changeColor,
                  //                     //   enableLabel:
                  //                     //       true, // only on portrait mode
                  //                     // ),
                  //                     //
                  //                     // Use Block color picker:
                  //                     //
                  //                     child: BlockPicker(
                  //                       pickerColor: pickerColor,
                  //                       onColorChanged: changeColor,
                  //                     ),
                  //                   ),
                  //                   actions: <Widget>[
                  //                     Container(
                  //                       alignment: Alignment.center,
                  //                       child: ElevatedButton(
                  //                         child: const Text('이 색으로 할래요'),
                  //                         onPressed: () {
                  //                           setState(() =>
                  //                               currentColor = pickerColor);
                  //                           Navigator.of(context).pop();
                  //                         },
                  //                         style: ButtonStyle(
                  //                           backgroundColor:
                  //                               MaterialStateProperty.all(
                  //                                   Colors.redAccent[100]),
                  //                           // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                  //                           textStyle:
                  //                               MaterialStateProperty.all(
                  //                             GoogleFonts.firaSans(
                  //                               textStyle: TextStyle(
                  //                                   color: Colors.black,
                  //                                   fontSize: 20,
                  //                                   fontWeight:
                  //                                       FontWeight.bold),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 );
                  //               });
                  //         },
                  //         child: Text(
                  //           '태그컬러',
                  //           style: TextStyle(color: currentColor),
                  //         )),
                  //   ],
                  // ),
                  FastColorPicker(
                    selectedColor: _pickerColor,
                    onColorSelected: (color) {
                      setState(() {
                        _pickerColor = color;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.add, size: 18),
                label: Text(
                  "돌아가기",
                  style: TextStyle(color: Colors.black38),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                  // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                  textStyle: MaterialStateProperty.all(
                    GoogleFonts.firaSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  saveForm();
                  createDaily(
                      //* 수정할 놈만 파라미터로 넘겨야하는데 빈 놈도 넘겨버리니까 null로 업데이틑 되는거임
                      DailyData(
                          food: foodVolume,
                          snacks: _snackvariation,
                          date: _selectedDate,
                          tagcolor: _pickerColor.hashCode
                          // docId: FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(FirebaseAuth.instance.currentUser?.uid)
                          //     .collection('dailydata')
                          //     .doc(dbdate)
                          //     .collection('eats')
                          //     .doc()
                          //     .id),
                          ),
                      dbdate as String);
                  //! !!!! 그냥 겟백쓰면 setstate 안걸리고 바로 캘린더 스크린가면 네비게이션바 사리지고 메인 스크린쓰면 첫 페이지로 넘어감 띠용
                  //Get.off(()=>MainScreen());
                  Get.back();
                  //todo 잘 안보임

                  Get.snackbar('저장완료', '저장이 완료되었습니다');
                },
                icon: FaIcon(FontAwesomeIcons.plus),
                label: Text("저장하기"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.redAccent[100]),
                  // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                  textStyle: MaterialStateProperty.all(
                    GoogleFonts.firaSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              //* 기존 저장버튼
              // IconButton(
              //   onPressed: () async {
              //     saveForm();
              //     createDaily(
              //         //* 수정할 놈만 파라미터로 넘겨야하는데 빈 놈도 넘겨버리니까 null로 업데이틑 되는거임
              //         DailyData(
              //             food: foodVolume,
              //             snacks: _snackvariation,
              //             date: _selectedDate,
              //             tagcolor: currentColor.value
              //             // docId: FirebaseFirestore.instance
              //             //     .collection('users')
              //             //     .doc(FirebaseAuth.instance.currentUser?.uid)
              //             //     .collection('dailydata')
              //             //     .doc(dbdate)
              //             //     .collection('eats')
              //             //     .doc()
              //             //     .id),
              //             ),
              //         dbdate as String);
              //     //! !!!! 그냥 겟백쓰면 setstate 안걸리고 바로 캘린더 스크린가면 네비게이션바 사리지고 메인 스크린쓰면 첫 페이지로 넘어감 띠용
              //     //Get.off(()=>MainScreen());
              //     Get.back();
              //     //todo 잘 안보임

              //     Get.snackbar('저장완료', '저장이 완료되었습니다');
              //   },
              //   icon: Icon(Icons.save_rounded, color: Colors.indigo[400]),
              // ),
            ],
          )
        ],
      ),
    );
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
