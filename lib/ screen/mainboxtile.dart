import 'package:flutter/material.dart';

import './taskmanager.dart';

class MainBoxTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(TaskManagerScreen.routeName);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '07:00',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'AM',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ],
            ),
            //시간 옆 줄 그림
            Container(
              height: 100,
              width: 1,
              color: Colors.green,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '설명을 블라블라냥냥쮸',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_alarms,
                      size: 20,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      //글씨 오른쪽 공간 조절용
                      //width: MediaQuery.of(context).size.width -160,
                      child: Text(
                        '추가 설명을 블라블라냥냥쮸',
                        style: TextStyle(
                            //텍스트 오버플로우 시
                            //overflow: TextOverflow.ellipsis,
                            color: Colors.green,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage:
                          AssetImage('assets/images/ahn.png'),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      //width: MediaQuery.of(context).size.width-160,
                      child: Text(
                        '추가 설명을 블라블라냥냥쮸',
                        style: TextStyle(
                            textBaseline: TextBaseline.ideographic,
                            color: Colors.green,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //에러 유발
            // Positioned(
            //   bottom: 35,
            //   right: 15,
            //   child: Container(
            //     child: Icon(Icons.arrow_back),
            //     padding: EdgeInsets.all(20),
            //     decoration: BoxDecoration(
            //       color: Colors.blueGrey,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
