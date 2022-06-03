import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:get/route_manager.dart';

class GoButton extends StatefulWidget {
  Widget? iconimage;
  String? iconString;
  String? maintxt;
  Color? backGroundColor;
  Widget? goWidget;
  GoButton(
      {this.iconimage,
      this.iconString,
      this.maintxt,
      this.backGroundColor,
      this.goWidget});
  @override
  _GoButtonState createState() => _GoButtonState();
}

class _GoButtonState extends State<GoButton> {
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 100,
      width: 170, //MediaQuery.of(context).size.width / 3,
      child: AddToCartButton(
        streetLineDashWidth: 1,
        trolleyLeftMargin: 8,
        trolley: widget.iconimage == null
            ? Image.asset(
                widget.iconString!,
                width: 40,
                height: 40,
                color: Colors.white,
              )
            : widget.iconimage!,
        text: Text(
          widget.maintxt!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
        //todo 이거 사이즈 바꿔버려
        check: SizedBox(
          width: 80,
          height: 80,
          child: Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        borderRadius: BorderRadius.circular(24),
        backgroundColor: widget.backGroundColor,
        onPressed: (id) {
          if (id == AddToCartButtonStateId.idle) {
            //handle logic when pressed on idle state button.
            setState(() {
              stateId = AddToCartButtonStateId.loading;
              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  stateId = AddToCartButtonStateId.done;
                });
              });
            });
            //Get.to(TrackingMapScreen());
          } else if (id == AddToCartButtonStateId.done) {
            //handle logic when pressed on done state button.
            setState(() {
              stateId = AddToCartButtonStateId.idle;
            });
            Get.to(widget.goWidget, transition: Transition.zoom);
          }
        },
        stateId: stateId,
      ),
    );
  }
}
