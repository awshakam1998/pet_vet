import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:pet_and_vet/models/consult.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';
import 'package:pet_and_vet/view/screens/login.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final int consulId;
  final int commentId;
  LocalStorage localStorage = LocalStorage();
  final databaseReference = FirebaseDatabase.instance.reference();
   CommentCard({Key key, this.comment, this.consulId, this.commentId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${this.comment.userId}'),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade300
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  '${this.comment.comment}',style: TextStyle(color: Colors.black),),
                            ),
                          ],
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LikeButton(
                        
                        likeCount: this.comment.commentLike==null?0:this.comment.commentLike.length,
                        isLiked:this.comment.commentLike==null?false: this.comment.commentLike?.contains(currentUser.value.id)?true:false,
                        onTap:(isLiked) async {
                          print('CommentsLiker ${this.comment?.commentLike??[]}');
                          if(isLiked){
                            List<String> liker =this.comment?.commentLike??[];
                            if(liker.contains(currentUser.value.id)){
                              liker.removeWhere((element) =>liker.contains(currentUser.value.id) );
                            }
                            print('liker ${liker.length}');
                            databaseReference.child('1').child('data').child(this.consulId.toString()).child('comments').child(this.commentId.toString()).child('commentLike').set(liker).then((value) {
                              print('Like Done}');
                            });
                            return false;
                          }else{
                            if (await localStorage?.isLogin??false) {
                              List<String> liker =this.comment?.commentLike??[];

                              liker.add('${currentUser.value.id}' );
                              List<String> likerUpdate = liker;
                              databaseReference.child('1').child('data').child(this.consulId.toString()).child('comments').child(this.commentId.toString()).child('commentLike').set(likerUpdate).then((value){
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

                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
