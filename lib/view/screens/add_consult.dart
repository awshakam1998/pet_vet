import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:pet_and_vet/constance.dart';
import 'package:get/get.dart';
import 'package:pet_and_vet/models/consult.dart';
import 'package:pet_and_vet/models/user.dart';
import 'package:pet_and_vet/utils/local_storage/local_sorage.dart';

class AddConsult extends StatefulWidget {
  final section;
  final UserApp user;

  const AddConsult({Key key, this.section, this.user}) : super(key: key);

  @override
  _AddConsultState createState() => _AddConsultState();
}

class _AddConsultState extends State<AddConsult> {
  String _img;
  bool isLoading = true;
  File _image;
  UserApp user;
  final databaseReference = FirebaseDatabase.instance.reference();
  final descControll = TextEditingController();

  @override
  void initState() {
    print(widget.user.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future getImage(ImageSource imgSource) async {
      // final pickedFile = await picker.getImage(source: imgSource);
      if (imgSource == ImageSource.gallery) {
        List<Media> res = await ImagesPicker.pick(
          count: 1,
          pickType: PickType.image,
          cropOpt: CropOption(
            aspectRatio: CropAspectRatio.wh16x9,
            cropType: CropType.rect, // currently for android
          ),
        );
        String path;
        if (res != null) {
          print(res[0]?.path);
          setState(() {
            path = res[0]?.path;
            _image = File(path);
          });
        }
      } else {
        List<Media> res = await ImagesPicker.openCamera(
          pickType: PickType.image,
          cropOpt: CropOption(
            aspectRatio: CropAspectRatio.wh16x9,
            cropType: CropType.rect, // currently for android
          ),
        );
        String path;
        if (res != null) {
          print(res[0]?.path);
          setState(() {
            path = res[0]?.path;
            _image = File(path);
          });
        }
      }
    }

    Future<String> uploadImage(BuildContext context) async {
      int consultId = DateTime.now().millisecondsSinceEpoch;
      if (_image == null && descControll.text.isEmpty) {
        print('no');
      } else {
        print(consultId);
        if (_image != null) {
          String fileName = basename(_image.path);
          var imageUrl;

          Reference ref = FirebaseStorage.instance
              .ref()
              .child(consultId.toString())
              .child('images');
          UploadTask uploadTask = ref.putFile(_image);

          uploadTask.whenComplete(() async {
            imageUrl = await ref.getDownloadURL();
            Consult consult = Consult(
                id: consultId,
                createdIn: DateTime.now(),
                desc: descControll.text,
                img: imageUrl,
                like: 0,
                section: widget.section,
                userId: widget.user.id,
                userName: widget.user.name);
            print('consult: ${consult.toJson()}');
            databaseReference
                .child('1')
                .child('data')
                .child(consultId.toString())
                .set(consult.toJson())
                .then((value) {
              print('done');
            }).catchError((err) {
              print(err);
            });
            print(imageUrl);
          });
        } else {
          Consult consult = Consult(
              id: consultId,
              createdIn: DateTime.now(),
              desc: descControll.text,
              img: '',
              section: widget.section,
              userId: widget.user.id,
              userName: widget.user.name);
          print('consult: ${consult.toJson()}');
          databaseReference
              .child('1')
              .child('data')
              .child(consultId.toString())
              .set(consult.toJson())
              .then((value) {
            print('done');
          }).catchError((err) {
            print(err);
          });
          // print(imageUrl);

        }
        Get.back();
      }
      // var taskSnapshot =
      // await (await uploadTask.onComplete).ref.getDownloadURL();
      // var _url = taskSnapshot.toString();
      // print(_url);
      // setState(() {
      //   url = _url;
      // });
      return null;
    }

    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                    height: 60,
                    width: 60,
                    color: MyColors().primaryDark,
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Padding(
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
                                Text(widget.user.name),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: TextField(
                        controller: descControll,
                        maxLines: 8,
                        decoration: InputDecoration.collapsed(
                            hintText: "enterYourQuestion".tr),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('photo_from'.tr),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.photo_camera,
                                                    size: 40,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "Camera",
                                                    ),
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                getImage(ImageSource.camera);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(8.0)),
                                            GestureDetector(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 40,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "Gallery",
                                                    ),
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                getImage(ImageSource.gallery);
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ),
                                      ));
                                });
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  color: MyColors().primaryDark,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ))),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('addImg'.tr),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: MyColors().primaryDark,
                            borderRadius: BorderRadius.circular(15)),
                        child: FlatButton(
                            onPressed: () {
                              uploadImage(context);
                            },
                            child: Text(
                              'addConsult'.tr,
                              style: TextStyle(color: Colors.white),
                            ))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
