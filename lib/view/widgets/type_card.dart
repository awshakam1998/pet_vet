import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pet_and_vet/main.dart';
import 'package:pet_and_vet/models/products.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';
import 'package:pet_and_vet/view/screens/login.dart';

class TypeCard extends StatefulWidget {
  final Product product;
  final bool isCart;

  const TypeCard({Key key, this.product, this.isCart}) : super(key: key);

  @override
  _TypeCardState createState() => _TypeCardState();
}

class _TypeCardState extends State<TypeCard> {
  LocalStorage localStorage;

  @override
  void initState() {
    localStorage = LocalStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: NetworkImage( '${widget.product.image}',),
                      fit: BoxFit.cover,
                    )
                  ),

                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.product.name,
                        textAlign: TextAlign.center,
                      ),
                      Text('${widget.product.price} jd'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () async {
                        if(widget.isCart??false){
                          Fluttertoast.showToast(msg: 'swipeToDEl'.tr);
                        }
                        else{
                          if (await localStorage?.isLogin??false) {
                            bool isExist=false;
                            cartProducts.forEach((element) {
                              if(element.productId==widget.product.productId)
                                isExist=true;
                            });
                            if (isExist) {
                              print('No ');
                            }
                            else{
                              print('yes');
                              Fluttertoast.showToast(msg: 'addSuccess'.tr);
                              cartProducts.add(widget.product);
                            }
                            // else {
                            //
                            // }
                            // print('asd ${products.length}');
                          } else {
                            Get.to(Login());
                          }
                        }
                      },
                      child: widget.isCart??false?Icon(Icons.delete_forever):Icon(Icons.add_shopping_cart)),
                )
              ],
            ),
            widget.isCart??false?Container(): Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                widget.product.desc ?? '',
                textAlign: TextAlign.center,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
