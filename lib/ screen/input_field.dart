import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  //may be iconwidget next to textformfield
  final Widget? wd;
  final FocusNode? focusNode;
  InputField(
      {required this.title, required this.hint, this.controller, this.wd, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Container(
            height: 50,
            //width: 300,
            margin: EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    //읽기전용여부/읽기전용이면 날짜 선택 아이콘 만 활성화됨
                    readOnly: wd == null ? false : true,
                    focusNode: focusNode,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                    autofocus: false,
                    cursorColor: Colors.orange,
                    controller: controller,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: hint,
                      //labelText: hint,
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      //밑줄 색깔
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                      ),
                    ),
                  ),
                ),
                wd == null
                    ? Container()
                    : Container(
                        child: wd,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
