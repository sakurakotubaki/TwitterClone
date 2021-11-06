import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/model/account.dart';
import 'package:twitter_clone/model/post.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  Account myAccount = Account(
    id: '1',
    name: 'Flutterラボ',
    selfIntroduction: 'こんにちは',
    userId: 'flutter_labo',
    imagePath: 'https://yt3.ggpht.com/ngVd2-zv5o3pGUCfiVdZXCHhnq_g1Lo1Y8DbrmB9O8G7DG0IWUQJgsacqsI_LRvZE8JTsbQIuQ=s900-c-k-c0x00ffffff-no-rj',
    // createdTime: DateTime.now(),
    // updatedTime: DateTime.now()
    // エラーでたのでTimestamp.now(),に修正
      createdTime: Timestamp.now(),
      updatedTime: Timestamp.now()
  );

  List<Post> postList = [
    Post(
      id: '1',
      content: '初めまして',
      postActionId: '1',
      createdTime: DateTime.now()
    ),
    Post(
        id: '2',
        content: '初めまして２かい',
        postActionId: '1',
        createdTime: DateTime.now()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('タイムライン', style: TextStyle(color: Colors.black)),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 1,
      ),
      body: ListView.builder(
          itemCount: postList.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: index == 0 ? Border(
                  top: BorderSide(color: Colors.grey, width: 0),
                ) : Border(bottom: BorderSide(color: Colors.grey, width: 0),),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    foregroundImage: NetworkImage(myAccount.imagePath),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(myAccount.name, style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('@${myAccount.userId}', style: TextStyle(color: Colors.grey),),
                                ],
                              ),
                              Text(DateFormat('M/d/yy').format(postList[index].createdTime!)),
                            ],
                          ),
                          Text(postList[index].content)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
      ),
    );
  }
}
