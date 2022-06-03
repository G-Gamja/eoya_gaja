import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

// updateTodo(docId) {
//   DocumentReference documentReference = FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser?.uid)
//       .collection('dailydata')
//       .doc(widget.selectedDate)
//       .collection('eats')
//       .doc(docId);
//   documentReference
//   //.updateData({ 'aaaa': 'cccc', 'num': 4444, 'xxx': 1234 });
//       .update({'e':'1'})
//       .whenComplete(() => print("deleted successfully"));
// }
// Future createDaily(DailyData daily, String dbdate) async {
//   try {
//     //* 신상정보 입력
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection('dailydata')
//         .doc(dbdate)
//         .collection('eats')
//         .doc()
//         .update(daily.toJson());
//   } catch (e) {
//     return ;
//   }
// }
class UpdateDailyScreen extends StatefulWidget {
  String? getdocId;
  UpdateDailyScreen(this.getdocId);
  @override
  State<UpdateDailyScreen> createState() => _UpdateDailyScreenState();
}

class _UpdateDailyScreenState extends State<UpdateDailyScreen> {
  updateTodo(docId, dbdate, foodData, snackData, currentColor) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('dailydata')
        .doc(dbdate)
        .collection('eats')
        .doc(docId);
    documentReference.update({
      'food': foodData,
      'snacks': snackData,
      //!수정창에서는 날짜 수정 안되게 그냥 막아놨음
      //'date': dateData,
      'tagcolor': currentColor
    });
  }

  final _formKey = GlobalKey<FormState>();
  //간식 종류
  String? _snackvariation;
  //밥량
  int? foodVolume;
  //해당 날짜
  //Timestamp _selectedDate = Timestamp.fromDate(DateTime.now());
  //!제시할 간식종류/ 일단 예시로 한거라 수정하던가 말던강
  List<String> _snackvariationList = ['쿠키', '쫀디기', '아폴로'];

  //String dbdate = DateFormat('eee-yyyy-MM-dd').format(DateTime.now());

  String dbdate = DateFormat('yyyy-MM-dd,EEE').format(Get.arguments);
  void saveForm() {
    //birthTimestamp = Timestamp.fromDate(_selectedDate);
    //_formKey.currentState?.save();
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState?.save();
    }
  }

  Color _pickerColor = Color(0xFFD4E7FE);
  final Color _backGroungColor = const Color(0xfff5f8ff);
  final Color _deepBlue = const Color(0xff1d256e);
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
          leading: Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: const Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],
                color: Colors.white, //Colors.amber,
                borderRadius: BorderRadius.circular(20)),
            child: IconButton(
                onPressed: () => Get.back(),
                icon: const FaIcon(FontAwesomeIcons.angleLeft),
                color: _deepBlue),
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
                  // DateTimePicker(
                  //   locale: Locale('ko'),
                  //   type: DateTimePickerType.dateTimeSeparate,
                  //   // dateMask: 'yyyy, MMM DDD',
                  //   initialValue: getdate, //DateTime.now().toString(),
                  //   firstDate: DateTime(2000),
                  //   lastDate: DateTime(2100),
                  //   icon: Icon(Icons.event),
                  //   dateLabelText: '날짜',
                  //   timeLabelText: "시간",
                  //   // selectableDayPredicate: (ddate) {
                  //   //   // Disable weekend days to select from the calendar
                  //   //   if (ddate.weekday == 6 || ddate.weekday == 7) {
                  //   //     return false;
                  //   //   }

                  //   //   return true;
                  //   // },
                  //   onChanged: (val) => print(val),
                  //   validator: (val) {
                  //     print(val);
                  //     return null;
                  //   },
                  //   onSaved: //(val) => print(val),
                  //       (val) {
                  //     setState(
                  //       () {
                  //         this._selectedDate = Timestamp.fromDate(
                  //           DateTime.parse(val!),
                  //         );
                  //         dbdate = DateFormat('yyyy-MM-dd,EEE')
                  //             .format(DateTime.parse(val));
                  //       },
                  //     );
                  //   },
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
            children: [
              IconButton(
                onPressed: () async {
                  saveForm();
                  updateTodo(widget.getdocId, dbdate, foodVolume,
                      _snackvariation, _pickerColor.hashCode);
                  // createDaily(
                  //     //* 수정할 놈만 파라미터로 넘겨야하는데 빈 놈도 넘겨버리니까 null로 업데이틑 되는거임
                  //     DailyData(
                  //       food: foodVolume,
                  //       snacks: _snackvariation,
                  //       date: _selectedDate,
                  //       // docId: FirebaseFirestore.instance
                  //       //     .collection('users')
                  //       //     .doc(FirebaseAuth.instance.currentUser?.uid)
                  //       //     .collection('dailydata')
                  //       //     .doc(dbdate)
                  //       //     .collection('eats')
                  //       //     .doc()
                  //       //     .id),
                  //     ),
                  //     dbdate as String);

                  Get.back();
                  //todo 잘 안보임

                  Get.snackbar('저장완료', '저장이 완료되었습니다');
                },
                icon: Icon(Icons.save_rounded, color: Colors.indigo[400]),
              ),
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
