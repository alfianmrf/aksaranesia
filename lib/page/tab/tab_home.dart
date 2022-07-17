import 'package:aks/ui/elements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aks/page/list_chat.dart';
import 'package:aks/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:aks/function/get_timeline.dart';
import 'package:aks/page/create_post.dart';
import 'package:readmore/readmore.dart';
import 'package:aks/page/view_writing.dart';

class TabHome extends StatelessWidget {
  final DateTime todaysDate = DateTime.now();

  Widget build(BuildContext context) {
    UserData user = context.watch<UserNotifier>().user;
    return GestureDetector(
        onHorizontalDragEnd: (details) => {
          if (details.primaryVelocity > 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return CreatePost();
            }))
          } else if (details.primaryVelocity < 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ListChat();
            }))
          }
        },

        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent,
                Theme.of(context).scaffoldBackgroundColor,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 0.35),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: HomeData.writingSnapshot(user.classCode),
                    builder: (context, snapshot) {
                      if(snapshot.data == null) {
                        return LinearProgressIndicator(minHeight: 2);
                      } else {
                        var data = snapshot.data.docs;
                        return Container(
                            height: 220,
                            padding: EdgeInsets.all(15),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length + 1,
                              itemBuilder: (context, index) {
                                if(index == 0) {
                                  return Container(
                                    width: 120,
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    margin: EdgeInsets.only(right: 15),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.white,
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  child: InkWell(
                                                    onTap:() {
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (context) {
                                                            return CreatePost();
                                                          }
                                                      ));
                                                    },
                                                    child: Center(
                                                        child: Icon(Icons.add, size: 23, color: primary)
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Buat tulisan kamu',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    margin: EdgeInsets.only(right: 15),
                                    width: 120,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.grey[200],
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.5),
                                                        blurRadius: 2,
                                                        offset: Offset(0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  child: InkWell(
                                                    onTap:() {
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (context) => ViewWriting(id: data[index-1].id)
                                                      ));
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        data[index-1]['title'].length > 30 ? '"' + data[index-1]['title'].substring(0, 30) + '..."' : '"${data[index-1]['title']}"',
                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                                                      ),
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: HomeData.getUserData(data[index-1]['userId']),
                                            builder: (context, users) {
                                              if(users.data == null) {
                                                return Container();
                                              } else {
                                                var user = users.data;
                                                return Text(
                                                  user['displayName'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: primary,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              }
                                            }
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            )
                        );
                      }
                    }
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: HomeData.storySnapshot(user.classCode),
                      builder: (context, story) {
                        if(story.data == null) {
                          return Container();
                        } else {
                          var stories = story.data.docs;
                          if(stories.length <= 0) {
                            return Center(
                              child: Column(
                                children: [
                                  Image.asset('assets/images/empty.png', width: 200),
                                  Text("Wah masih belum ada story nih...")
                                ],
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: stories.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: HomeData.getUserData(stories[index]['userId']),
                                    builder: (context, user) {
                                      if(user.data == null) {
                                        return Container();
                                      } else {
                                        var users = user.data;
                                        DateTime date = stories[index]['created'].toDate();
                                        return Container(
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
                                                  child: users['photoURL'] == '' ?
                                                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                                                      :
                                                  FadeInImage(image: NetworkImage(users['photoURL']), placeholder: AssetImage('assets/images/user.png'))

                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      users['displayName'],
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    ReadMoreText(
                                                      "${stories[index]['text']}",
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
                                                              ImageIcon(
                                                                AssetImage("assets/images/like.png"),
                                                                color: primary.withOpacity(0.5),
                                                                size: 20,
                                                              ),
                                                              SizedBox(width: 15),
                                                              ImageIcon(
                                                                AssetImage("assets/images/comment.png"),
                                                                color: primary.withOpacity(0.5),
                                                                size: 20,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          "${date.day}/${date.month}/${date.year}",
                                                          style: TextStyle(fontSize: 12, color: primary.withOpacity(0.5)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                );
                              },
                            );
                          }
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}