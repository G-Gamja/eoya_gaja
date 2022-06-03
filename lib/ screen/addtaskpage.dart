import 'package:flutter/material.dart';
import './input_field.dart';
import 'package:intl/intl.dart';
//top snack bar
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:get/get.dart';
class AddTaskPage extends StatefulWidget {
  static const routeName = '/addtaskscreen';

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = '11:59 PM';
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _selectedRemind = '5';
  List<String> remindList = ['5', '10', '15', '20', '60'];
  String _selectedRepeat = '반복없음';
  List<String> repeatList = ['매일', '일주일', '한달'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: ()=> Get.back(),
          icon: Icon(Icons.backspace),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '기록 및 메모',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              InputField(
                  title: '메모 타이틀',
                  hint: '메모의 타이틀을 입력해주세요',
                  controller: _textEditingController,
                  ),
              InputField(
                title: '노트 내용',
                hint: '노트의 내용을 입력해주세요',
                controller: _noteController,
              ),
              InputField(
                title: '날짜',
                hint: DateFormat.yMMMd('ko_KR').format(_selectedDate),
                wd: IconButton(
                  onPressed: _getdate,
                  icon: Icon(Icons.calendar_today),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: '시작 시간',
                      hint: _startTime,
                      
                      wd: IconButton(
                        onPressed: () {
                          //트루면 시작시간을 폴스면 종료시간에 들어가도록
                          _gettime(isStarttime: true);
                        },
                        icon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InputField(
                      title: '마치는 시간',
                      hint: _endTime,
                      wd: IconButton(
                        onPressed: () {
                          _gettime(isStarttime: false);
                        },
                        icon: Icon(Icons.access_time),
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                title: '리마인드 알람',
                hint: '$_selectedRemind분 뒤에 알람 울리기',
                wd: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  //style: TextStyle(fontSize: 10),
                  underline: Container(
                    height: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  //value: _selectedRemind,
                  onChanged: (String?value) {
                    setState(() {
                      _selectedRemind = value!;
                    });
                  },
                  items: remindList.map(
                    (String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              InputField(
                title: '반복',
                hint: _selectedRepeat == '반복없음'
                    ? _selectedRepeat
                    : '$_selectedRepeat 마다 반복 알람이 있어요',
                wd: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  //style: TextStyle(fontSize: 10),
                  underline: Container(
                    height: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  //value: _selectedRemind,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                  items: repeatList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '태그 컬러',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: List<Widget>.generate(
                          4,
                          (int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  child: _selectedColor == index
                                      ? Icon(Icons.check)
                                      : Container(),
                                  radius: 14,
                                  backgroundColor: index == 0
                                      ? Colors.redAccent
                                      : index == 1
                                          ? Colors.blueAccent
                                          : index == 2
                                              ? Colors.brown
                                              : Colors.greenAccent,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _validateDate();
                    },
                    child: Container(
                      //컨테이너 내부 텍스트 위젯이나 등등의 위젯의 정렬
                      alignment: Alignment.center,
                      //margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        '메모 추가하기',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
              //! 이게 저장, 취소 버튼이 될거야
              Container(color: Colors.red,child: Text('취소'),),
              Container(color: Colors.red,child: Text('취소'),)
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_textEditingController.text.isNotEmpty &&
        _noteController.text.isNotEmpty) {
      //파이어 베이스에 데이터 집어넣기
      //뒤로 돌아간 페이지에 return to data like parameter
      //Get.back(result: );
      Get.back();
    } else if (_textEditingController.text.isEmpty ||
        _noteController.text.isEmpty) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "제목과 메모의 내용을 입력하지 않으신거같아요",
        ),
        //onTap: ,
        displayDuration: const Duration(milliseconds: 300)
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(

      //     content: Text('야옹'),
      //     duration: Duration(seconds: 2),
      //     //animation: Animation()
      //     backgroundColor: Theme.of(context).errorColor,
      //     behavior: SnackBarBehavior.floating,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10)
      //       //borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
      //     ),
      //   ),
      // );
    }
  }

//날짜 픽커용 함수
  _getdate() async {
    DateTime? _pickerDate = await showDatePicker(
      //한글 쓰려면 https://suyou.tistory.com/tag/DatePicker 이 사이트 참고해서 다시 빌드업해
      locale: Locale('ko'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF8CE7F1),
            accentColor: const Color(0xFF8CE7F1),
            colorScheme: ColorScheme.light(primary: const Color(0xFF8CE7F1)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child:  child!,
        );
      },
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print('its null');
    }
  }

  //시간 픽커용 함수
  _gettime({bool? isStarttime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('picked null');
    } else if (isStarttime!) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        //지금 시간으로 파싱해버리기
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(' ')[0]),
      ),
    );
  }
}
