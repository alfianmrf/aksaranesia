import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aks/function/get_message.dart';
import 'package:aks/function/get_timeline.dart';
import 'package:aks/page/chat_page.dart';

class ListChat extends StatefulWidget {
  @override
  _ListChat createState() => _ListChat();
}

class _ListChat extends State<ListChat> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Pesan", style: TextStyle(fontSize: 18)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Message.getListChat(_auth.currentUser.uid),
              builder: (context, listChat) {
                if(listChat.data == null) {
                  return Column(
                    children: [
                      LinearProgressIndicator(minHeight: 2),
                      Expanded(
                        child: Container()
                      )
                    ],
                  );
                } else {
                  var listChats = listChat.data.docs;
                  return ListView.separated(
                    separatorBuilder: (context, index) => Container(height: 1, color: Theme.of(context).cardColor),
                    itemCount: listChats.length,
                    itemBuilder: (context, index) {
                      String opponentId = Message.getOpponentId(listChats[index]["users"], _auth.currentUser.uid);
                      return StreamBuilder<DocumentSnapshot>(
                        stream: HomeData.getUserData(opponentId),
                        builder: (context, user) {
                          if(user.data == null) {
                            return SizedBox();
                          } else {
                            var users = user.data;
                            return StreamBuilder<QuerySnapshot>(
                              stream: Message.getLastMessage(listChats[index].id),
                              builder: (context, lastMessage) {
                                if(lastMessage.data == null) {
                                  return SizedBox();
                                } else {
                                  var lastMessages = lastMessage.data.docs;
                                  Timestamp time = lastMessages[0]["timestamp"];
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) {
                                          return ChatPage(users.id, users['photoURL'], users['displayName']);
                                        }
                                      ));
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 25,
                                      child: ClipOval(
                                        child: users["photoURL"] == "" ? 
                                          FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                                        :
                                          FadeInImage(image: NetworkImage(users["photoURL"]), placeholder: AssetImage('assets/images/user.png')),
                                      ),
                                    ),
                                    title: Text(users['displayName']),
                                    subtitle: Text(lastMessages[0]['message'], maxLines: 1),
                                    trailing: Text("${time.toDate().hour}:${time.toDate().minute}"),
                                  );
                                }
                              },
                            );
                          }
                        },
                      );
                    }
                  );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}