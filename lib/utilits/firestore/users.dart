import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/model/account.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  //ユーザーをfire_storeに登録するインスタンス
static Future<dynamic> setUser(Account newAccount) async{
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
    } on FirebaseException catch(e) {
    print('新規ユーザーの作成エラー: $e');
    return false;
    }
  }
}