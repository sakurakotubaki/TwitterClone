import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/model/account.dart';
import 'package:twitter_clone/utilits/authentication.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');

  //ユーザーをfire_storeに登録するインスタンス
  static Future<dynamic> setUser(Account newAccount) async {
    try {
      //newAccountというドキュメントのidを作ることができる
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'selfIntroduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagePath,
        //fire_storeではDATETIME型は扱えないのでTIEMSTAMP型を使う
        'created_time': Timestamp.now(),
        'update_time': Timestamp.now(),
      });
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      print('新規ユーザーの作成エラー: $e');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
        id: uid,
        name: data['name'],
        userId: data['user_id'],
        selfIntroduction: data['selfIntroduction'],
        imagePath: data['image_path'],
        createdTime: data['created_Time'],
        updatedTime: data['updated_Time']
      );
      Authentication.myAccount = myAccount;
      print('ユーザー取得完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー取得エラー');
      return false;
    }
  }
}
