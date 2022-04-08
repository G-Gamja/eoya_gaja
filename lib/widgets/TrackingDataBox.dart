import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../textWidget/FiraText.dart';

class TrackingDataBox extends StatelessWidget {
  const TrackingDataBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(4),
      width: MediaQuery.of(context).size.width,
      height: 100,
      //height: MediaQuery.of(context).size.height-20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.grey[200] as Color)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //* 산책 거리에 따라 트로피 이미지
          Container(
            // margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            width: 70,
            height: 70,
            //height: MediaQuery.of(context).size.height-20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.indigoAccent,
                border: Border.all(width: 1, color: Colors.grey[200] as Color)),
            child: Image(image: AssetImage('assets/images/trophy.png')),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                    text: '17.5',
                    style: GoogleFonts.firaSans(
                      textStyle: TextStyle(
                          color: Colors.amber,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'km',
                        style: GoogleFonts.firaSans(
                          textStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ]),
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.alarm_on_outlined),
                  SizedBox(
                    width: 5,
                  ),
                  FiraText('23:20', Colors.black, 15, FontWeight.normal),
                  SizedBox(
                    width: 5,
                  ),

                  //todo 불 이모지로 대체할것
                  Icon(Icons.fire_extinguisher),
                  SizedBox(
                    width: 5,
                  ),
                  FiraText('40 kcal', Colors.black, 15, FontWeight.normal),
                  SizedBox(
                    width: 10,
                  ),
                  FiraText('1/12', Colors.black, 18, FontWeight.normal),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
