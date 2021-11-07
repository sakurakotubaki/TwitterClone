import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/model/account.dart';
import 'package:twitter_clone/utils/authentication.dart';

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
        createdTime: data['created_time'],
        updatedTime: data['updated_time']
      );
      Authentication.myAccount = myAccount;
      print('ユーザー取得完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー取得エラー:$e');
      return false;
    }
  }

  // アカウントを更新するメソッド
  static Future<dynamic> updateUser(Account updateAccount) async {
    try {
    await users.doc(updateAccount.id).update({
      'name': updateAccount.name,
      'image_path': updateAccount.imagePath,
      'user_id': updateAccount.userId,
      'selfIntroduction': updateAccount.selfIntroduction,
      'update_time': Timestamp.now()
    });
      print('ユーザー情報の登録完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー情報の登録エラー:$e');
      return false;
    }
  }

  static Future<Map<String, Account>?> getPostUserMap(List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (String accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          userId: data['user_id'],
          imagePath: data['image_path'],
          selfIntroduction: data['selfIntroduction'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time']
        );
        map[accountId] = postAccount;
      });
      print('投稿ユーザーの情報取得完了');
      return map;
    } on FirebaseException catch(e) {
      print('投稿ユーザーの情報取得エラー:$e');
      return null;
    }
  }
}
