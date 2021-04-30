import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pet_and_vet/constance.dart';
import 'package:pet_and_vet/models/consult.dart';
import 'package:pet_and_vet/models/user.dart';
import 'package:pet_and_vet/view/screens/add_consult.dart';
import 'package:pet_and_vet/view/widgets/counsult_card.dart';

class ConsultingScreen extends StatefulWidget {
  final String type;
  final String section;
  final UserApp user;

  const ConsultingScreen({Key key, this.type, this.section, this.user})
      : super(key: key);

  @override
  _ConsultingScreenState createState() => _ConsultingScreenState();
}

class _ConsultingScreenState extends State<ConsultingScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Consult> consults = [];

  @override
  void initState() {
    getConsultsList();
  }

  getConsultsList() async {
    databaseReference.child('1').child('data').onValue.listen((event) {
      consults.clear();
      print(jsonEncode(event.snapshot.value));
      var snapshot = jsonEncode(Map.from(event.snapshot.value));
      print(snapshot);
      Map<String,Consult> consultsList=consultFromJson(snapshot);
      consultsList.forEach((key,cons) {

       if(mounted){

         setState(() {
           Consult consult = cons;
           if (consult.section == widget.section)
             consults.add(consult);
           print(widget.section);
           print(consult.section);
         });
       }
      });
      consults.sort((a, b) => b.id.compareTo(a.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          consults.length==0?Center(
            child: SvgPicture.asset(
        'assets/svg/sadcat.svg',
        height: 100,
        width: 100,),
          )
              :ListView.builder(
            shrinkWrap: true,
            itemCount: consults.length,
            itemBuilder: (context, index) =>
                ConsultCard(consult: consults[index]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                      height: 60,
                      width: 60,
                      color: MyColors().primaryDark,
                      alignment: Alignment.center,
                      child: FlatButton(
                        onPressed: () {
                          showMaterialModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AddConsult(
                              section: widget.section,
                              user: widget.user,
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
