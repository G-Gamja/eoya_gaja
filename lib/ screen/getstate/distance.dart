import 'package:get/state_manager.dart';
import 'dart:math' show cos, sqrt, asin;

class DistanceController extends GetxController {
  double _placeDistance = 0;
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void calculateDistance(linePoints, totalDistance, _placeDistance2) {
    for (int i = 0; i < linePoints.length - 1; i++) {
      totalDistance += _coordinateDistance(
        linePoints[i].latitude,
        linePoints[i].longitude,
        linePoints[i + 1].latitude,
        linePoints[i + 1].longitude,
      );

      _placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_placeDistance km');
    }
    update();
  }
}
