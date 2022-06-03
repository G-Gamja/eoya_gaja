
import 'package:geolocator/geolocator.dart';
import 'package:get/state_manager.dart';

class PositionController extends GetxController {
  //현재위치 변수
 static Position? curPos;
 static Position? startPos;

  void getCrntLctn() async{
        curPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
        startPos = curPos;
        
update();
  }
      //       Widget  a=  PlatformMap(
      //         mapType: MapType.hybrid,
      //   initialCameraPosition: CameraPosition(
      //         target:  LatLng(curPos!.latitude,curPos!.longitude),
      //         zoom: 16.0,
      //   ),
      //   markers: Set<Marker>.of(
      //         [
      //           Marker(
                  
      //             markerId: MarkerId('marker_1'),
      //             position: LatLng(curPos!.latitude,curPos!.longitude),
      //             consumeTapEvents: true,
      //             infoWindow: InfoWindow(
      //               title: 'PlatformMarker',
      //               snippet: "Hi I'm a Platform Marker",
      //             ),
      //             onTap: () {
      //               print("Marker tapped");
      //             },
      //           ),
      //         ],
      //   ),
      //   myLocationEnabled: true,
      //   myLocationButtonEnabled: true,
      //   onTap: (location) => print('onTap: $location'),
      //   onCameraMove: (cameraUpdate) => print('onCameraMove: $cameraUpdate'),
      //   compassEnabled: true,
      //   onMapCreated: (controller) {
      //         Future.delayed(Duration(seconds: 2)).then(
      //           (_) {
      //             controller.animateCamera(
      //               CameraUpdate.newCameraPosition(
      //                 const CameraPosition(
      //                   bearing: 270.0,
      //                   target: LatLng(51.5160895, -0.1294527),
      //                   tilt: 30.0,
      //                   zoom: 18,
      //                 ),
      //               ),
      //             );
      //           },
      //         );
      //   },
      // );
}