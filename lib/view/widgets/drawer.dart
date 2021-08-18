import 'package:flutter/material.dart';
import 'package:pet_and_vet/constance.dart';
import 'package:pet_and_vet/models/user.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';
import 'package:pet_and_vet/view/screens/cart_screen.dart';
import 'package:pet_and_vet/view/screens/home_page.dart';
import 'package:pet_and_vet/view/screens/login.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerApp extends StatefulWidget {
  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [

          Container(
            color: MyColors().primaryDark.withOpacity(.3),
            child: Column(
              children: [
                SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.cover)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${currentUser.value.name ?? "guest".tr}',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home, color: MyColors().primaryDark),
                  title: Text('home'.tr),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                currentUser.value.id != null
                    ? ListTile(
                  leading: Icon(Icons.shopping_cart,
                      color: MyColors().primaryDark),
                  title: Text('myCartDrawer'.tr),
                  // trailing: Text('New',
                  //     style: TextStyle(color: Theme.of(context).primaryColor)),
                  onTap: () {
                    Get.back();
                    Get.to(CartScreen());
                  },
                )
                    : Container(),
                Divider(),
                ListTile(
                  leading:
                  Icon(Icons.translate, color: MyColors().primaryDark),
                  title: Text('lang'.tr),
                  onTap: () {
                    showDialog(
                      context:this.context,
                      builder: (ctx) => AlertDialog(
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: SvgPicture.asset('assets/svg/ar.svg',width: 35,height: 35,),
                                title: Text('العربية'),
                                onTap: () {
                                  LocalStorage().saveLanguageToDisk('ar');
                                  Get.updateLocale(Locale('ar'));
                                  Get.off(HomePage(currentUser.value));
                                },
                              ),
                              ListTile(
                                leading: SvgPicture.asset('assets/svg/en.svg',width: 35,height: 35,),
                                title: Text('English'),
                                onTap: () {
                                  LocalStorage().saveLanguageToDisk('en');
                                  Get.updateLocale(Locale('en'));
                                  Get.off(HomePage(currentUser.value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),


                currentUser.value.id != null
                    ? ListTile(

                  leading:
                  Icon(Icons.logout, color: MyColors().primaryDark),
                  title: Text('logoutDrawer'.tr),
                  onTap: () {
                    setState(() {
                      LocalStorage().setLogin(false);
                      LocalStorage().saveUser(UserApp());
                      currentUser.value=UserApp();
                     Get.back();
                    });
                  },
                )
                    : ListTile(
                  leading:
                  Icon(Icons.login, color: MyColors().primaryDark),
                  title: Text('login'.tr),
                  onTap: () {
                    setState(() {
                       Get.off(Login());
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
