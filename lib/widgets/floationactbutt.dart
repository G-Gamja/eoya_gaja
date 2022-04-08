import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class FloationgActButton extends StatelessWidget {
  Function? func1;
  String? firstButtonName;
  Function? func2;
  String? secondButtonName;

  FloationgActButton(
      this.func1, this.firstButtonName, this.func2, this.secondButtonName);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      child: const FaIcon(FontAwesomeIcons.penAlt),
      closedForegroundColor: Colors.white,
      openForegroundColor: Theme.of(context).highlightColor,
      closedBackgroundColor: Theme.of(context).highlightColor,
      openBackgroundColor: Colors.white,
      //labelsStyle: //TextStyle(),//*버튼 옆  레이블,
      //controller:  /* Your custom animation controller goes here */,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: const FaIcon(FontAwesomeIcons.plus),
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).highlightColor,
          label: firstButtonName,
          onPressed: func1,
          closeSpeedDialOnPressed: false,
        ),
        SpeedDialChild(
            child: const FaIcon(FontAwesomeIcons.stickyNote),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).highlightColor,
            label: secondButtonName,
            onPressed: func2),
        //  Your other SpeeDialChildren go here.
      ],
    );
  }
}
