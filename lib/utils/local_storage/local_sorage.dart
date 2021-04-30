import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pet_and_vet/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
SharedPreferences prefs;
  ///Write on Disk
  void saveLanguageToDisk(String language) async {
    prefs =await SharedPreferences.getInstance();
    prefs.setString('lang', language);
    await GetStorage().write('lang', language);
  }

  void saveUser(UserApp user) async {
    prefs =await SharedPreferences.getInstance();
    await prefs.setString('username', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('id', user.id);
    await prefs.commit();
  }

 void setLogin(bool isLogin) async {
   prefs =await SharedPreferences.getInstance();
   await prefs.setBool('isLogin', isLogin);
   await prefs.commit();
   await GetStorage().write('isLogin', isLogin);
  }

void setFirstOpen(bool firstOpen) async {
    await GetStorage().write('isFirst', firstOpen);
  }

  ///Read from Disk
  Future<String> get languageSelected async {
    prefs =await SharedPreferences.getInstance();

    return prefs.getString('lang');
  }

  Future<UserApp> get user async {
    prefs =await SharedPreferences.getInstance();
    String username= prefs.getString('username');
    String email= prefs.getString('email');
    String id= prefs.getString('id');
    print('fghj : $username');
    return UserApp(email:email,name:username,id:id);
  }

  Future<bool> get isLogin async {
    prefs =await SharedPreferences.getInstance();
    bool isLogin= prefs.getBool('isLogin');
    print('isLogin? $isLogin');
    return isLogin;
  }

  Future<bool> get isFirstOpen async {
    return await GetStorage().read('isFirst');
  }


}
