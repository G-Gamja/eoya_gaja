import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:polymaker/core/models/trackingmode.dart';
import 'package:polymaker/polymaker.dart' as polymaker;
import 'package:get/get_navigation/get_navigation.dart';
import 'dart:math' show cos, sqrt, asin;

class ManualTrackingScreen extends StatefulWidget {
  @override
  _ManualTrackingScreenState createState() => _ManualTrackingScreenState();
}

class _ManualTrackingScreenState extends State<ManualTrackingScreen> {
  List<LatLng>? locationList;
  String _placeDistance = '0:00';
  double totalDistance = 0.0;
  void getLocationn() async {
    var result = await polymaker.getLocation(context,
        polygonColor: Theme.of(context).primaryColor,
        toolColor: const Color(0xff2e3c81),
        pointDistance: false,
        trackingMode: TrackingMode.LINEAR,
        enableDragMarker: true);
    if (result != null) {
      setState(() {
        locationList = result;
      });
      _calculateDistance(locationList, totalDistance);
    }
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _calculateDistance(linePoints, totalDistance) async {
    for (int i = 0; i < linePoints.length - 1; i++) {
      totalDistance += _coordinateDistance(
        linePoints[i].latitude,
        linePoints[i].longitude,
        linePoints[i + 1].latitude,
        linePoints[i + 1].longitude,
      );
    }
    if (this.mounted) {
      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
      });
    }
  }

  Timestamp _selectedDate = Timestamp.fromDate(DateTime.now());
  String? dbdate;
  @override
  void initState() {
    super.initState();
    locationList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            DateTimePicker(
              locale: Locale('ko'),
              type: DateTimePickerType.dateTimeSeparate,
              // dateMask: 'yyyy, MMM DDD',
              initialValue: DateTime.now().toString(),
              //_getdate, // getdate, //+ DateTime.now().hour.toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: FaIcon(FontAwesomeIcons.calendarPlus),
              dateLabelText: '날짜',
              timeLabelText: "시간",
              // selectableDayPredicate: (ddate) {
              //   // Disable weekend days to select from the calendar
              //   if (ddate.weekday == 6 || ddate.weekday == 7) {
              //     return false;
              //   }

              //   return true;
              // },
              //onChanged: (val) => print(val),
              // validator: (val) {
              //   print(val);
              //   return null;
              // },
              onSaved: //(val) => print(val),
                  (val) {
                setState(
                  () {
                    _selectedDate = Timestamp.fromDate(
                      DateTime.parse(val!),
                    );
                    dbdate = DateFormat('yyyy-MM-dd,EEE')
                        .format(DateTime.parse(val));
                  },
                );
              },
            ),
            Text(
              "Location Result: \n" +
                  (locationList != null
                      ? locationList!
                          .map((val) => "[${val.latitude}, ${val.longitude}]\n")
                          .toString()
                      : ""),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '$_placeDistance km',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => getLocationn(),
                child: Text(
                  "Get Polygon Location",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
