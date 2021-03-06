import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pet_and_vet/constance.dart';
import 'package:pet_and_vet/models/user.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';
import 'package:pet_and_vet/view/screens/home_page.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

ValueNotifier<UserApp> currentUser = ValueNotifier(UserApp());

class Login extends StatefulWidget {
  bool isError = false;

  Login({this.isError});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String state = 'no';
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (widget.isError ?? false) {
        Get.snackbar('Login Failed', "Email or Password is incorrect",
            duration: Duration(seconds: 2),
            backgroundColor: Colors.white.withOpacity(.5));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors().primary,
        body: FlutterLogin(
          title: 'Pet & Vet',
          logo: 'assets/svg/loginPng.png',
          onLogin: (_) => login(_),
          onSignup: (_) => register(_),
          onSubmitAnimationCompleted: () async {
            if (state == 'yes') {
              Get.off(HomePage(currentUser.value));
            } else if (state == 'emailValidation') {
              openEmailValidation();
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login(
                            isError: true,
                          )),
                  (route) => false);
            }
          },
          onRecoverPassword: (_) => Future(null),
        ));
  }

  Future<String> login(LoginData user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.name, password: user.password);
      String username = user.name.substring(0, user.name.indexOf('@'));
      User user1 = FirebaseAuth.instance.currentUser;

      if (!user1.emailVerified) {
        state = 'emailValidation';
        await user1.sendEmailVerification();
        print('dvsndvjnj xmn ');
      } else {
        LocalStorage localStorage = LocalStorage();
        UserApp userApp = UserApp(
            name: username,
            email: userCredential.user.email,
            id: userCredential.user.uid);
        currentUser.value = userApp;
        localStorage.saveUser(userApp);
        localStorage.setLogin(true);
        UserApp aa = await localStorage.user;
        print('user: ${aa.name}');
        state = 'yes';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  sendRegistrationNotification(String email) async {}

  Future<String> openEmailValidation() async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('emailVerify'.tr),
              RaisedButton(
                onPressed: () {
                  Get.back();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(
                                isError: false,
                              )),
                      (route) => false);
                },
                child: Text('verify'.tr),
              )
            ],
          ),
        ),
      ),
    );
    return state;
  }

  Future<String> register(LoginData user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.name, password: user.password);
      String username = userCredential.user.email
          .substring(0, userCredential.user.email.indexOf('@'));
      print(username);
      User user1 = FirebaseAuth.instance.currentUser;

      if (!user1.emailVerified) {
        state = 'emailValidation';
        await user1.sendEmailVerification();
        print('dvsndvjnj xmn ');
      } else {
        LocalStorage localStorage = LocalStorage();
        UserApp userApp = UserApp(
            name: username,
            email: userCredential.user.email,
            id: userCredential.user.uid);
        currentUser.value = userApp;
        localStorage.saveUser(userApp);
        localStorage.setLogin(true);
        UserApp aa = await localStorage.user;
        print('user: ${aa.name}');

        databaseReference.child('users').child(userCredential.user.uid).set({
          'uid': userCredential.user.uid,
          'email': userCredential.user.email,
          'name': username,
        }).whenComplete(() async {
          state = 'yes';
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
