import 'dart:ui';

import 'package:aks/function/create_post.dart';
import 'package:aks/function/get_timeline.dart';
import 'package:aks/page/create_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'dart:math' as math;

import '../function/validate_form.dart';
import '../ui/elements.dart';

class CreateComment extends StatefulWidget {
  const CreateComment(this.storyId);

  final String storyId;

  @override
  _CreateCommentState createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final textMessage = TextEditingController();
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambahkan Komentar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: StreamBuilder<DocumentSnapshot>(
          stream: HomeData.storyDetailSnapshot(widget.storyId),
          builder: (context, mystory) {
            if(mystory.data == null) {
              return Container();
            }
            else {
              return StreamBuilder<DocumentSnapshot>(
                stream: HomeData.getUserData(mystory.data['userId']),
                builder: (context, myuser) {
                  if(myuser.data == null) {
                    return Container();
                  }
                  else {
                    DateTime date = mystory.data['created'].toDate();
                    String likes = mystory.data['likes'] != null ? mystory.data['likes'].toString() : '0';
                    String comments = mystory.data['comments'] != null ? mystory.data['comments'].toString() : '0';
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 15),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    child: myuser.data['photoURL'] == '' ?
                                    FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                                        :
                                    FadeInImage(image: NetworkImage(myuser.data['photoURL']), placeholder: AssetImage('assets/images/user.png'))

                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        myuser.data['displayName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      ReadMoreText(
                                        "${mystory.data['text']}",
                                        colorClickableText: Colors.blue.withOpacity(0.7),
                                        trimMode: TrimMode.Line,
                                        trimLines: 3,
                                        trimCollapsedText: "...Lanjutkan Membaca",
                                        trimExpandedText: "\n\nCiutkan",
                                        delimiter: "",
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Row(
                                                  children: [
                                                    // Tombol Like
                                                    Material(
                                                      child: InkWell(
                                                        onTap: () {
                                                          print("Tapped");
                                                          Post.createStoryLike(_auth.currentUser.uid, mystory.data.id, mystory.data['userId']);
                                                        },
                                                        child: ClipRRect(
                                                            child: StreamBuilder<QuerySnapshot>(
                                                              stream: HomeData.storyLikeSnapshot(_auth.currentUser.uid, mystory.data.id),
                                                              builder: (context, snapshot) {
                                                                if(snapshot.connectionState == ConnectionState.waiting) {
                                                                  return Container(
                                                                      height: 20.0,
                                                                      width: 20.0,
                                                                      child: Center(
                                                                        child: SizedBox(
                                                                          child: CircularProgressIndicator(),
                                                                          height: 10.0,
                                                                          width: 10.0,
                                                                        ),
                                                                      )
                                                                  );
                                                                }
                                                                else {
                                                                  if(snapshot.data.docs.length > 0) {
                                                                    return Icon(
                                                                      // Icons.favorite,
                                                                      Icons.thumb_up,
                                                                      // color: Colors.red,
                                                                      color: Color(0xFFF9AD23),
                                                                    );
                                                                  } else {
                                                                    return Icon(
                                                                      // Icons.favorite_border,
                                                                      Icons.thumb_up_alt_outlined,
                                                                      color: Color(0xFF96A7C1),
                                                                    );
                                                                  }
                                                                }
                                                              },
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      likes,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color(0xFF96A7C1),
                                                      ),
                                                    ),
                                                    SizedBox(width: 15),
                                                    // Tombol Comment
                                                    Material(
                                                      child: InkWell(
                                                        child: ClipRRect(
                                                            child: Icon(
                                                              Icons.comment,
                                                              color: Color(0xFF96A7C1),
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      comments,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: primary.withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ]
                                              )
                                          ),
                                          Text(
                                            "${date.day}/${date.month}/${date.year}",
                                            style: TextStyle(fontSize: 12, color: primary.withOpacity(0.5)),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                        ),
                                        // color: Theme.of(context).appBarTheme.backgroundColor,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: InputChanged(
                                                  controller: textMessage,
                                                  hintText:"Tuliskan komentar",
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
                                                      onPressed: () {
                                                        if(trim(textMessage.text) != "") {
                                                          if(_auth.currentUser.uid == mystory.data['userId']) {
                                                            Post.createStoryComment(
                                                              _auth.currentUser.uid,
                                                              mystory.data.id,
                                                              mystory.data['userId'],
                                                              textMessage.text, isMySelf: true);
                                                              textMessage.text = "";
                                                          } else {
                                                            Post.createStoryComment(
                                                              _auth.currentUser.uid,
                                                              mystory.data.id,
                                                              mystory.data['userId'],
                                                              textMessage.text);
                                                          textMessage.text = "";
                                                          }
                                                        }
                                                      },
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
                                      ), // Container Input Comment
                                    ],
                                  ),
                                )
                              ]
                          ),
                        ), // Container Story
                        StreamBuilder<QuerySnapshot>(
                          stream: HomeData.storyCommentsSnapshot(mystory.data.id),
                          builder: (context, mycomments) {
                            if(mycomments.connectionState == ConnectionState.waiting) {
                              return Container(
                                  height: 20.0,
                                  width: 20.0,
                                  child: Center(
                                    child: SizedBox(
                                      child: CircularProgressIndicator(),
                                      height: 10.0,
                                      width: 10.0,
                                    ),
                                  )
                              );
                            }
                            else {
                              if (mycomments.data == null) {
                                return Container();
                              }
                              else {
                                var comments = mycomments.data.docs;
                                if (comments.length <= 0) {
                                  return Container();
                                }
                                else {
                                  return Container(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: mystory.data['comments'],
                                        physics: ScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return StreamBuilder<
                                              DocumentSnapshot>(
                                              stream: HomeData.getUserData(
                                                  comments[index]['userId']),
                                              builder: (context, user) {
                                                if (user.data == null) {
                                                  return Container();
                                                }
                                                else {
                                                  DateTime date = comments[index]['created']
                                                      .toDate();
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                    ),
                                                    padding: EdgeInsets.all(12),
                                                    margin: EdgeInsets.only(
                                                        bottom: 15,
                                                        left: 15,
                                                        right: 10
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Container(
                                                            width: 40,
                                                            height: 40,
                                                            child: user
                                                                .data['photoURL'] ==
                                                                '' ?
                                                            FadeInImage(
                                                                image: AssetImage(
                                                                    'assets/images/user.png'),
                                                                placeholder: AssetImage(
                                                                    'assets/images/user.png'))
                                                                :
                                                            FadeInImage(
                                                                image: NetworkImage(
                                                                    user
                                                                        .data['photoURL']),
                                                                placeholder: AssetImage(
                                                                    'assets/images/user.png'))
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  user
                                                                      .data['displayName'],
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                ReadMoreText(
                                                                  "${comments[index]['text']}",
                                                                  colorClickableText: Colors
                                                                      .blue
                                                                      .withOpacity(
                                                                      0.7),
                                                                  trimMode: TrimMode
                                                                      .Line,
                                                                  trimLines: 3,
                                                                  trimCollapsedText: "...Lanjutkan Membaca",
                                                                  trimExpandedText: "\n\nCiutkan",
                                                                  delimiter: "",
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Align(
                                                                  alignment: Alignment
                                                                      .bottomRight,
                                                                  child: Text(
                                                                    "${date
                                                                        .day}/${date
                                                                        .month}/${date
                                                                        .year}",
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: primary
                                                                            .withOpacity(
                                                                            0.5)),
                                                                    textAlign: TextAlign
                                                                        .right,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                          );
                                        },
                                      )
                                  );
                                }
                              }
                            }
                          },
                        )
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      )
    );
  }
}
