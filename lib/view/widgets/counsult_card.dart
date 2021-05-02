

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pet_and_vet/models/consult.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';
import 'package:pet_and_vet/view/screens/login.dart';
import 'package:pet_and_vet/view/widgets/consult_comments.dart';

class ConsultCard extends StatelessWidget {
  final Consult consult;
  final databaseReference = FirebaseDatabase.instance.reference();
  double width;

  ConsultCard({Key key, this.consult}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    width = MediaQuery.of(context).size.width;
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          children: [headerPost(), contentPost(), footerPost(context)],
        ),
      ),
    );
  }


  headerPost() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              color: Colors.grey.shade200,
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/svg/man.svg',
                height: 40,
                width: 40,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(this.consult.userName),
                  Text(TimeAgo.getTimeAgo(this.consult.createdIn,locale: Get.locale.languageCode),textDirection: Get.locale.languageCode=='ar'?TextDirection.rtl:TextDirection.ltr,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  contentPost() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: this.consult.desc == null
                  ? Container()
                  : Text(this.consult.desc),
            )),
        this.consult.img == null||consult.img==''
            ? Container()
            : Row(
          children: [
            Expanded(
                child: Image.network(
                  this.consult.img,
                  height: 200,
                  fit: BoxFit.cover,
                )),
          ],
        ),
        Divider()
      ],
    );
  }

  footerPost(BuildContext ctx) {
    LocalStorage localStorage = LocalStorage();
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LikeButton(
                likeCount: this.consult.userLiker==null?0:this.consult.userLiker.length,
                isLiked:this.consult.userLiker==null?false: this.consult.userLiker?.contains(currentUser.value.id)?true:false,
                onTap:(isLiked) async {
                 if(isLiked){
                   List<String> liker =this.consult.userLiker??[];
                   if(liker.contains(currentUser.value.id)){
                     liker.removeWhere((element) =>liker.contains(currentUser.value.id) );
                   }
                   print('liker ${liker.length}');
                   databaseReference.child('1').child('data').child(this.consult.id.toString()).child('userLiker').set(liker).then((value) {
                     print('Like Done}');
                   });
                   return false;
                 }else{
                   if (await localStorage?.isLogin??false) {
                     List<String> liker =this.consult.userLiker??[];

                      liker.add('${currentUser.value.id}' );
                      List<String> likerUpdate = liker;
                      databaseReference.child('1').child('data').child(this.consult.id.toString()).child('userLiker').set(likerUpdate).then((value){
                        print('Like Done}');
                      });



                     return true;
                   } else {
                     Get.to(Login());
                     return false;
                   }
                 }

                },
              ),
              InkWell(
                onTap: (){
                  showMaterialModalBottomSheet(
                    context: ctx,
                    backgroundColor: Colors.transparent,
                    builder: (context) =>Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ConsultComments(consult: this.consult,),
                    )
                  );
                },
                child: Icon(
                  Icons.comment,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
