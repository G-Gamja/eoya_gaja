//import 'package:eoyagaja/%20screen/mainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../ screen/firebaselogin/FBloadFail.dart';
import '../ screen/homescreen.dart';

class CheckState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return FBloadFailScreen();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return HomeScreen();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
