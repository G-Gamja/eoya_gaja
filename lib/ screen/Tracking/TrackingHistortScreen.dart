import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../textWidget/FiraText.dart';
import '../../widgets/TrackingDataBox.dart';
import '../../widgets/pieChartwidget.dart';

class TrackingHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.backspace,
            color: Colors.amber,
          ),
        ),
        centerTitle: true,
        title: FiraText(
            'See my Running history', Colors.black, 16, FontWeight.bold),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            //* 산책 등급별로 서클 차에 대ㅂ
            //CircleChartWidget(),
            PieChartWidget(),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FiraText(
                            'Weekly Total', Colors.grey, 15, FontWeight.bold),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                FiraText(
                                    '127', Colors.black, 50, FontWeight.bold),
                                SizedBox(
                                  width: 5,
                                ),
                                FiraText(
                                    'km', Colors.black, 20, FontWeight.normal),
                              ],
                            ),
                            //*날짜 선택용
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.calendar_today_rounded)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: TrackingDataBox(),
                  ),
                ],
              ),
            ))
            //todo 선택된 데이터에 맞는 날짜의 데이터를 보여주면 되겠네!
          ],
        ),
      ),
    );
  }
}
