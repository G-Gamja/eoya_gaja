import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'mainScreen2.dart';
import 'splashscreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (!snapshot.hasData) {
            //원래 구현ㅆㅓ거

            return LoginScreen();
          } else {
            return MainScreen2();
            //snapshot.data!.displayName
          }
        },
      ),
    );
  }
}
