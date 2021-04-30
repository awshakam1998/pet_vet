import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pet_and_vet/constance.dart';
import 'package:pet_and_vet/models/consult.dart';
import 'package:pet_and_vet/view/screens/login.dart';
import 'package:pet_and_vet/view/widgets/cooment_card.dart';

class ConsultComments extends StatefulWidget {
  final Consult consult;

  const ConsultComments({Key key, this.consult}) : super(key: key);

  @override
  _ConsultCommentsState createState() => _ConsultCommentsState();
}

class _ConsultCommentsState extends State<ConsultComments> {
  final databaseReference = FirebaseDatabase.instance.reference();
  TextEditingController commentText = TextEditingController();
  List<Comment> commentPost = List<Comment>();

  @override
  void initState() {
    getComment();
  }

  getComment() {
    databaseReference
        .child('1')
        .child('data')
        .child(widget.consult.id.toString())
        .child('comments')
        .onValue
        .listen((value) {
      print('snapshot${value.snapshot.value}');
      if (value.snapshot.value != null) {
        var snapshot = jsonEncode(List.from(value.snapshot.value));
        print(snapshot);
        List<Comment> comm = commentFromJson(snapshot);
        setState(() {
          commentPost = comm ?? List<Comment>();
        });
        print('Like Done} ${comm[0].comment}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * .9,
      width: bottom,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(top: 15, bottom: bottom.toDouble() + 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: 1,
                      controller: commentText,
                      decoration: InputDecoration(
                        alignLabelWithHint: false,
                        labelText: 'comment'.tr,
                        hintText: 'addComment'.tr,
                        labelStyle: Theme.of(context).textTheme.headline6,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {
                    addComment();
                  },
                  child: Icon(
                    Icons.send,
                    size: 35,
                    color: MyColors().primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child:commentPost.isEmpty? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/sadcat.svg',
                        height: 100,
                        width: 100,
                      ),
                      Text('noComment'.tr)
                    ],
                  ),
                ) : ListView.builder(
              itemCount: commentPost.length,
              itemBuilder: (context, index) => CommentCard(
                comment: commentPost[index],
              ),
              shrinkWrap: true,
            )),
          ],
        ),
      ),
    );
  }

  void addComment() {
    if (commentText.text.isNotEmpty) {
      List<Comment> comments = widget.consult?.comments ?? List<Comment>();
      comments.add(
          Comment(userId: currentUser.value.name, comment: commentText.text));

      List<dynamic> comm = List<dynamic>.from(comments.map((x) => x.toJson()));
      print('Ok $comm');
      databaseReference
          .child('1')
          .child('data')
          .child(widget.consult.id.toString())
          .child('comments')
          .set(comm)
          .then((value) {
        print('Ok');
        commentText.clear();
      });
    }
  }
}
