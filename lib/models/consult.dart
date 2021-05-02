// To parse this JSON data, do
//
//     final consult = consultFromJson(jsonString);

import 'dart:convert';

Map<String, Consult> consultFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Consult>(k, Consult.fromJson(v)));

String consultToJson(Map<String, Consult> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Consult {
  Consult({
    this.createdIn,
    this.desc,
    this.id,
    this.img,
    this.like,
    this.section,
    this.userId,
    this.userLiker,
    this.userName,
    this.comments,
  });

  DateTime createdIn;
  String desc;
  int id;
  String img;
  int like;
  String section;
  String userId;
  List<String> userLiker;
  String userName;
  List<Comment> comments;

  factory Consult.fromJson(Map<String, dynamic> json) => Consult(
    createdIn: json["createdIn"] == null ? null : DateTime.parse(json["createdIn"]),
    desc: json["desc"] == null ? null : json["desc"],
    id: json["id"] == null ? null : json["id"],
    img: json["img"] == null ? null : json["img"],
    like: json["like"] == null ? null : json["like"],
    section: json["section"] == null ? null : json["section"],
    userId: json["userId"] == null ? null : json["userId"],
    userLiker: json["userLiker"] == null ? null : List<String>.from(json["userLiker"].map((x) => x)),
    userName: json["userName"] == null ? null : json["userName"],
    comments: json["comments"] == null ? null : List<Comment>.from(json["comments"].map((x) => x == null ? null : Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "createdIn": createdIn == null ? null : createdIn.toIso8601String(),
    "desc": desc == null ? null : desc,
    "id": id == null ? null : id,
    "img": img == null ? null : img,
    "like": like == null ? null : like,
    "section": section == null ? null : section,
    "userId": userId == null ? null : userId,
    "userLiker": userLiker == null ? null : List<dynamic>.from(userLiker.map((x) => x)),
    "userName": userName == null ? null : userName,
    "comments": comments == null ? null : List<dynamic>.from(comments.map((x) => x == null ? null : x.toJson())),
  };
}

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  Comment({
    this.comment,
    this.userId,
  });

  String comment;
  String userId;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    comment: json["comment"] == null ? null : json["comment"],
    userId: json["userId"] == null ? null : json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "comment": comment == null ? null : comment,
    "userId": userId == null ? null : userId,
  };
}
