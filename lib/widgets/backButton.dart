import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

class BlueBackButton extends StatelessWidget {
  const BlueBackButton({
    Key? key,
    required Color deepBlue,
  })  : _deepBlue = deepBlue,
        // _onPressed = onPressed,
        super(key: key);

  final Color _deepBlue;
  //final Function _onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          onPressed: () => Get.back(),
          icon: const FaIcon(
            FontAwesomeIcons.angleLeft,
            size: 23,
          ),
          color: _deepBlue),
    );
  }
}
