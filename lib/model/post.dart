import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String content;
  String postAccountId;
  // DateTime? createdTime;
  // Timestanp方に変更
  Timestamp? createdTime;
  Post({this.id = '', this.content = '', this.postAccountId = '', this.createdTime});
}