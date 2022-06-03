import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//todo 차트의 형식을 선그래프나 바 차트로도 변환할 수 있도록 기능 추가할것
// https://velog.io/@adbr/flutter-line-chart꺽은선-그래프-구현하기2-flutter-flchart-example
class lineChart extends StatelessWidget {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height-55,
      //* 아래 컨테이너를 원래는 aspect ratio로 감싸줬었어
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Colors.indigo[100]),
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10,left: 10, right: 30),
          child: WeekTrackingChart(gradientColors: gradientColors),
        ),
      ),
    );
  }
}

class WeekTrackingChart extends StatelessWidget {
  const WeekTrackingChart({
    Key? key,
    required this.gradientColors,
  }) : super(key: key);

  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          //세로기준선
          drawVerticalLine: false,
          //가로기준선
          drawHorizontalLine: false,
          //기준선들의 색과 두께
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        //*좌우상단 타이틀
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTextStyles: (context, value) => const TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 14),
            getTitles: (value) {
              //x축에 들어갈 지점들 표현
              //print('bottomTitles $value');
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
              }
              return '';
            },
            margin: 8,
          ),
          //ANCHOR 그래프 디자인 어떠케 할거야양
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff67727d),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            getTitles: (value) {
              //print('leftTitles $value');
              switch (value.toInt()) {
                case 1:
                  return '10';
                case 2:
                  return '30';
                case 3:
                  return '50';
              }
              return '';
            },
            reservedSize: 15,
            margin: 12, //타이틀과 차트 간 거리
          ),
        ),
        //* 각 꼭지점(기준선들의 만남)의 데이터
        borderData: FlBorderData(
          show: false, //그래프 안 테두리
          border: Border.all(color: const Color(0xff37434d), width: 0.3,style: BorderStyle.none),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          //각 요일별 데이터값 넣을 곳
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
              FlSpot(1, 2),
              FlSpot(2, 1),
              FlSpot(3, 2),
              FlSpot(4, 3),
              FlSpot(5, 2),
              FlSpot(6, 2),
            ],
            isCurved: true,
            colors: gradientColors, //클릭시 표시되는 점의 색깔
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
