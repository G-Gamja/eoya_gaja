import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BarChartwidget extends StatefulWidget {
  @override
  State<BarChartwidget> createState() => _BarChartwidgetState();
}

class _BarChartwidgetState extends State<BarChartwidget> {
  //* 바 배경색
  final Color barBackgroundColor = Colors.grey.shade200;

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    //원래는 aspectratio가 1비율로 wrap되어있었음
    return Container(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      // elevation: 2,
      decoration: BoxDecoration(
        color: Colors
            .white, //Theme.of(context).primaryColor, //Colors.white, //_boxcolor.withOpacity(1.0),
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.15), //color of shadow
        //     spreadRadius: 5, //spread radius
        //     blurRadius: 7, // blur radius
        //     offset: Offset(0, 2), // changes position of shadow
        //     //first paramerter of offset is left-right
        //     //second parameter is top to down
        //   ),
        //   //you can set more BoxShadow() here
        // ],
      ),
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('이 주의 산책기록',
                      style: Theme.of(context).textTheme.headline2),
                  const Icon(Icons.bar_chart_rounded)
                  // IconButton(
                  //           onPressed: () => changeChart(),
                  //           icon: lineChartValue
                  //               ? const Icon(Icons.line_style_rounded)
                  //               : const Icon(Icons.bar_chart_rounded)),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 4,
            // ),
            // const Text(
            //   'Grafik konsumsi kalori',
            //   style: TextStyle(
            //       color: Color(0xff379982),
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(
            //   height: 38,
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 0), //const EdgeInsets.symmetric(horizontal: 8.0),
                child: BarChart(
                  // isPlaying ? randomData() :
                  mainBarData(),
                  swapAnimationDuration: animDuration,
                ),
              ),
            ),
            // const SizedBox(
            //   height: 12,
            // ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color(0xffc6e8fe),
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Color(0xff8a80fe)] : GradientColors.winterNeva,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Color(0xff8a80fe), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            //! y축 최대치
            y: 10,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 7, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 4, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            //*터치시 나오는 박스의 색깔
            tooltipBgColor: Color(0xff8a80fe),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '월요일';
                  break;
                case 1:
                  weekDay = '화요일';
                  break;
                case 2:
                  weekDay = '수요일';
                  break;
                case 3:
                  weekDay = '목요일';
                  break;
                case 4:
                  weekDay = '금요일';
                  break;
                case 5:
                  weekDay = '토요일';
                  break;
                case 6:
                  weekDay = '일요일';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff3d4373), //Color(0xff8b8f99),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  // BarChartData randomData() {
  //   return BarChartData(
  //     barTouchData: BarTouchData(
  //       enabled: false,
  //     ),
  //     titlesData: FlTitlesData(
  //         show: true,
  //         bottomTitles: SideTitles(
  //           showTitles: true,
  //           getTextStyles: (context, value) => const TextStyle(
  //               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
  //           margin: 16,
  //           getTitles: (double value) {
  //             switch (value.toInt()) {
  //               case 0:
  //                 return 'M';
  //               case 1:
  //                 return 'T';
  //               case 2:
  //                 return 'W';
  //               case 3:
  //                 return 'T';
  //               case 4:
  //                 return 'F';
  //               case 5:
  //                 return 'S';
  //               case 6:
  //                 return 'S';
  //               default:
  //                 return '';
  //             }
  //           },
  //         ),
  //         leftTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //         topTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //         rightTitles: SideTitles(
  //           showTitles: false,
  //         )),
  //     borderData: FlBorderData(
  //       show: false,
  //     ),
  //     barGroups: List.generate(7, (i) {
  //       switch (i) {
  //         case 0:
  //           return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
  //               barColor: widget.availableColors[
  //                   Random().nextInt(widget.availableColors.length)]);
  //         case 1:
  //           return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
  //               barColor: widget.availableColors[
  //                   Random().nextInt(widget.availableColors.length)]);
  //         case 2:
  //           return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
  //               barColor: widget.availableColors[
  //                   Random().nextInt(widget.availableColors.length)]);
  //         case 3:
  //           return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
  //               barColor: widget.availableColors[
  //                   Random().nextInt(widget.availableColors.length)]);
  //         case 4:
  //           return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
  //               barColor: widget.availableColors[
  //                   Random().nextInt(widget.availableColors.length)]);
  //         case 5:
  //           return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
  //               barColor: widget.availableColors[
  //                   Random().nextInt(widget.availableColors.length)]);
  //         case 6:
  //           return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
  //               barColor: widget.availableColors[
  //                   Random().nextInt(widget.availableColors.length)]);
  //         default:
  //           return throw Error();
  //       }
  //     }),
  //     gridData: FlGridData(show: false),
  //   );
  // }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}
