import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pet_and_vet/constance.dart';
import 'package:pet_and_vet/models/user.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';
import 'package:pet_and_vet/view/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _paddingLift = 0;
  double _paddingRight = 0;
  String _now;
  Timer _everySecond;
  LocalStorage localStorage=LocalStorage();
  @override
  void initState() {
    super.initState();
print('asdfgh');
    // sets first value
    _now = DateTime.now().microsecond.toString();

    // defines a timer
    _everySecond = Timer.periodic(Duration(milliseconds: 10), (Timer t)async {
      if (_paddingLift < MediaQuery.of(context).size.width * .25) {
        setState(() {
          _paddingLift++;
          _paddingRight++;
        });
      } else {
        t.cancel();
        UserApp aa=await localStorage.user;
        print('user: ${aa.name}');
        Navigator.pop(context);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(aa),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _paddingLift,
                ),
                child: Image.asset(
                  'assets/images/logo_image.png',
                  width: (MediaQuery.of(context).size.width * .5) -15,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _paddingRight),
                child: Image.asset(
                  'assets/images/logo_name.JPG',
                  width: (MediaQuery.of(context).size.width *.5)-15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
