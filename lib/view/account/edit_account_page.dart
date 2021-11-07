import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/model/account.dart';
import 'package:twitter_clone/utils/authentication.dart';
import 'package:twitter_clone/utils/firestore/users.dart';
import 'package:twitter_clone/utils/function_utlils.dart';
import 'package:twitter_clone/utils/widget_utils.dart';
import 'package:twitter_clone/view/start_up/login_page.dart';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File? image;

  ImageProvider getImage() {
    if(image == null) {
      return NetworkImage(myAccount.imagePath);
    } else {
      return FileImage(image!);
    }
  }

  @override
  void initState() {
    TextEditingController nameController = TextEditingController(text: myAccount.name);
    TextEditingController userIdController = TextEditingController(text: myAccount.userId);
    TextEditingController selfIntroductionController = TextEditingController(text: myAccount.selfIntroduction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール編集'),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30,),
              GestureDetector(
                onTap: () async {
                  var result = await FunctionUtils.getImageFromGallery();
                  if(result != null) {
                    setState(() {
                      image = File(result.path);
                    });
                  }
                },
                child: CircleAvatar(
                  foregroundImage: getImage(),
                  radius: 40,
                  child: Icon(Icons.add),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: '名前'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: userIdController,
                    decoration: InputDecoration(hintText: 'ユーザーID'),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: selfIntroductionController,
                  decoration: InputDecoration(hintText: '自己紹介'),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    if(nameController.text.isNotEmpty
                        && userIdController.text.isNotEmpty
                        && selfIntroductionController.text.isNotEmpty) {
                      String imagePath = '';
                      if(image == null) {
                        imagePath = myAccount.imagePath;
                      } else {
                        var result = await FunctionUtils.upLoadImage(myAccount.id, image!);
                        imagePath = result;
                      }
                      Account updateAccount = Account(
                        id: myAccount.id,
                        name: nameController.text,
                        userId: userIdController.text,
                        selfIntroduction: selfIntroductionController.text,
                        imagePath: imagePath
                      );
                      Authentication.myAccount = updateAccount;
                      var result = await UserFirestore.updateUser(updateAccount);
                      if(result == true) {
                        // Navigator.popするときに第2引数を渡せる
                        if(result == true) {
                          Navigator.pop(context, true);
                        }
                      }
                    }
                  },
                  child: Text('更新')
              ),
              SizedBox(height: 50),
              // ログアウトボタン
              ElevatedButton(
                  onPressed: () {
                    Authentication.signOut();
                    // ログイン画面に戻る処理
                    while(Navigator.canPop(context)) {
                      // popできる状態ならpopする
                      Navigator.pop(context);
                    }
                    // popできないときの処理(そのときに表示されている画面破棄して処理)
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ));
                  },
                  child: Text('ログアウト')
              ),
              SizedBox(height: 50),
              // アカウント削除ボタン
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red
                ),
                  onPressed: () {
                    UserFirestore.deleteUser(myAccount.id);
                    Authentication.deleteAuth();
                    while(Navigator.canPop(context)) {
                      // popできる状態ならpopする
                      Navigator.pop(context);
                    }
                    // popできないときの処理(そのときに表示されている画面破棄して処理)
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ));
                  },
                  child: Text('アカウント削除')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
