import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pet_and_vet/constance.dart';
import 'package:pet_and_vet/models/products.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';
import 'package:pet_and_vet/utils/translator/translation.dart';
import 'package:pet_and_vet/view/screens/login.dart';
import 'package:pet_and_vet/view/screens/splash_screen.dart';
String lang = 'ar';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalStorage localStorage =LocalStorage();
  currentUser.value= await localStorage.user;
  String language = await localStorage.languageSelected ?? 'ar';
  print(language);
  lang = language;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.updateLocale(Locale(language));
  print('User ${currentUser.value.name}');
  runApp(MyApp());
}

List<Product> cartProducts = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Translation(),
      locale: Locale(lang),
      fallbackLocale: Locale('ar'),
      title: 'Pet & Vet',
      theme: ThemeData(
        primaryColor: MyColors().primary,
        primaryColorDark: MyColors().primaryDark,
        // primarySwatch: MyColors().primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
