import 'package:flutter/material.dart';
import 'package:flutter_circle_chart/flutter_circle_chart.dart';

class CircleChartWidget extends StatefulWidget {
  @override
  _CircleChartWidgetState createState() => _CircleChartWidgetState();
}

class _CircleChartWidgetState extends State<CircleChartWidget> {
  @override
  Widget build(BuildContext context) {
    return CircleChart(
      backgroundColor: Colors.indigo,
      chartType: CircleChartType.solid,
      items: [
        CircleChartItemData(
            color: Colors.indigo, value: 5, name: 'hi', description: 'de')
           , CircleChartItemData(
            color: Colors.lime, value: 10, name: 'hi3', description: 'de2')
      ],
    );
  }
}
