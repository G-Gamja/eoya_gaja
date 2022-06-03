import 'package:card_swiper/card_swiper.dart';
import 'package:eoya_gaja/%20screen/shimmerScreen.dart';
import 'package:eoya_gaja/textWidget/BaeMinText.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../textWidget/FiraText.dart';
import '../widgets/barChart.dart';
import '../widgets/lineChart.dart';
import 'MainBox.dart';
import 'package:get/get.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';

import 'getstate/weatherstate.dart';
import 'playground.dart';
import 'rights.dart';
import 'userscreen.dart';
import 'weather.dart';
//uid 따오는법
// var currentUser = FirebaseAuth.instance.currentUser;

// if (currentUser != null) {
//   print(currentUser.uid);
// }

//6efa95f0e038f8560fa32f12655c75fe
class DiaryScreen extends StatefulWidget {
  static const routeName = '/homediary';
  //todo 날씨 위젯 메인 스크린에서 받아와서 매번 다시 그리지 않도록 하게 만들기

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<QudsPopupMenuBase> getMenuItems() {
    return [
      QudsPopupMenuSection(
          backgroundColor: Colors.yellow.shade200,
          titleText: 'Logout',
          subTitle: const Text('로그아웃을 하고 싶다면 이곳으로'),
          leading: const Icon(
            Icons.redeem,
            //size: 35,
          ),
          subItems: [
            QudsPopupMenuSection(
                titleText: 'Settings',
                leading: const Icon(Icons.settings),
                subItems: [
                  QudsPopupMenuItem(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onPressed: FirebaseAuth.instance.signOut)
                ]),
          ]),
      QudsPopupMenuDivider(),
      QudsPopupMenuItem(
          leading: const Icon(Icons.info_outline),
          title: const Text('Go to play ground'),
          subTitle: const Text('this is subtitle'),
          onPressed: () {
            Get.to(() => playGround());
          }),
      QudsPopupMenuDivider(),
      QudsPopupMenuSection(
          leading: const FaIcon(
            FontAwesomeIcons.cog,
            color: Color(0xff2e3c81),
          ),
          titleText: 'Settings & Privacy',
          subItems: [
            QudsPopupMenuItem(
                leading: const FaIcon(
                  FontAwesomeIcons.cog,
                  color: Color(0xff2e3c81),
                ),
                title: const Text('Settings'),
                onPressed: () {
                  //showToast('Settings Pressed!');
                }),
            QudsPopupMenuItem(
                leading: const Icon(Icons.lock),
                title: const Text('Privacy Checkup'),
                onPressed: () {
                  //showToast('Privacy Checkup Pressed!');
                }),
            QudsPopupMenuItem(
                leading: const Icon(Icons.lock_clock),
                title: const Text('Privacy Shortcuts'),
                onPressed: () {
                  // showToast('Privacy Shourtcuts Pressed!');
                }),
            QudsPopupMenuItem(
                leading: const Icon(Icons.list),
                title: const Text('Activity Log'),
                onPressed: () {
                  // showToast('Activity Log Pressed!');
                }),
            QudsPopupMenuItem(
                leading: const Icon(Icons.card_membership),
                title: const Text('News Feed Preferences'),
                onPressed: () {
                  // showToast('News Feed Preferences Pressed!');
                }),
            QudsPopupMenuItem(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                onPressed: () {
                  //showToast('Language Pressed!');
                }),
          ]),
      QudsPopupMenuDivider(),
      QudsPopupMenuWidget(
          builder: (c) => Container(
              padding: const EdgeInsets.all(10),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          // showToast('Favourite Pressed!');
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )),
                    const VerticalDivider(),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.music_note,
                          color: Colors.blue,
                        )),
                    const VerticalDivider(),
                    IconButton(
                        onPressed: () {
                          Get.to(() => const RightsScreen());
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.copyright,
                          color: Color(0xff2e3c81),
                        ))
                  ],
                ),
              )))
    ];
  }

//* shimmer스크림을 위한 변수인데 지금 해결못해서 일단은 킾해놨음
//todo 그냥 날씨 위젯을 꺼내와서 이거 자체를 빌더로 묶어서 컨트롤러 받아오자
  final bool _weatherloading = true;
  bool lineChartValue = false;
  // @override
  // void initState() {
  //   super.initState();
  //   //Get.put(WeatherControlloer());
  //   _weatherloading = true;
  //   // if(wconn.weatherIcon != null){
  //   //   setState(() {
  //   //     _weatherloading = false;
  //   //   });
  //   // }
  //   loadWeather();
  // }

  // Future loadWeather() async {
  //   setState(() => _weatherloading = true);
  //   await Future.delayed(Duration(seconds: 2), () {});
  //  // await Future.delayed()
  //  //Get.put(WeatherControlloer());
  //   Get.find<WeatherControlloer>().queryWeather();

  //   setState(() => _weatherloading = false);
  // }

  void changeChart() {
    setState(() => lineChartValue = !lineChartValue);
  }

// (0xff2e3c81);기존 딥블루값 (0xff183153) 폰트어썸값
  // Color(0xff1d256e);
  final Color _textColor = const Color(0xff3d4373);
  //*컬러값
  // final Color Theme.of(context).scaffoldBackgroundColor =
  //     const Color(0xffECF2F9); //const Color(0xffECF2F9);
  @override
  Widget build(BuildContext context) {
    //todo 날씨정보 받아들이는대로 원래 창으로 넘어갸아하는데 이게 왜 안받아질까나
    //Get.find<WeatherControlloer>().queryWeather();
    //스캐폴드로 바탕을 감싸줘야 텍스트에 밑줄이 안생김

    return
        // _weatherloading
        // ? ShimmerScreen()
        // :
        Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, //Color(0xFFD4E7FE),
      //floatingActionButton:,
      //  FloatingActionButton(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //   onPressed: () {},
      //),
      appBar: AppBar(
        //todo 챗 앱에 있는 로그아웃 드랍다운메뉴버튼 참조해서 다시 그릴것
        actions: [
          //PopupMenuButton(itemBuilder: itemBuilder)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: QudsPopupButton(
                radius: 100,
                backgroundColor: Colors.white,
                tooltip: 'T',
                items: getMenuItems(),
                child: FaIcon(
                  FontAwesomeIcons.bars,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                )),
          ),
          Container(
            width: 20,
          ),
          //* basic Popup menu button
          // PopupMenuButton<MenuType>(
          //   icon: Icon(Icons.settings),
          //   onSelected: (MenuType result) {
          //     setState(() {
          //       _selection = result;
          //     });
          //   },
          //   itemBuilder: (BuildContext context) => MenuType.values
          //       .map((value) => PopupMenuItem(
          //             value: value,
          //             child: Text(value.toShortString()),
          //           ))
          //       .toList(),
          // ),
        ],
        //shadowColor: Color(0xFFD4E7FE),
        elevation: 0,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, //Color(0xFFD4E7FE),
        //*메인 사진과 이름과 오늘날짜
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  Get.to(() => UserScreen(), transition: Transition.upToDown),
              child: Container(
                child: FluttermojiCircleAvatar(
                  // radius: 30,
                  backgroundColor: _textColor,
                ),
                width: 60,
                height: 60,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(100),
                //                     border: Border.all(width: 1, color: Colors.white),
                //                     //그림자
                //                     // boxShadow: [
                //                     //   BoxShadow(
                //                     //     color: Theme.of(context).primaryColor,
                //                     //     blurRadius: 5,
                //                     //     spreadRadius: 3,
                //                     //   )
                //                     // ],

                //                     //todo cached_network_image 써봐
                // //                     CachedNetworkImage(
                // //     imageUrl: "http://via.placeholder.com/350x150",
                // //     progressIndicatorBuilder: (context, url, downloadProgress) =>
                // //             CircularProgressIndicator(value: downloadProgress.progress),
                // //     errorWidget: (context, url, error) => Icon(Icons.error),
                // //  ),
                //                     // image: DecorationImage(
                //                     //   fit: BoxFit.cover,
                //                     //   image: AssetImage('assets/images/ahn.png'),
                //                     // ),
                //                   ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //BaeMinText('구감자', _textColor, 24, FontWeight.w100),
                Text(
                  '구감자',
                  style: GoogleFonts.nanumGothic(
                    textStyle: const TextStyle(
                        color: Color(0xff3d4373),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // Text(
                //   '구감자',
                //   style: TextStyle(
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold,
                //       color: _textColor),
                // ),
                Text(
                  DateFormat.yMd('ko').format(
                    DateTime.now(),
                  ),
                  style: GoogleFonts.nanumGothic(
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 142, 144, 165),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  // const TextStyle(
                  //     fontFamily: "CeraRound",
                  //     color: Color.fromARGB(255, 142, 144, 165),
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //상단 오늘 날짜랑 사용자 인포
          Expanded(
            flex: 2,
            child: SafeArea(
              child: Container(
                //color: Colors.blueGrey,
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor,
                  // border: Border.all(
                  //     color: Theme.of(context).primaryColor, width: )
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5), //color of shadow
                  //     spreadRadius: 5, //spread radius
                  //     blurRadius: 7, // blur radius
                  //     offset: Offset(0, 2), // changes position of shadow
                  //     //first paramerter of offset is left-right
                  //     //second parameter is top to down
                  //   ),
                  //you can set more BoxShadow() here
                  //],
                ),
                //mainAxisSize: MainAxisSize.min,

                child: Swiper(
                  //duration:1,
                  itemBuilder: (BuildContext context, int index) {
                    return TestWeather(index, _weatherloading);
                  },
                  //*페이지 나타내주는 동그라미들
                  pagination: const SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                          //* 액티브된 카드 인덱션 컬러는 여기
                          activeColor: Color(0xff8a80fe))),
                  itemCount: 3,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  //duration: 1,

                  // control: SwiperControl(
                  //     iconNext: Icons.circle_rounded,
                  //     iconPrevious: Icons.arrow_back_ios_rounded,
                  //     color: Colors.white,
                  //     disableColor: _textColor),
                ),
              ),
            ),
          ),

          Expanded(
            //top: MediaQuery.of(context).size.height - 750,
            // top: (MediaQuery.of(context).size.height -
            //         //appBar.preferredSize.height -
            //         MediaQuery.of(context).padding.top) *
            //     0.2,
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              // height: (MediaQuery.of(context).size.height -
              // (MediaQuery.of(context).size.height - 750)),
              // width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // HomeHeadText('오늘의 통계', 5),

                  //메인 박스 타일
                  //MainBoxTile(),
                  //*식사 패널
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, //_boxcolor.withOpacity(1.0),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.grey.withOpacity(0.15), //color of shadow
                          spreadRadius: 5, //spread radius
                          blurRadius: 7, // blur radius
                          offset: Offset(0, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          //한국말로 다 바꾸기
                          child: Text('오늘의 식사',
                              style: Theme.of(context).textTheme.headline2),
                          //  Text(
                          //   'Today\'s Reports',
                          //   style: TextStyle(
                          //       fontFamily: "CeraRound",
                          //       color: Color(0xff3d4373),
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w600),
                          // ),
                          // BaeMinText('Today\'s Reports', _textColor, 20, FontWeight.w100),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TopItems(
                                  '사료 4컵',
                                  '500g',
                                  //Theme.of(context).highlightColor,
                                  'assets/images/dog-dish.png'),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 3,
                                height: 40,
                              ),
                              TopItems(
                                  '츄르',
                                  '2 스틱',
                                  // Theme.of(context).highlightColor,
                                  'assets/images/dog-dish.png')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Padding(
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  //       child: Text(
                  //         '이 주의 산책기록',
                  //         style: GoogleFonts.nanumGothic(
                  //           textStyle: TextStyle(
                  //               color: _textColor,
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.w800),
                  //         ),
                  //       ),
                  //       // Text(
                  //       //   'Weekly Reports',
                  //       //   style: TextStyle(
                  //       //       fontFamily: "CeraRound",
                  //       //       color: Color(0xff3d4373),
                  //       //       fontSize: 20,
                  //       //       fontWeight: FontWeight.w600),
                  //       // ),

                  //       //  FiraText(
                  //       //     'Weekly Reports', _textColor, 20, FontWeight.bold),
                  //     ),
                  //     IconButton(
                  //         onPressed: () => changeChart(),
                  //         icon: lineChartValue
                  //             ? const Icon(Icons.line_style_rounded)
                  //             : const Icon(Icons.bar_chart_rounded)),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: lineChartValue ? lineChart() : BarChartwidget()),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       BottomItems('today', 5, Colors.purple),
                  //       BottomItems('today', 5, Colors.purple),
                  //       BottomItems('today', 5, Colors.purple),
                  //       BottomItems('today', 5, Colors.purple),
                  //     ],
                  //   ),
                  // ),

                  //맨아래 스크롤되는 아이템
                  //listview.builder때문에 이렇게 한건데 expanded때문에 사이즈 안맞으니까 잘 해결
                  // Expanded(
                  //   child: Align(
                  //     alignment: Alignment.topCenter,
                  //     child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: 5,
                  //       itemBuilder: (BuildContext context, int index) {
                  //         return Row(
                  //           children: [
                  //             BottomItems('오늘의 뭐시기', index, Colors.yellow),
                  //           ],
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
