//import 'package:eoyagaja/%20screen/homescreen.txt';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'mainScreen2.dart';

// const users = const {
//   'dribbble@gmail.com': '12345',
//   'hunter@gmail.com': 'hunter',
// };

class LoginScreen extends StatelessWidget {
  String? errorcode;
  //구글 로그인
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

//로그인 함수
  _signin(String id, String paswrd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: id, password: paswrd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorcode = e.code;
        Get.snackbar('로그인 오류', '회원가입이 안된 계정인거같아요');
      } else if (e.code == 'wrong-password') {
        errorcode = e.code;
        Get.snackbar('로그인 오류', '비밀번호를 확인 해주세요');
      }
    }
  }

//회원가입 함수
  _signup(String id, String paswrd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: id, password: paswrd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');

    return Future.delayed(loginTime).then((_) {
      //파베 연동에서 실존하는 아이디 인지 검증하는 알고리즘 탑재

      if (errorcode == 'user-not-found') {
        return '존재하지 않는 아이디에요';
      }
      if (errorcode == 'wrong-password') {
        return '비밀번호가 틀려요';
      }
      if (errorcode == 'weak-password') {
        return '비밀번호가 너무 쉬워요';
      }
      if (errorcode == 'email-already-in-use') {
        return '이미 가입되어 있는 이메일이에요';
      }
      errorcode = '';
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    print('Name: $name');
    FirebaseAuth.instance.sendPasswordResetEmail(email: name);

    return Future.delayed(loginTime).then(
      (_) {
        //파이어베이스에 아이디 조회해서 포함되는지 여부 알고리즘을 넣으면 됨
        // if (FirebaseAuth.instance.currentUser!.emailVerified) {
        //   return null;
        // }
        // if (!users.containsKey(name)) {
        //   return '존재하지 않는 아이디에요';
        // }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      theme: LoginTheme(),
      title: 'EOYA_GAJA',
      //이미지는 꼭 야믈파일에 자산추가 해줘야해, 폰트도 당연하고
      logo: 'assets/images/ahn.png',
      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.com')) {
          return "이메일형식을 확인주세요";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return '비밀번호를 입력하지 않았어요';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        _signin(loginData.name, loginData.password);
        return _authUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        _signup(loginData.name, loginData.password);
        return _authUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        //Get.offNamed(MainScreen.routeName);
        Get.off(MainScreen2());
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => DiaryScreen(),
        //   //builder: (context) => WeatherDisplay(),
        // ));
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      loginProviders: [
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            //여기에다가 구글 로그인 함수 쓰면 될듯?
            signInWithGoogle();
            print('start google sign in');
            await Future.delayed(loginTime);
            print('stop google sign in');
            return '';
          },
        ),
      ],
      messages: LoginMessages(
        userHint: '아이디',
        passwordHint: '패스워드',
        confirmPasswordHint: '패스워드 재입력',
        loginButton: '로그인',
        signupButton: '회원가입',
        forgotPasswordButton: '비밀번호가 기억나지 않나요?',
        recoverPasswordButton: '비밀번호를 메일로 받고싶어요',
        goBackButton: '뒤로 가기',
        confirmPasswordError: '비밀번호가 틀려요',
        recoverPasswordDescription: '리커버패스워드',
        recoverPasswordSuccess: '비밀번호가 성공적으로 복구되었어요',
        flushbarTitleError: '이런!',
        flushbarTitleSuccess: 'Succes!',
      ),
    );
  }
}
