import 'package:get/get_state_manager/get_state_manager.dart';
class WalktimeController extends GetxController {
int stepNum = 0;
int upperbound =6;
 void plusStemnum() async {
   if(stepNum<upperbound){
   stepNum++;
   update();
   }
 }
 void setZero() async {
   stepNum = 0;
   update();
 }
}