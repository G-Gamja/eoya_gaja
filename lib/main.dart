//import 'package:eoyagaja/src/checkCState.txt';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import ' screen/junk/oldCalendar.dart';
import ' screen/mainScreen.dart';
import ' screen/addtaskpage.dart';
import ' screen/taskmanager.dart';
import 'src/checkCState.dart';

//import ' screen/loginscreen.dart';
// 이거 보고 쓸만한거 찾아보기 https://github.com/adrianos42/desktop
//네이버 로그인 패지: https://pub.dev/packages/flutter_naver_login/install
//로그인 패키지 https://pub.dev/packages/flutter_login/install
//슬라이드 시 항목 삭제되는 패키지 https://pub.dev/packages/flutter_slidable/example
//  desktop_window: ^0.4.0 게이지를 위한 패키지
// 와이파이 연결상태 확인해주는 connectivity도 설치해보기
//syncfusion_flutter_gauges: ^19.3.44 게이지 패키지 https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/gauge/showcase/gauge_compass.dart
//https://pub.dev/packages/sliding_up_panel: 슬라이딩 패널 만드는 패키지:산책 스크린에서 써봄직?

//* responsive로 앱 리팩터링 한번 해야 함
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // AppSettings settings = AppSettings();

  // // Don't allow landscape mode
  // SystemChrome.setPreferredOrientations(
  //         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
  //     .then((_) => runApp(MyApp(settings: settings)));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

//flutter run --no-sound-null-safety
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EoYaGaja',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KO'),
      ],

      theme: ThemeData(
        primaryColor: const Color(
            0xff2e3c81), //const Color(0xffec5a2a), //const Color(0xff2e3c81),
        highlightColor: const Color(
            0xff8a80fe), //Color(0xff212123), //Color(0xff333e4a), //const Color(0xff8a80fe),
        scaffoldBackgroundColor: const Color(0xfff5f4f4),
        //기존 토스 바탕색 const Color(0xffECF2F9), //const Color(0xff964b00),
        primarySwatch: Colors.indigo,
        primaryColorBrightness: Brightness.light,
        colorScheme: const ColorScheme.light(),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.orange),
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          headline3: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
            color: Colors.orange,
          ),
          button: GoogleFonts.firaSans(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          caption: GoogleFonts.firaSans(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          headline1: GoogleFonts.firaSans(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          //메인 박스 좌측 위 텍스트 스타일
          headline2: GoogleFonts.nanumGothic(
            textStyle: const TextStyle(
                color: Color(0xff3d4373),
                fontSize: 17,
                fontWeight: FontWeight.w800),
          ),
          //메인 박스 안 텍스트 스타일
          headline4: GoogleFonts.nanumGothic(
            textStyle: const TextStyle(
                color: Color(0xff3d4373),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          headline5: GoogleFonts.firaSans(
            textStyle: const TextStyle(
                color: Colors.pink,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          headline6: GoogleFonts.firaSans(
            textStyle: const TextStyle(
                color: Colors.pink,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          subtitle1: GoogleFonts.nanumGothic(
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          // GoogleFonts.jua(
          //   textStyle: TextStyle(
          //       color: Colors.black,
          //       fontSize: 15,
          //       fontWeight: FontWeight.normal),
          // ),
          // TextStyle(
          //   fontFamily: 'TmonMonsori',
          //   fontSize: 17.0,
          //   // fontWeight: FontWeight.w400,
          //   color: Colors.orange,
          // ),
          bodyText1: GoogleFonts.nanumGothic(
            textStyle: const TextStyle(
                color: Color(0xff3d4373),
                fontSize: 18,
                fontWeight: FontWeight.w800),
          ),
          bodyText2: GoogleFonts.firaSans(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          subtitle2: GoogleFonts.firaSans(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
          overline: GoogleFonts.firaSans(
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
      home: CheckState(),
      routes: {
        //! 라우팅 설정해놓은건 어떻게 인자 할당을 해야하지?
        //DiaryScreen.routeName: (ctx) => DiaryScreen(),

        TaskManagerScreen.routeName: (ctx) => TaskManagerScreen(),
        AddTaskPage.routeName: (ctx) => AddTaskPage(),
        MainScreen.routeName: (ctx) => MainScreen(),
      },
      //get용 라우터 성정
      getPages: [
        // GetPage(name: DiaryScreen.routeName, page: () => DiaryScreen()),

        GetPage(
            name: TaskManagerScreen.routeName,
            page: () => TaskManagerScreen(),
            transition: Transition.zoom),
        GetPage(name: AddTaskPage.routeName, page: () => AddTaskPage()),
        GetPage(name: OldCalendar.routeName, page: () => OldCalendar()),
      ],
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'fsdf',
//       theme: ThemeData(
//           primaryColor: Colors.black,
//           accentColor: Colors.brown),
        
//       home: CheckState(),
//       routes: {
//         MainScreen.routeName: (ctx) => MainScreen(),
//         SettingScreen.routeName: (ctx) => SettingScreen(),
//         //CalendarScreen.routeName: (ctx) => CalendarScreen(),
//         SanchackScreen.routeName: (ctx) => SanchackScreen(),
//         TotalSumScreen.routeName: (ctx) =>TotalSumScreen(),
//         ChatScreen.routeName: (ctx) => ChatScreen(),
//         BarChartPage.routeName: (ctx) => BarChartPage(),
//       },
//     );
//   }
// }
