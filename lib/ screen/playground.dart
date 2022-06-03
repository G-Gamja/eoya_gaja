import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:eoya_gaja/%20screen/junk/dough.dart';
//mport 'package:eoya_gaja/%20screen/junk/sqltest.txt';
import 'package:eoya_gaja/%20screen/shimmerScreen.dart';
import 'package:eoya_gaja/widgets/reactButton/reactionButton.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../widgets/ConnectivityToast.dart';
import '../widgets/barChart.dart';
import 'junk/oldCalendar.dart';
import 'junk/samplefetti.dart';
import 'scheduleScreen.dart';
import 'taskmanager.dart';

class playGround extends StatefulWidget {
  @override
  _playGroundState createState() => _playGroundState();
}

class _playGroundState extends State<playGround> {
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('For Test'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: const [
                  Text(
                    'Weekly Reports',
                    style: TextStyle(
                        fontFamily: "CeraRound",
                        color: Color(0xff3d4373),
                        fontSize: 10,
                        fontWeight: FontWeight.w100),
                  ),
                  Text(
                    'Weekly Reports',
                    style: TextStyle(
                        fontFamily: "CeraRound",
                        color: Color(0xff3d4373),
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Weekly Reports',
                    style: TextStyle(
                        fontFamily: "CeraRound",
                        color: Color(0xff3d4373),
                        fontSize: 10,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Weekly Reports',
                    style: TextStyle(
                        fontFamily: "CeraRound",
                        color: Color(0xff3d4373),
                        fontSize: 10,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     showAdaptiveActionSheet(
              //       context: context,
              //       actions: <BottomSheetAction>[
              //         BottomSheetAction(
              //           title: const Text('Item 1'),
              //           onPressed: () {},
              //         ),
              //         BottomSheetAction(
              //           title: const Text('Item 2'),
              //           onPressed: () {},
              //         ),
              //         BottomSheetAction(
              //           title: const Text('Item 3'),
              //           onPressed: () {},
              //         ),
              //       ],
              //       cancelAction: CancelAction(title: const Text('Cancel')),
              //     );
              //   },
              //   child: const Text('Show action sheet'),
              // ),
              const Text(
                '아아아아아',
                style: const TextStyle(
                  fontFamily: 'TmonMonsori',
                  fontSize: 25.0,
                  // fontWeight: FontWeight.w400,
                  color: Colors.orange,
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  showAdaptiveActionSheet(
                    context: context,
                    title: const Text('This is the title'),
                    actions: <BottomSheetAction>[
                      BottomSheetAction(
                        title: const Text('Item 1'),
                        onPressed: () {},
                      ),
                      BottomSheetAction(
                        title: const Text('Item 2'),
                        onPressed: () {},
                      ),
                      BottomSheetAction(
                        title: const Text('Item 3'),
                        onPressed: () {},
                      ),
                    ],
                    cancelAction: CancelAction(title: const Text('Cancel')),
                  );
                },
                child: const Text('Show action sheet with title'),
              ),
              ElevatedButton(
                onPressed: () {
                  showAdaptiveActionSheet(
                    context: context,
                    actions: <BottomSheetAction>[
                      BottomSheetAction(
                        title: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          print('hello');
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        leading: const Icon(Icons.add, size: 25),
                      ),
                      BottomSheetAction(
                        title: const Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {},
                        leading: const Icon(
                          Icons.delete,
                          size: 25,
                          color: Colors.red,
                        ),
                      ),
                    ],
                    cancelAction: CancelAction(title: const Text('Cancel')),
                  );
                },
                child: const Text('Show action sheet with icons'),
              ),
              LikeButton(
                size: 30,
                circleColor: const CircleColor(
                    start: const Color(0xff00ddff), end: Color(0xff0099cc)),
                bubblesColor: const BubblesColor(
                  dotPrimaryColor: const Color(0xff33b5e5),
                  dotSecondaryColor: const Color(0xff0099cc),
                ),
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.add_alert_rounded,
                    color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                    size: 30,
                  );
                },
                likeCount: 665,
                countBuilder: (int? count, bool isLiked, String text) {
                  var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                  Widget? result;
                  if (count == 0) {
                    result = Text(
                      "love",
                      style: TextStyle(color: color),
                    );
                  } else
                    result = Text(
                      text,
                      style: TextStyle(color: color),
                    );
                  return result;
                },
              ),
              AnimatedButtonBar(
                radius: 8.0,
                padding: const EdgeInsets.all(16.0),
                invertedSelection: true,
                children: [
                  ButtonBarEntry(
                      onTap: () => print('First item tapped'),
                      child: const Text('Day')),
                  ButtonBarEntry(
                      onTap: () => print('Second item tapped'),
                      child: const Text('Week')),
                  ButtonBarEntry(
                      onTap: () => print('Third item tapped'),
                      child: const Text('Month')),
                  ButtonBarEntry(
                      onTap: () => print('Fourth item tapped'),
                      child: const Text('Year'))
                ],
              ),
              //You can populate it with different types of widgets like Icon
              TextButton(
                  onPressed: () {
                    print(DateFormat('yyyy-MM-dd, EEE').format(DateTime.now()));
                  },
                  child: const Text('dataformat')),
              ElevatedButton(
                  onPressed: () => Get.to(TaskManagerScreen()),
                  child: const Text('옛날 캘린더 느낌 package')),

              ElevatedButton(
                  onPressed: () => Get.to(CalendarScreen()),
                  child: const Text('니티드 캘린더')),
              ElevatedButton(
                  onPressed: () => Get.to(ShimmerScreen()),
                  child: const Text('시머스크린')),
              ElevatedButton(
                  onPressed: () => Get.to(BarChartwidget()),
                  child: const Text('barchart')),
              ElevatedButton(
                  onPressed: () => Get.to(OldCalendar()),
                  child: const Text('2차 옛날캔린더')),
              AddToCartButton(
                trolley: Image.asset(
                  'assets/images/trophy.png',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                text: const Text(
                  'Let\'s go Eoya!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                check: const SizedBox(
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                borderRadius: BorderRadius.circular(24),
                backgroundColor: Colors.deepOrangeAccent,
                onPressed: (id) {
                  if (id == AddToCartButtonStateId.idle) {
                    //handle logic when pressed on idle state button.
                    setState(() {
                      stateId = AddToCartButtonStateId.loading;
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          stateId = AddToCartButtonStateId.done;
                        });
                      });
                    });
                  } else if (id == AddToCartButtonStateId.done) {
                    //handle logic when pressed on done state button.
                    setState(() {
                      stateId = AddToCartButtonStateId.idle;
                    });
                  }
                },
                stateId: stateId,
              ),
              FluttermojiCircleAvatar(),
              FluttermojiCustomizer(),
              TextButton(
                  onPressed: () => Get.to(() => Samplefetti()),
                  child: const Text('fetti')),
              // TextButton(onPressed: ()=> Get.to(()=>WarpIndicatorScreen(),), child: Text('warp')),
              TextButton(
                  onPressed: () => Get.to(
                        () => ConnectivityToast(),
                      ),
                  child: const Text('connectivity')),
              TextButton(
                  onPressed: () => Get.to(
                        () => EmojiReactionButton(),
                      ),
                  child: const Text('emojireactionbutton')),
              TextButton(
                  onPressed: () => Get.to(
                        () => DraggableDoughDemo(),
                      ),
                  child: const Text('dough')),
              // TextButton(
              //     onPressed: () => Get.to(
              //           () => sqlTest(),
              //         ),
              //     child: const Text('sql'))
            ],
          ),
        ),
      ),
    );
  }
}
