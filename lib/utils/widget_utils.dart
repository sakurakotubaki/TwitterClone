import 'package:flutter/material.dart';

class WidgetUtils {
  static AppBar createAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: Text('プロフィール編集', style: TextStyle(color: Colors.black),),
      centerTitle: true,
    );
  }
}