import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aks/function/get_message.dart';
import 'package:aks/ui/elements.dart';
import 'package:aks/function/validate_form.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class ChatPage extends StatefulWidget {
  ChatPage(this.userId, this.photoURL, this.displayName);
  final String userId, photoURL, displayName;
  @override
  _ChatPage createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final textMessage = TextEditingController();
  String messageId;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    getMessageId();
  }

  void getMessageId() {
    Message.retrieveMessageId(widget.userId, _auth.currentUser.uid).then((value) {
      setState(() {
        messageId = value;
      });
    });
  }

  @override
  void dispose() {
    textMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 15,
              child: ClipOval(
                child: widget.photoURL == "" ? 
                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                :
                  FadeInImage(image: NetworkImage(widget.photoURL), placeholder: AssetImage('assets/images/user.png')),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.displayName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primary),
                ),
              ]
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: Message.getMessageData(messageId),
            builder: (context, chat) {
              if(chat.data == null) {
                return Expanded(
                  child: Column(
                    children: [
                      LinearProgressIndicator(minHeight: 2),
                      Expanded(
                        child: Container()
                      )
                    ],
                  ),
                );
              } else {
                var chatData = chat.data.docs;
                if(chatData.length <= 0) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/empty.png", width: 200),
                          Text("Wah belum ada pesan nih...")
                        ]
                      )
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(20),
                      reverse: true,
                      itemCount: chatData.length,
                      itemBuilder: (context, index) {
                        if(chatData[index]["sender"] == _auth.currentUser.uid) {
                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(child: SizedBox()),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    DateFormat('HH.mm').format(chatData[index]["timestamp"].toDate()),
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: accent,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(chatData[index]["message"], style: TextStyle(color: Colors.black)),
                                ),
                                Container(
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(left: 10),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 15,
                                    child: ClipOval(
                                      child: _auth.currentUser.photoURL == null ?
                                      FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                                          :
                                      FadeInImage(image: NetworkImage(_auth.currentUser.photoURL), placeholder: AssetImage('assets/images/user.png')),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 15,
                                    child: ClipOval(
                                      child: widget.photoURL == "" ?
                                      FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                                          :
                                      FadeInImage(image: NetworkImage(widget.photoURL), placeholder: AssetImage('assets/images/user.png')),
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[300],
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(chatData[index]["message"]),
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    DateFormat('HH.mm').format(chatData[index]["timestamp"].toDate()),
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  );
                }
              }
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InputChanged(
                    controller: textMessage,
                    hintText:"Ketikkan pesan anda ...",
                    changed: (value) {
                      if(trim(value) == "") {
                        setState(() {
                          isEnabled = false;
                        });
                      } else {
                        setState(() {
                          isEnabled = true;
                        });
                      }
                    },
                    suffixIcon: Container(
                      margin: EdgeInsets.fromLTRB(0, 2, 5, 2),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(3),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          minimumSize: MaterialStateProperty.all(Size.zero),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: MaterialStateProperty.all<CircleBorder>(
                            CircleBorder(
                              side: BorderSide.none,
                            ),
                          ),
                        ),
                        onPressed: isEnabled ? () {
                          Message.send(textMessage.value.text, widget.userId, _auth.currentUser.uid, messageId);
                          textMessage.text = "";
                          setState(() {
                            isEnabled = false;
                          });
                        } : null,
                        child: Transform.rotate(
                          angle: -45 * math.pi / 180,
                          child: Icon(Icons.send, color: primary),
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ]
      )
    );
  }
}