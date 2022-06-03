import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eoya_gaja/%20screen/CalendarPage/updatedaily.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_animator/flutter_animator.dart';

import '../../textWidget/FiraText.dart';
import '../getstate/getdailydata.dart';
//*여러 액션을 취할 수 있는 dismissible위젯

class MeMo3Widget extends StatefulWidget {
  final String selectedDate;
  final DateTime chosenTime;
  MeMo3Widget(this.selectedDate, this.chosenTime);

  // const MeMo3Widget({
  //   Key? key,
  //    required this.selectedDate,
  // }) : super(key: key);
  @override
  _MeMo3WidgetState createState() => _MeMo3WidgetState();
}

class _MeMo3WidgetState extends State<MeMo3Widget> {
  // Future deleteDaily() async {
  //   try {
  //     //* 신상정보 입력
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .collection('dailydata')
  //         //todo 여기 각 개별 아이디 파라미터로 받아서 지우는거야
  //         .doc()
  //         .delete();
  //   } catch (e) {
  //     return;
  //   }
  // }
  deleteTodo(docId) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('dailydata')
        .doc(widget.selectedDate)
        .collection('eats')
        .doc(docId);
    documentReference
        .delete()
        .onError((error, stackTrace) => Get.snackbar('Error', 'delete error'));
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  final Color _deepBlue = const Color(0xff2e3c81);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Get.put(DailyDataController()).fetchdailyDB(widget.selectedDate);
    // Get.put(DailyDataController()).fetchdailyList;
  }

  @override
  Widget build(BuildContext context) {
    // Get.find<WeatherControlloer>().queryWeather();
    Get.put(DailyDataController()).fetchdailyDB(widget.selectedDate);
    //getx를 통해 화면이 끊김없도록 구현
    //List<GlobalKey<AnimatorWidgetState>> keys = [];
    //GlobalKey<AnimatorWidgetState> key = GlobalKey<AnimatorWidgetState>();;
    return GetBuilder<DailyDataController>(
      init: DailyDataController(),
      builder: (controller) {
        //todo 네트워크 미연결시 혹은 그런 오류들 확인하기
        return controller.docList == null
            ? Center(
                //width: MediaQuery.of(context).size.width,
                child: LoadingAnimationWidget.inkDrop(
                    color: Colors.white, size: 50),
              )
            : controller.docLength == 0
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // color: Colors.amber,
                      children: [
                        FaIcon(FontAwesomeIcons.calendarTimes, size: 50),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '아직 기록된게 없어요',
                          style: Theme.of(context).textTheme.headline2,
                        )
                      ],
                    )
                    // AnimatedTextKit(
                    //   animatedTexts: [
                    //     TyperAnimatedText('아직 기록이 없어요'),
                    //     TyperAnimatedText('빨리 작성해봅시다'),
                    //     //TyperAnimatedText('and then do your best'),
                    //     //TyperAnimatedText('- W.Edwards Deming'),
                    //   ],
                    //   onTap: () {
                    //     print("Tap Event");
                    //   },
                    // ),
                    )
                // Center(
                //     child: Container(
                //       width: 40,
                //       height: 40,
                //       child: Image(
                //         image: AssetImage('assets/gifs/note.gif'),
                //       ),
                //     ),
                //   )
                : ListView.builder(
                    //아이템수
                    itemCount: controller.docLength,
                    itemBuilder: (BuildContext context, int index) {
                      Color tagColor =
                          Color(controller.docList![index]['tagcolor'])
                              .withOpacity(1);
                      Timestamp momoStamp = controller.docList![index]['date'];
                      // String memoDate = momoStamp.toDate().hour.minutes;
                      String memoDate =
                          DateFormat("h:mm").format(momoStamp.toDate());
                      // String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
                      //print('hi $tagColor.toString()');
                      //keys = List.generate(index, (_) => GlobalKey<AnimatorWidgetState>());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LightSpeedIn(
                          // key: key.currentState.forward(),
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.Forward),
                          child: Slidable(
                            key: // Key(controller.docList![index]),
                                // ValueKey(index),
                                UniqueKey(),
                            endActionPane: ActionPane(
                              motion:
                                  const DrawerMotion(), //const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {
                                setState(() {
                                  //! 인터넷 보고 추가한건데 무슨 용도인지 모르겠음
                                  controller.fetchedDailyData.docs
                                      .removeAt(index);
                                  deleteTodo(controller.fetchedDailyData
                                      .docs[index].reference.id);
                                });
                              }),
                              children: [
                                // A SlidableAction can have an icon and/or a label.

                                Container(
                                  // height: 20,
                                  // width: 20,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.only(
                                  //         topLeft: Radius.circular(30),
                                  //         topRight: Radius.circular(30))),
                                  child: SlidableAction(
                                    flex: 1,
                                    onPressed: (context) {
                                      Get.to(
                                              () => UpdateDailyScreen(controller
                                                  .fetchedDailyData
                                                  .docs[index]
                                                  .reference
                                                  .id),
                                              arguments: widget.chosenTime)!
                                          .then(onGoBack);
                                    },
                                    backgroundColor: const Color(0xFF21B7CA),
                                    foregroundColor: Colors.white,
                                    icon: FontAwesomeIcons.penAlt,
                                    //label: 'Edit',
                                  ),
                                ),
                                Container(
                                  //height: 20,
                                  // width: 20,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.only(
                                  //         topLeft: Radius.circular(30),
                                  //         topRight: Radius.circular(30))),
                                  child: SlidableAction(
                                    flex: 1,
                                    onPressed: (context) {
                                      Get.defaultDialog(
                                          buttonColor: Colors.redAccent[100],
                                          title: '기록 삭제하기',
                                          titlePadding:
                                              const EdgeInsets.only(top: 20),
                                          titleStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          content: Column(
                                            // mainAxisSize: MainAxisSize.values,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // TextField(
                                              //   controller: settingsScreenController.categoryNameController,
                                              //   keyboardType: TextInputType.text,
                                              //   maxLines: 1,
                                              //   decoration: InputDecoration(
                                              //       labelText: 'Category Name',
                                              //       hintMaxLines: 1,
                                              //       border: OutlineInputBorder(
                                              //           borderSide: BorderSide(color: Colors.green, width: 4.0))),
                                              // ),
                                              const SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/gifs/trash-can.gif'),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  const FaIcon(
                                                      FontAwesomeIcons
                                                          .quoteLeft,
                                                      size: 15),
                                                  Text(
                                                    '한번 삭제하면 돌이킬 수 없어요',
                                                    style:
                                                        GoogleFonts.nanumGothic(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      142,
                                                                      144,
                                                                      165),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                  const FaIcon(
                                                      FontAwesomeIcons
                                                          .quoteRight,
                                                      size: 15),
                                                ],
                                              ),

                                              const SizedBox(
                                                height: 30.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    icon: const FaIcon(
                                                        FontAwesomeIcons
                                                            .redoAlt),
                                                    label: const Text(
                                                      "돌아가기",
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black38),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .grey[300]),
                                                      // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        GoogleFonts.nanumGothic(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      setState(() {
                                                        deleteTodo(controller
                                                            .fetchedDailyData
                                                            .docs[index]
                                                            .reference
                                                            .id);
                                                        Get.back();
                                                      });
                                                    },
                                                    icon: const FaIcon(
                                                        FontAwesomeIcons.trash),
                                                    label: const Text("삭제하기"),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(_deepBlue),
                                                      // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .all(
                                                        GoogleFonts.nanumGothic(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          radius: 10.0);
                                    },
                                    backgroundColor:
                                        Colors.redAccent[100] as Color,
                                    foregroundColor: Colors.white,
                                    icon: FontAwesomeIcons.trash,
                                    // label: 'Delete',
                                    autoClose: true,
                                  ),
                                ),
                              ],
                            ),

                            // The end action pane is the one at the right or the bottom side.
                            // endActionPane: ActionPane(
                            //   motion: ScrollMotion(),
                            //   children: [
                            //     SlidableAction(
                            //       // An action can be bigger than the others.
                            //       flex: 2,
                            //       onPressed: sample(),
                            //       backgroundColor: Color(0xFF7BC043),
                            //       foregroundColor: Colors.white,
                            //       icon: Icons.archive,
                            //       label: 'Archive',
                            //     ),
                            //     SlidableAction(
                            //       onPressed: sample(),
                            //       backgroundColor: Color(0xFF0392CF),
                            //       foregroundColor: Colors.white,
                            //       icon: Icons.save,
                            //       label: 'Save',
                            //     ),
                            //   ],
                            // ),

                            // The child of the Slidable is what the user sees when the
                            // component is not dragged.
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                // tileColor: Colors.amber,
                                leading: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  //padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: tagColor,
                                      borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0))),
                                  width: 5,
                                  height: 40,
                                ),
                                trailing: Text(memoDate),
                                subtitle: Text('sfdfdsfsdfsd'),
                                title: Text(
                                  controller.docList![index]['snacks'],
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
      },
    );
  }
}
