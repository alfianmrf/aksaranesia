import 'package:aks/function/get_timeline.dart';
import 'package:aks/page/create_post.dart';
import 'package:aks/ui/elements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aks/page/list_chat.dart';
import 'package:aks/function/get_userdata.dart';
import 'package:aks/model/user_model.dart';
import 'package:aks/page/tab/tab_home.dart';
import 'package:aks/page/tab/tab_search.dart';
import 'package:aks/page/tab/tab_borrow.dart';
import 'package:aks/page/tab/tab_class.dart';
import 'package:aks/page/tab/tab_profile.dart';
import 'package:aks/page/settings.dart';

class Notification extends StatefulWidget {
  @override
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<Notification> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
      appBar: AppBar(
          title: Text("Pemberitahuan",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge.color))
      ),

      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: StreamBuilder<QuerySnapshot>(
          stream: HomeData.storyNotificationSnapshot(_auth.currentUser.uid),
          builder: (context, notification){
            if(notification.data == null){
              return Container();
            } else {
              var notifications = notification.data.docs;
              if(notifications.length <= 0){
                return Container();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return StreamBuilder<DocumentSnapshot>(
                      stream: HomeData.getUserData(notifications[index]['userId']),
                      builder: (context, user){
                        if(user.data == null){
                          return Container();
                        } else {
                          var userData = user.data;
                          DateTime date = notifications[index]['created'].toDate();
                            return Container(
                              decoration: BoxDecoration(
                                            color: notifications[index]['read'] ?
                                            Colors.white : Color.fromARGB(255, 190, 223, 251),
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
                                    child: userData['photoURL'] == '' ?
                                      FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
                                          :
                                      FadeInImage(image: NetworkImage(userData['photoURL']), placeholder: AssetImage('assets/images/user.png'))
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(userData['displayName'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                        SizedBox(height: 5,),
                                        Text(notifications[index]['text'], style: TextStyle(fontSize: 14, color: Colors.grey),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    "${date.day}/${date.month}/${date.year}",
                                    style: TextStyle(fontSize: 12, color: primary.withOpacity(0.5)),
                                  ),
                                ]
                              ),
                            );
                        }
                      },
                    );
                  }
                );
              }
            }
          },
        )
      ),
    ), 
      onWillPop:()=> _willPopCallback(),
    );
  }
  Future<bool> _willPopCallback() async {
   HomeData.updateStatusReadNotification(_auth.currentUser.uid);
   return Future.value(true);
} 
}