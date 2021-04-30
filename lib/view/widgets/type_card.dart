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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              '${widget.product.image}',
              height: 100,
              width: 100,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Text(
                    widget.product.name,
                    textAlign: TextAlign.center,
                  )),
                  Flexible(
                      child: Text(
                    widget.product.desc ?? '',
                    textAlign: TextAlign.center,
                  )),
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
                     if (await localStorage.isLogin) {
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
      ),
    );
  }
}
