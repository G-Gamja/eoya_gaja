// 구글맵 뭐 거리계산이나https://pub.dev/packages/maps_toolkit
import 'dart:typed_data';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter_button/counter_button.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:ui' as ui;

import 'dart:math' show cos, sqrt, asin;

import '../../model/trackingdata.dart';
import '../../widgets/bellSound.dart';
import '../getstate/walktimeCount.dart';
import '../getstate/weatherstate.dart';
import '../weather.dart';

//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:platform_maps_flutter/platform_maps_flutter.dart';
//import 'package:map_polyline_draw/map_polyline_draw.dart';
//todo 근처 휴지통을 마커로 저장할 수 있으면 참 좋겠다잉
class TrackingMapScreen extends StatefulWidget {
  @override
  _TrackingMapScreenState createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends State<TrackingMapScreen> {
  bool? countvisible = false;
  Timestamp _todayDate = Timestamp.fromDate(DateTime.now());
  //함수 한번만 실향시킬려고 임시로 만들어둔 불리언
  bool checkbool = true;
  //late String _mapStyle;
  int _counterValue = 0;
  List<int> walktimeRecordList = [
    5,
    10,
    15,
    20,
    25,
    35,
    50,
  ];
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    // onChange: (value) => testint = value,
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) {
      if (value > 0) {}
    },
  );
  Set<Polyline> lines = {};
  List<LatLng> linePoints = [];
  Completer<GoogleMapController> _controller = Completer();

  late StreamSubscription<LocationData> subscription;
  Set<Marker> _marker = Set<Marker>();

  late Uint8List markerIcon;

  LocationData? currentLocation;
  late LocationData destinationLocation;
  late Location location;
  String _placeDistance = '0:00';
  //맵 스타일
  MapType _mapType = MapType.normal;
  //줌 단계
  double zoomLevel = 16.5; //5;
  int walkingminTime = 0;
  String dbdate = DateFormat('yyyy-MM-dd,EEE').format(DateTime.now());
  //todo 아묻따로 폴리라인이 그려지니까 카운트 다운되면 페이지 넘어가는 형식으로 구현합시다.
  Future createtrackDaily(TrackingData trackData) async {
    try {
      //* 신상정보 입력
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('dailydata')
          .doc(dbdate)
          .collection('tracking')
          .doc()
          .set(trackData.toJson());
    } catch (e) {
      return e.printError();
    }
  }

  @override
  void initState() {
    super.initState();
    //_stopWatchTimer.secondTime.listen((value) {walkingsecTime = value;});
    _stopWatchTimer.minuteTime.listen((value) {
      walkingminTime = value;
    });
    double totalDistance = 0.0;
    location = Location();
    //polylinePoints = PolylinePoints();
    //List<LatLng> linePoints = [];
    //ANCHOR 스탑 버튼을 누르면 트래킹이 멈춰야하는데 이거 조건문으로 한번 걸어서 해보자
    subscription = location.onLocationChanged.listen(
      (clocation) {
        currentLocation = clocation;

        updatePinsOnMap();
        calculateDistance(linePoints, totalDistance);
      },
    );
    //맵 스타일 바꾸기
    // SchedulerBinding.instance?.addPostFrameCallback((_) async {
    //   await rootBundle
    //       .loadString('assets/mapstyle/map_style.json')
    //       .then((string) {
    //     setState(() {
    //       _mapStyle = string;
    //     });
    //   });
    // });
    //*첫 포인트 입력
    setInitialLocation();
    //! 맵스타일 변경_한국 법떄문에 안되는 거였음 ㄷ ㄷ
    // rootBundle.loadString('assets/mapstyle/map_style.json').then(
    //   (string) {
    //     _mapStyle = string;
    //   },
    // );
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  //*두 점 사이의 거리계산함수
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void calculateDistance(linePoints, totalDistance) async {
    for (int i = 0; i < linePoints.length - 1; i++) {
      totalDistance += _coordinateDistance(
        linePoints[i].latitude,
        linePoints[i].longitude,
        linePoints[i + 1].latitude,
        linePoints[i + 1].longitude,
      );
    }
    if (mounted) {
      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
      });
    }
  }

  // void bringMapStyle(GoogleMapController mapController) async {
  //   String mapStyle = await DefaultAssetBundle.of(context)
  //       .loadString('assets/mapstyle/map_style.json');
  //   mapController.setMapStyle(mapStyle);
  // }

  void setInitialLocation() async {
    await location.getLocation().then((value) {
      currentLocation = value;
      if (mounted) {
        setState(() {});
      }
    });
    //ANCHOR 백그라운드 가능하게 만드는 함수
    //location.enableBackgroundMode(enable: true);

    // destinationLocation = LocationData.fromMap({
    //   "latitude": destinationLatlng.latitude,
    //   "longitude": destinationLatlng.longitude,
    // });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void showLocationPins() async {
    var sourceposition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    // var destinationPosition =
    //     LatLng(destinationLatlng.latitude, destinationLatlng.longitude);
    Uint8List markerIcon =
        await getBytesFromAsset('assets/images/mapMarker.png', 130);
    _marker.add(Marker(
      markerId: MarkerId('movingPosition'),
      position: sourceposition,
      //icon: mapMarkerIcon,
      //       infoWindow: InfoWindow(
      //   title: 'hi',
      // ),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    ));
    //* 첫 출발지
    _marker.add(
      Marker(
        markerId: MarkerId('ourHome'),
        position: sourceposition,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    setPolylinesInMap(sourceposition);
  }

  void setPolylinesInMap(sourceposition) {
    linePoints.add(sourceposition);
    if (mounted) {
      setState(() {
        lines.add(
          Polyline(
            points: linePoints,
            color: Colors.amber,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
            //patterns: ,
            polylineId: PolylineId("line_one"),
          ),
        );
      });
    }
  }

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: zoomLevel,
      //zoom:5,
      // tilt: 80,
      //bearing: 30,
      target: LatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    //*커스텀 맵마커
    Uint8List markerIcon =
        await getBytesFromAsset('assets/images/mapMarker.png', 130);
    if (this.mounted) {
      setState(() {
        _marker
            .removeWhere((marker) => marker.mapsId.value == 'movingPosition');
        _marker.add(Marker(
          markerId: MarkerId('movingPosition'),
          position: sourcePosition,
          //icon: mapMarkerIcon,
          //                 infoWindow: InfoWindow(
          //   title: 'hi',
          // ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ));
        linePoints.add(sourcePosition);
      });
    }
  }
  //ANCHOR 현재위치로 돌아가게 해주는 버튼(기존은 위치를 바꿀 수 없기 때문에 사용) location 패키지를 설치한 후 사용할 것
// GestureDetector(
//             onTap: (){
//               _currentLocation();
//             },
//             child: Container(
//               width: screenWidth*(40/360),
//               height: screenWidth*(40/360),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.white,
//               ),
//               child: Padding(
//                 padding:  EdgeInsets.all(screenWidth*(6/360)),
//                 child: SvgPicture.asset(
//                   GreyMyLocationIcon,
//                   width: screenWidth*(28/360),
//                   height: screenWidth*(28/360),
//                 ),
//               ),
//             ),
//           ),

  @override
  void dispose() async {
    //await _stopWatchTimer.dispose();
    subscription.cancel();
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  //* 산책시간에 따라 성취단계를 높이는 함수
  // void plusnum() {
  //   if (nowstepnum < upperbound) {
  //     WidgetsBinding.instance?.addPostFrameCallback((_) {
  //       setState(
  //         () {
  //           nowstepnum++;
  //         },
  //       );
  //     });
  //     if (nowstepnum == upperbound)
  //       showTopSnackBar(
  //           context,
  //           CustomSnackBar.success(
  //             message: "최고기록에 도달하셨어요!",
  //           ),
  //           //onTap: ,
  //           displayDuration: const Duration(milliseconds: 300));
  //   }
  // }
  //   else if (nowstepnum == upperbound)
  //     showTopSnackBar(
  //         context,
  //         CustomSnackBar.success(
  //           message: "최고기록에 도달하셨어요!",
  //         ),
  //         //onTap: ,
  //         displayDuration: const Duration(milliseconds: 300));
  // }

  //*컬러값
  final Color _deepBlue = const Color(0xff1d256e);
  final Color _backGroungColor = const Color(0xfff5f8ff);
  final Color _textColor = const Color(0xff3d4373);
  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: zoomLevel,
      //zoom: 5,
      // tilt: 80,
      //bearing: 30,
      target: currentLocation != null
          ? LatLng(currentLocation!.latitude ?? 0.0,
              currentLocation!.longitude ?? 0.0)
          : LatLng(0.0, 0.0),
    );
    Get.put(WalktimeController());
    Get.put(WeatherControlloer());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _backGroungColor, //Color(0xFFD4E7FE),
        leading: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          //padding: const EdgeInsets.all(10),
          height: 40,
          width: 40,
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
              borderRadius: BorderRadius.circular(10)),
          child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "정말로 산책을 그만하실건가요?",
                  middleText: "여기서 그만두시면 여태까지의 산책은 기록이 안돼요",
                  backgroundColor: _backGroungColor, //Colors.indigo[400],
                  titleStyle: Theme.of(context).textTheme.bodyText1,
                  middleTextStyle: TextStyle(color: _textColor),
                  textConfirm: "그만할래요",
                  // onConfirm: () {
                  //   Get.back();
                  //   Get.back();
                  // },
                  // onCancel: () {
                  //   Get.back();
                  // },
                  confirm: ElevatedButton.icon(
                    onPressed: () {
                      Get.find<WalktimeController>().setZero();
                      Get.back();
                      Get.back();
                    },
                    icon: FaIcon(FontAwesomeIcons.times,
                        size: 18, color: Colors.white),
                    label: Text(
                      "그만할래요",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(_deepBlue),
                      // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                      textStyle: MaterialStateProperty.all(
                        GoogleFonts.firaSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  cancel: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: FaIcon(FontAwesomeIcons.redoAlt, size: 18),
                    label: Text(
                      "더할래요",
                      style: TextStyle(color: Colors.black38),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[300]),
                      // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                      textStyle: MaterialStateProperty.all(
                        GoogleFonts.firaSans(
                          textStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  textCancel: "더 할래요",
                  cancelTextColor: _textColor, //Colors.white,
                  confirmTextColor: Colors.redAccent[100],
                  buttonColor: _deepBlue, //Colors.red,
                  barrierDismissible: false,
                  radius: 10,
                  // content: Column(
                  //   children: [
                  //     Container(child: Text("Hello 1")),
                  //     Container(child: Text("Hello 2")),
                  //     Container(child: Text("Hello 3")),
                  //   ],
                  // ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                size: 23,
              ),
              color: _deepBlue),
        ),

        // IconButton(
        //   onPressed: () {
        //     Get.defaultDialog(
        //       title: "정말로 산책을 그만하실건가요?",
        //       middleText: "여기서 그만두시면 여태까지의 산책은 기록이 안돼요",
        //       backgroundColor: Colors.indigo[400],
        //       titleStyle: TextStyle(color: Colors.white),
        //       middleTextStyle: TextStyle(color: Colors.white),
        //       textConfirm: "그만할래요",
        //       onConfirm: () {
        //         Get.back();
        //         Get.back();
        //       },
        //       onCancel: () {
        //         Get.back();
        //       },
        //       textCancel: "더 할래요",
        //       cancelTextColor: Colors.white,
        //       confirmTextColor: Colors.white,
        //       buttonColor: Colors.red,
        //       barrierDismissible: false,
        //       radius: 10,
        //       // content: Column(
        //       //   children: [
        //       //     Container(child: Text("Hello 1")),
        //       //     Container(child: Text("Hello 2")),
        //       //     Container(child: Text("Hello 3")),
        //       //   ],
        //       // ),
        //     );
        //   },
        //   icon: Icon(Icons.backspace),
        // ),
        title: Text(
          '산책',
          style: GoogleFonts.firaSans(
            textStyle: TextStyle(
                color: Colors.indigo[400],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: SlidingUpPanel(
        //약하게 스냅시 멈추는 중간 포인트
        snapPoint: 0.5,

        minHeight: 130,
        maxHeight: MediaQuery.of(context).size.height * .80,
        //패널을 플로팅으로 띄울떄는 false로 둬야 뒷 배경이 안나옴
        renderPanelSheet: false,
        // header: Container(
        //   alignment: Alignment.topCenter,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.all(Radius.circular(24.0)),
        //         ),
        //         margin: const EdgeInsets.all(24.0),
        //         child: Text("This is the SlidingUpPanel when open"),
        //       ),
        //     ],
        //   ),
        // ),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(24.0),
        //   topRight: Radius.circular(24.0),
        // ),
        // footer: Center(child: Text('hi'),),
        panelSnapping: true,
        panel: Container(
          //*총 박스 색깔 및 그림자
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20.0,
                  color: Colors.grey,
                ),
              ]),
          //박스 밖 사이드 및 하단 비워놓을 공간
          margin: const EdgeInsets.all(24.0),
          child: //Padding(padding: EdgeInsets.all(10),child: Column(children: [Text('hi')],),),
              Padding(
            //박스 안 베젤공간
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //중앙에 있는 회색 스틱
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.0,
                ),
                //todo 시간흐를 때 마다 계속 위치 반환하고 폴리라인에 점 추가하는 함수 자동으로
                //구현하도록 setstate해서 해야할듯
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayminutes = StopWatchTimer.getDisplayTime(value,
                        hours: false,
                        minute: true,
                        second: false,
                        milliSecond: false);
                    final displayseconds = StopWatchTimer.getDisplayTime(value,
                        hours: false,
                        minute: false,
                        second: true,
                        milliSecond: false);
                    //*db저장용 데이터
                    final totalWalkingTime = StopWatchTimer.getDisplayTime(
                        value,
                        hours: true,
                        minute: true,
                        second: true,
                        milliSecond: false);
                    //*상단 목표달성 위젯 용 조건 함수
                    if (displayminutes == '05' && checkbool) {
                      // plusnum();
                      Get.find<WalktimeController>().plusStemnum();
                      showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            message: "10분 째 도달!",
                          ),
                          //onTap: ,
                          displayDuration: const Duration(milliseconds: 300));
                      checkbool = false;
                    }
                    if (displayminutes == '10' && checkbool == false) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        // plusnum();
                        Get.find<WalktimeController>().plusStemnum();
                        showTopSnackBar(
                            context,
                            CustomSnackBar.success(
                              message: "10분 째 도달!",
                            ),
                            //onTap: ,
                            displayDuration: const Duration(milliseconds: 300));
                      });
                      checkbool = true;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //* 달린 거리를 나타내주는 위젯
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  //! 이거 버그걸리는데 왜 걸리는지 궁금함
                                  _placeDistance,
                                  //'hi',
                                  //totalDistance,
                                  style: const TextStyle(
                                      fontSize: 45,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),

                                //* 초를 나타내는 위젯
                                // Text(
                                //   ':',
                                //   style: const TextStyle(
                                //       fontSize: 45,
                                //       fontFamily: 'Helvetica',
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // Text(
                                //   '00',
                                //   style: const TextStyle(
                                //       fontSize: 45,
                                //       fontFamily: 'Helvetica',
                                //       fontWeight: FontWeight.bold),
                                // ),
                              ],
                            ),
                            Text('DISTANCE')
                          ],
                        ),

                        //* 시간 나타내는 위젯
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  displayminutes,
                                  style: const TextStyle(
                                      fontSize: 45,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                                //* 초를 나타내는 위젯
                                Text(
                                  ':',
                                  style: const TextStyle(
                                      fontSize: 45,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  displayseconds,
                                  style: const TextStyle(
                                      fontSize: 45,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text('duration')
                          ],
                        ),
                        //*상단 목표달성 위젯 단계 조절 테스트용 버튼들
                        // TextButton(
                        //   onPressed: () {
                        //     print(int.parse(displayminutes));
                        //     print(displayseconds);
                        //     print('');
                        //     setState(() {
                        //       nowstepnum = 0;
                        //       Get.snackbar('dd', 'dd');
                        //     });
                        //   },
                        //   child: Text('check this out'),
                        // ),
                        // TextButton(
                        //   onPressed: () {
                        //     plusnum();
                        //     print(nowstepnum);
                        //   },
                        //   child: Text('plus stepper num'),
                        // ),
                      ],
                    );
                  },
                ),
                //타이머 버튼들
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(5),
                          primary: Colors.blue,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                        },
                        child: const Text(
                          'Start',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(4),
                        color: Colors.green,
                        shape: const StadiumBorder(),
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                          // if(this.mounted){
                          //   setState(() {
                          //     trackingState = false;
                          //   });
                          // }
                        },
                        child: const Text(
                          'Stop',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(4),
                        color: Colors.red,
                        shape: const StadiumBorder(),
                        onPressed: () async {
                          Get.defaultDialog(
                              title: "정말로 산책을 그만하실건가요?",
                              //middleText: "Hello world!",
                              backgroundColor: Colors.white,
                              titleStyle: Theme.of(context).textTheme.bodyText1,
                              middleTextStyle: TextStyle(color: Colors.white),
                              textConfirm: "그만할래요",
                              onConfirm: () {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.reset);
                                Get.find<WalktimeController>().setZero();
                              },
                              onCancel: () {
                                Get.back();
                              },
                              //돌아가기
                              cancel: ElevatedButton.icon(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: FaIcon(FontAwesomeIcons.redoAlt,
                                    size: 18, color: Colors.white),
                                label: Text(
                                  "더 할래요",
                                  style: TextStyle(color: Colors.black38),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.grey[300]),
                                  // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                                  textStyle: MaterialStateProperty.all(
                                    GoogleFonts.firaSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              // ArgonButton(
                              //   height: 50,
                              //   width: 350,
                              //   borderRadius: 5.0,
                              //   color: Colors.blue,
                              //   child: Text(
                              //     "더 할래요",
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.w700),
                              //   ),
                              //   loader: Container(
                              //     padding: EdgeInsets.all(10),
                              //     child: SpinKitRotatingCircle(
                              //       color: Colors.white,
                              //       // size: loaderWidth ,
                              //     ),
                              //   ),
                              //   onTap: (startLoading, stopLoading,
                              //       btnState) async {
                              //     if (btnState == ButtonState.Idle) {
                              //       startLoading();
                              //       await Future.delayed(Duration(seconds: 2));
                              //       stopLoading();
                              //       Get.back();
                              //     }
                              //   },
                              // ),
                              //산책끝
                              confirm: ElevatedButton.icon(
                                onPressed: () {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.reset);
                                  Get.find<WalktimeController>().setZero();
                                  //db로 기록넘기는 함수
                                  createtrackDaily(TrackingData(
                                      runningTime: walkingminTime,
                                      runningRecord: _placeDistance,
                                      date: _todayDate));
                                  //await Future.delayed(Duration(seconds: 2));
                                  // stopLoading();
                                  Get.back();
                                  Get.back();
                                },
                                icon: FaIcon(FontAwesomeIcons.times,
                                    size: 18, color: Colors.white),
                                label: Text(
                                  "그만할래요",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(_deepBlue),
                                  // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                                  textStyle: MaterialStateProperty.all(
                                    GoogleFonts.firaSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),

                              // ArgonButton(
                              //   height: 50,
                              //   width: 350,
                              //   borderRadius: 5.0,
                              //   color: Colors.red,
                              //   child: Text(
                              //     "그만할래요",
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.w700),
                              //   ),
                              //   loader: Container(
                              //     padding: EdgeInsets.all(10),
                              //     child: SpinKitRotatingCircle(
                              //       color: Colors.white,
                              //       // size: loaderWidth ,
                              //     ),
                              //   ),
                              //   onTap: (startLoading, stopLoading,
                              //       btnState) async {
                              //     if (btnState == ButtonState.Idle) {
                              //       startLoading();
                              //       _stopWatchTimer.onExecute
                              //           .add(StopWatchExecute.reset);
                              //       Get.find<WalktimeController>().setZero();
                              //       //db로 기록넘기는 함수
                              //       createtrackDaily(TrackingData(
                              //           runningTime: walkingminTime,
                              //           runningRecord: _placeDistance,
                              //           date: _todayDate));
                              //       await Future.delayed(Duration(seconds: 2));
                              //       stopLoading();
                              //       Get.back();
                              //       Get.back();
                              //     }
                              //   },
                              // ),
                              textCancel: "더 할래요",
                              cancelTextColor: Colors.white,
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                              barrierDismissible: false,
                              radius: 10,
                              content: Column(
                                children: [
                                  Container(child: Text('$_placeDistance km')),
                                  //todo 산책거리 뜨도록 글로번 변수에 집어넣기

                                  Container(child: Text('$walkingminTime 분 ')),
                                  //todo 이모지픽커

                                  RatingBar.builder(
                                    initialRating: 3,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, index) {
                                      switch (index) {
                                        case 0:
                                          return Icon(
                                            Icons.sentiment_very_dissatisfied,
                                            color: Colors.red,
                                          );
                                        case 1:
                                          return Icon(
                                            Icons.sentiment_dissatisfied,
                                            color: Colors.redAccent,
                                          );
                                        case 2:
                                          return Icon(
                                            Icons.sentiment_neutral,
                                            color: Colors.amber,
                                          );
                                        case 3:
                                          return Icon(
                                            Icons.sentiment_satisfied,
                                            color: Colors.lightGreen,
                                          );
                                        case 4:
                                          return Icon(
                                            Icons.sentiment_very_satisfied,
                                            color: Colors.green,
                                          );
                                        default:
                                          return Container();
                                      }
                                    },
                                    onRatingUpdate: (rating) {
                                      //   setState(() {
                                      //     _rating = rating;
                                      //   });
                                    },
                                    updateOnDrag: true,
                                  )
                                ],
                              ));
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TestWeather(0, true),
                  color: Colors.indigo[300],
                ),
                GetBuilder<WalktimeController>(
                  builder: (step) {
                    return NumberStepper(
                      stepRadius: 20,
                      activeStep: step.stepNum, //nowstepnum,//* 여기를 상태관리 해버리자
                      enableNextPreviousButtons: false,
                      enableStepTapping: false,
                      stepReachedAnimationEffect: Curves.easeInOutCirc,
                      onStepReached: (val) {
                        if (val == 1)
                          Get.snackbar('ff', '$val',
                              snackPosition: SnackPosition.TOP);
                      },
                      numbers: walktimeRecordList,
                      //동그라미 색깔
                      stepColor: Colors.white,
                      activeStepColor: Colors.indigo[400],
                    );
                  },
                ),
                //맵스타일 변경 버튼
                // AnimatedButtonBar(
                //   radius: 25.0,
                //   padding: const EdgeInsets.all(16.0),
                //   backgroundColor: Colors.blueGrey.shade800,
                //   foregroundColor: Colors.blueGrey.shade300,
                //   elevation: 24,
                //   borderColor: Colors.white,
                //   borderWidth: 2,
                //   innerVerticalPadding: 16,
                //   children: [
                //     ButtonBarEntry(
                //         onTap: () {
                //           if (this.mounted) {
                //             setState(() {
                //               _mapType = MapType.normal;
                //             });
                //           }
                //         },
                //         child: Icon(Icons.map_rounded)),
                //     ButtonBarEntry(
                //         onTap: () {
                //           if (this.mounted) {
                //             setState(() {
                //               _mapType = MapType.hybrid;
                //             });
                //           }
                //         },
                //         child: Icon(Icons.people)),
                //   ],
                // ),
                //todo 탭한 위치에 커스텀 마커저장, 긴급사운드 플레이어
                //SoundBell()
                SoundBell(),
                //todo 똥 오줌 기록이랑 전박적인 산책메모 사항 적을 칸
                Image(image: AssetImage('assets/images/dog-pee.png')),
                //todo 뭐 똥싼 횟수나 간식 준 횟수 체크용 카운터로 쓰자
                CounterButton(
                  loading: false,
                  onChange: (int val) {
                    setState(() {
                      _counterValue = val;
                    });
                  },
                  count: _counterValue,
                  countColor: Colors.purple,
                  buttonColor: Colors.purpleAccent,
                  progressColor: Colors.purpleAccent,
                ),
              ],
            ),
          ),
          // // display minute
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 0),
          //   child: StreamBuilder<int>(
          //     stream: _stopWatchTimer.minuteTime,
          //     initialData: _stopWatchTimer.minuteTime.value,
          //     builder: (context, snap) {
          //       final value = snap.data;
          //       print('Listen every minute. $value');
          //       return Column(
          //         children: <Widget>[
          //           Padding(
          //               padding: const EdgeInsets.all(8),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: <Widget>[
          //                   const Padding(
          //                     padding: EdgeInsets.symmetric(horizontal: 4),
          //                     child: Text(
          //                       'minute',
          //                       style: TextStyle(
          //                         fontSize: 17,
          //                         fontFamily: 'Helvetica',
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 4),
          //                     child: Text(
          //                       value.toString(),
          //                       style: const TextStyle(
          //                           fontSize: 30,
          //                           fontFamily: 'Helvetica',
          //                           fontWeight: FontWeight.bold),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ],
          //       );
          //     },
          //   ),
          // ),
          // /// Display every second.
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 0),
          //   child: StreamBuilder<int>(
          //     stream: _stopWatchTimer.secondTime,
          //     initialData: _stopWatchTimer.secondTime.value,
          //     builder: (context, snap) {
          //       final value = snap.data;
          //       print('Listen every second. $value');
          //       return Column(
          //         children: <Widget>[
          //           Padding(
          //               padding: const EdgeInsets.all(8),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: <Widget>[
          //                   const Padding(
          //                     padding: EdgeInsets.symmetric(horizontal: 4),
          //                     child: Text(
          //                       'second',
          //                       style: TextStyle(
          //                         fontSize: 17,
          //                         fontFamily: 'Helvetica',
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 4),
          //                     child: Text(
          //                       value.toString(),
          //                       style: const TextStyle(
          //                         fontSize: 30,
          //                         fontFamily: 'Helvetica',
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         ],
          //       );
          //     },
          //   ),
          // ),
          //버튼
        ),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(24.0),
        //   topRight: Radius.circular(24.0),
        // ),
        body: Stack(
          children: [
            //!ANCHOR: exceeded sample count in FrameTime는 구글맵 패키지 자체에 오류가 있는듯함

            GoogleMap(
              //åliteModeEnabled: true,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              compassEnabled: true,
              markers: _marker,
              polylines: lines,
              mapType: _mapType,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                //!맵 스타일 바꾸는 코드_법떄문에 안되는거였음

                // setState(() {
                //   controller.setMapStyle(_mapStyle);
                // });

                _controller.complete(controller);

                showLocationPins();
              },
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 2,
              right: 10,
              child: Column(
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                zoomLevel++;
                              });
                            }
                          },
                          icon: Icon(Icons.plus_one)),
                      IconButton(
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                zoomLevel--;
                              });
                            }
                          },
                          icon: Icon(Icons.exposure_minus_1_outlined)),
                    ],
                  )
                  //todo 산책시간에 따라 단계별로 스탭퍼 움직이도록 하게 하기
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
