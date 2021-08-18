import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_and_vet/constance.dart';
import 'package:get/get.dart';
import 'package:pet_and_vet/models/user.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';
import 'package:pet_and_vet/view/screens/cart_screen.dart';
import 'package:pet_and_vet/view/screens/login.dart';
import 'package:pet_and_vet/view/widgets/drawer.dart';
import 'package:pet_and_vet/view/widgets/home_tab_view.dart';

class HomePage extends StatefulWidget {
  final UserApp user;

  const HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  LocalStorage localStorage;

  @override
  void initState() {
    localStorage = LocalStorage();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            title: Center(
                child: Text(
              'Pet & Vet',
              style: TextStyle(color: Colors.white),
            )),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () async {
                              if (await localStorage?.isLogin??false) {
                                print('asd');
                                Get.to(CartScreen());
                              } else {
                                Get.to(Login());
                              }
                            },
                            child: Icon(
                              Icons.shopping_cart_rounded,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          drawer: Drawer(child: DrawerApp(),),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                color: MyColors().primary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: TabBar(
              indicatorColor: MyColors().primaryDark,
              indicator: BoxDecoration(
                  color: MyColors().primaryDark,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              labelColor: Colors.white,
              tabs: [
                Tab(
                  text: 'cats'.tr,
                ),
                Tab(text: 'dogs'.tr),
                Tab(text: 'birds'.tr),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
                HomeTabView(
                  user: widget.user,
                  tabType: 'cat',
                ),
                HomeTabView(
                  user: widget.user,
                  tabType: 'dog',
                ),
                HomeTabView(
                  user: widget.user,
                  tabType: 'bird',
                ),
              ],
            ),
          ),
        ));
  }
}
