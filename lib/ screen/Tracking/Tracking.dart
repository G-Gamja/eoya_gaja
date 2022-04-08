import 'package:eoya_gaja/widgets/pieChartwidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../textWidget/FiraText.dart';
import '../../widgets/GoButton.dart';
import 'TrackingHistortScreen.dart';
import 'TrackingManual.dart';
import 'TrackingMap.dart';

//*1km 당 80kcal
//* 1보는 50cm
class TrackingScreen extends StatelessWidget {
  //CountDownController? countDowncontroller = CountDownController();
  final Color _deepBlue = const Color(0xff1d256e);
  final Color _lightPurple = const Color(0xff8a80fe);
  final Color _textColor = const Color(0xff3d4373);
  final Color _backGroundColor = const Color(0xfff5f8ff);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: _backGroundColor,
          title: FiraText('Tracking', _textColor, 30, FontWeight.bold)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PieChartWidget(),
            //Text('오늘은 0.34km를 산책했어요!'),
            // Stack(
            //   alignment: AlignmentDirectional.bottomCenter,
            //   children: [
            //     Container(
            //       margin: const EdgeInsets.all(15),
            //       width: MediaQuery.of(context).size.width - 20,
            //       height: 200,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.all(Radius.circular(20)),
            //         color: Colors.black,
            //       ),
            //     ),
            //     Positioned(
            //       bottom: 30,
            //       child: Container(
            //         margin: const EdgeInsets.all(10),
            //         padding: const EdgeInsets.all(10),
            //         width: MediaQuery.of(context).size.width - 70,
            //         height: 100,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(20)),
            //           color: Colors.white,
            //         ),
            //         child: Row(
            //           children: [
            //             Icon(Icons.maps_ugc_rounded),
            //             Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 //* 데이터 연동해야할듯
            //                 FiraText(
            //                     'Today Run', Colors.black, 20, FontWeight.bold),
            //                 Text.rich(
            //                   TextSpan(
            //                       text: '17.5',
            //                       style: GoogleFonts.firaSans(
            //                         textStyle: TextStyle(
            //                             color: Colors.amber,
            //                             fontSize: 20,
            //                             fontWeight: FontWeight.bold),
            //                       ),
            //                       children: <TextSpan>[
            //                         TextSpan(
            //                           text: 'km',
            //                           style: GoogleFonts.firaSans(
            //                             textStyle: TextStyle(
            //                                 color: Colors.grey,
            //                                 fontSize: 10,
            //                                 fontWeight: FontWeight.normal),
            //                           ),
            //                         )
            //                       ]),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              width: MediaQuery.of(context).size.width - 20,
              height: 150,
              //height: MediaQuery.of(context).size.height-20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  border:
                      Border.all(width: 1, color: Colors.grey[200] as Color)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    //한국말로 다 바꾸기
                    child: Text('오늘의 기록',
                        style: Theme.of(context).textTheme.headline2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.square_foot_rounded),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('5595'), Text('Total Steps')],
                      ),
                      Icon(Icons.calculate_outlined),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('220'), Text('Total Cakories')],
                      )
                    ],
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GoButton(
                  iconString: 'assets/images/walking-the-dog.png',
                  maintxt: 'Live Tracking',
                  backGroundColor: Colors.indigo,
                  goWidget: TrackingMapScreen(),
                ),
                GoButton(
                  iconimage: FaIcon(
                    FontAwesomeIcons.mapPin,
                    size: 40,
                  ),
                  maintxt: '수기로 작성',
                  backGroundColor: Colors.amber,
                  goWidget: ManualTrackingScreen(),
                ),
              ],
            ),
            // CircularCountDownTimer(
            //   //! 3초로 하면 3이 바로 잘려서 이상하게 보여서 4로 했는데 그럼 4가 살짝 보여서 더 이상함
            //   duration: 3,
            //   initialDuration: 0,
            //   controller: countDowncontroller,
            //   width: MediaQuery.of(context).size.width / 5,
            //   height: MediaQuery.of(context).size.height / 5,
            //   ringColor: Colors.grey,
            //   ringGradient: null,
            //   fillColor: Colors.indigo,
            //   fillGradient: null,
            //   backgroundColor: Colors.lightBlue,
            //   backgroundGradient: null,
            //   strokeWidth: 10.0,
            //   strokeCap: StrokeCap.round,
            //   textStyle: TextStyle(
            //       fontSize: 33.0,
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold),
            //   textFormat: CountdownTextFormat.S,
            //   isReverse: true,
            //   isReverseAnimation: false,
            //   isTimerTextShown: true,
            //   autoStart: false,
            //   onStart: () {
            //     print('Countdown Started');
            //   },
            //   onComplete: () {
            //     // setState(() {
            //     //   countvisible = false;
            //     //   fakemap = false;
            //     // });
            //     Get.to(TrackingMapScreen());
            //   },
            // ),

            // TextButton(
            //   onPressed: () {
            //     // setState(() {
            //     //   countvisible = true;
            //     // });
            //     countDowncontroller!.start();
            //   },
            //   child: Text('start'),
            // ),

            GestureDetector(
              onTap: () => Get.to(() => TrackingHistoryScreen()),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width - 20,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width - 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.maps_ugc_rounded),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //* 데이터 연동해야할듯
                              FiraText('See my Running history', Colors.black,
                                  16, FontWeight.bold),
                              // Text.rich(
                              //   TextSpan(
                              //     text: '17.5',
                              //     style: GoogleFonts.firaSans(
                              //       textStyle: TextStyle(
                              //           color: Colors.amber,
                              //           fontSize: 20,
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //     children: <TextSpan>[
                              //       TextSpan(
                              //         text: 'km',
                              //         style:
                              // GoogleFonts.firaSans(
                              //       textStyle: TextStyle(
                              //           color: Colors.grey,
                              //           fontSize: 10,
                              //           fontWeight: FontWeight.normal),
                              //     ),
                              //       )
                              //     ]
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
