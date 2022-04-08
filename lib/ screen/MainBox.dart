import 'package:flutter/material.dart';

class TopItems extends StatelessWidget {
  String _mainhead;
  //int _subnum;
  Color _boxcolor;
  //IconData _icon;
  String _iconString;
  TopItems(this._mainhead, this._boxcolor, this._iconString);
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(right: 15),
      //padding: EdgeInsets.all(10),
      height: 100,
      width: 150,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Icon(_icon,size: 40,color: Colors.indigo[400],),
              Image.asset(_iconString,
                  width: 40, height: 40, color: _boxcolor //Colors.indigo[400],
                  ),
              // Text(
              //   _mainhead,
              //   style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
              // ),
            ],
          ),
          SizedBox(
              // height: 5,
              ),
          SizedBox(
              // height: 5,
              ),
          Container(
            //width: 100,
            child: FittedBox(
              child:
                  Text('6h 45m', style: Theme.of(context).textTheme.headline4),
            ),
          ),
          Container(
            // width: 130,
            child: FittedBox(
              child:
                  Text('0.45km', style: Theme.of(context).textTheme.headline4),
            ),
          ),
        ],
      ),
    );
  }
}
