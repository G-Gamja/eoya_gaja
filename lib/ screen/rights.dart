import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class RightsScreen extends StatelessWidget {
  const RightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // 달력 빈 페이지
            // <a href="https://www.flaticon.com/free-animated-icons/paper" title="paper animated icons">Paper animated icons created by Freepik - Flaticon</a>
            //개밥통
             Text(
                ' <a href="https://www.flaticon.com/free-icons/pet" title="pet icons">Pet icons created by Freepik - Flaticon</a>'),
            //리드줄 강아지
            Text(
                ' <a href="https://www.flaticon.com/free-icons/dog" title="dog icons">Dog icons created by Konkapp - Flaticon</a>'),
            //로켓
            Text(
                '<a href="https://www.flaticon.com/kr/free-animated-icons/" title=" 애니메이션 아이콘"> 애니메이션 아이콘 제작자: Freepik - Flaticon</a>'),
            //휴지통
           
            Text(
                '<a href="https://www.flaticon.com/free-icons/garbage" title="garbage animated icons">Garbage animated icons created by Freepik - Flaticon</a>')
          ],
        ),
      ),
    );
  }
}
