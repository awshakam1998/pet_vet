import 'package:flutter/material.dart';
import 'package:pet_and_vet/main.dart';
import 'package:get/get.dart';
import 'package:pet_and_vet/view/widgets/type_card.dart';
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double subtotal = 0.0;
  double shipping = 2.0;
  double tax = 0.0;
  double total = 0.0;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    setState(() {
      for (int i = 0; i < cartProducts.length; i++) {
        subtotal += double.parse(cartProducts[i].price);
      }
      total = subtotal + shipping + tax;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(

          title: Text('myCartDrawer'.tr,style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: cartProducts.isNotEmpty
            ? Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Container(
                  child: Text(
                      cartProducts.length.toString() +
                          '\t' +'itemCountinCart'.tr,
                      // textDirection: langCode == 'ar'
                      //     ? TextDirection.rtl
                      //     : TextDirection.rtl,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(UniqueKey().toString()),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        setState(() {
                          subtotal=0;
                          total=0;
                          cartProducts.removeAt(index);
                          for (int i = 0; i < cartProducts.length; i++) {
                            subtotal += double.parse(cartProducts[i].price);
                          }
                          total = subtotal + shipping + tax;
                        });

                      },
                      // Show a red background as the item is swiped away.
                      background: Container(
                        decoration: BoxDecoration(color: Colors.red),
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child:
                              Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      secondaryBackground: Container(
                        decoration: BoxDecoration(color: Colors.red),
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child:
                              Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      child: TypeCard(product: cartProducts[index],isCart:true),
                    );
                  }),
            ),
            Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // textDirection: langCode == 'ar'
                          //     ? TextDirection.rtl
                          //     : TextDirection.rtl,
                          children: <Widget>[
                            Expanded(
                                child: Text('subTotal'.tr,
                                    // textDirection: langCode == 'ar'
                                    //     ? TextDirection.rtl
                                    //     : TextDirection.rtl,
                                    style: TextStyle(fontSize: 14))),
                            Text(" $subtotal ",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            Text('jd'.tr,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // textDirection: langCode == 'ar'
                          //     ? TextDirection.rtl
                          //     : TextDirection.rtl,
                          children: <Widget>[
                            Expanded(
                              child: Text('shipping'.tr,
                                  // textDirection: langCode == 'ar'
                                  //     ? TextDirection.rtl
                                  //     : TextDirection.rtl,
                                  style: TextStyle(fontSize: 14)),
                            ),
                            Text(" $shipping ",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            Text('jd'.tr,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          // textDirection: langCode == 'ar'
                          //     ? TextDirection.rtl
                          //     : TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text('tax'.tr,
                                    // textDirection: langCode == 'ar'
                                    //     ? TextDirection.rtl
                                    //     : TextDirection.rtl,
                                    style: TextStyle(fontSize: 14))),
                            Text(" $tax ",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            Text(
                                'jd'.tr,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // textDirection: langCode == 'ar'
                          //     ? TextDirection.rtl
                          //     : TextDirection.rtl,
                          children: <Widget>[
                            Expanded(
                                child: Text('total'.tr,
                                  // textDirection: langCode == 'ar'
                                  //     ? TextDirection.rtl
                                  //     : TextDirection.rtl,
                                  style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                                )),
                            Text(" $total ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                'jd'.tr,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 50, bottom: 10),
              child: ButtonTheme(
                buttonColor: Theme.of(context).primaryColor,
                minWidth: double.infinity,
                height: 40.0,
                child: RaisedButton(
                  onPressed: () {
                    // print(products.length);
                    // if (products.length > 0) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => PersonInfoScreen(city: _mySelection,)));
                    // } else {
                    //   Fluttertoast.showToast(
                    //       msg: LocaleLanguages(Locale(langCode))
                    //           .getStrings['yourCartEmpty'],
                    //       toastLength: Toast.LENGTH_SHORT,
                    //       gravity: ToastGravity.BOTTOM,
                    //       timeInSecForIosWeb: 1,
                    //       backgroundColor: Colors.grey,
                    //       textColor: Colors.white,
                    //       fontSize: 16.0);
                    // }
                  },
                  child: Text(
                    "checkout".tr,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/cartEmpty.png',
                        width: 100,
                        height:100,
                      ),
                      Text('yourCartEmpty'.tr),
                    ],
                  ),
                ))
          ],
        ));
  }
}
