import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD4E7FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFD4E7FE),
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: Colors.black),
                  color: Colors.black),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '구감자',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[400],
                  ),
                ),
                Text('ih'),
              ],
            ),
          ],
        ),
      ),
      body: Column(children: [
        //상단 오늘 날짜랑 사용자 인포

        Expanded(
          flex: 1,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300] as Color,
            highlightColor: Colors.grey[100] as Color,
            //enabled: false,
            child: Container(
              //color: Colors.blueGrey,

              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.indigo[400],
              ),
              //mainAxisSize: MainAxisSize.min,

              //child: Container()
            ),
          ),
        ),

        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300] as Color,
                  highlightColor: Colors.grey[100] as Color,
                  //enabled: false,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 20,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300] as Color,
                      highlightColor: Colors.grey[100] as Color,
                      //enabled: false,
                      child: Container(
                        //margin: EdgeInsets.only(right: 15),
                        padding: EdgeInsets.all(15),
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          //color: _boxcolor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300] as Color,
                      highlightColor: Colors.grey[100] as Color,
                      //enabled: false,
                      child: Container(
                        //margin: EdgeInsets.only(right: 15),
                        padding: EdgeInsets.all(15),
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          //color: _boxcolor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300] as Color,
                  highlightColor: Colors.grey[100] as Color,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 20,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Shimmer.fromColors(
                  baseColor: Colors.grey[300] as Color,
                  highlightColor: Colors.grey[100] as Color,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      //color: _boxcolor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                  ),
                )),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
