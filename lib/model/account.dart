import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  String imagePath;
  String selfIntroduction;
  String userId;
  //アカウントの定義がTimestampに変わったので修正
  Timestamp? createdTime;
  Timestamp? updatedTime;
  // DateTime? createdTime;
  // DateTime? updatedTime;

  Account({this.id = '', this.name = '', this.imagePath = '',
  this.selfIntroduction = '', this.userId = '', this.createdTime, this.updatedTime
  });
}