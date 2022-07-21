import 'package:aks/function/get_timeline.dart';
import 'package:aks/page/create_post.dart';
import 'package:aks/ui/elements.dart';
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
import 'package:aks/page/notification.dart' as notification;


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  InitData init = InitData();
  var isNewNotificationAvailable = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var data = await init.getData();
    context.read<UserNotifier>().setUser(
        data['classCode'],
        data['address'],
        data['bio'],
        data['points'],
        data['type']
    );

    isNewNotificationAvailable = HomeData
        .checkIfAnyUnreadNotification(_auth.currentUser.uid) as bool;
  }

  @override
  Widget build(BuildContext context) {

    List<PreferredSizeWidget> appBar = [
      AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Aksaranesia.co", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    print("Penanda");
                    print(isNewNotificationAvailable);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return ListChat();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ImageIcon(
                      AssetImage("assets/images/message.png"),
                      color: primary,
                      size: 22,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return notification.Notification();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: !isNewNotificationAvailable ?
                    ImageIcon(
                      AssetImage("assets/images/notification.png"),
                      color: primary,
                      size: 22,
                    ) :
                    ImageIcon(
                      AssetImage("assets/images/clicked_notification.png"),
                      color: primary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        backgroundColor: accent,
      ),
      AppBar(title: Text("Eksplor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge.color))),
      PreferredSize(preferredSize: Size(0.0, 0.0),child: Container()),
      PreferredSize(preferredSize: Size(0.0, 0.0),child: Container()),
      AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Profil", style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.titleLarge.color, fontWeight: FontWeight.bold)),
            InkWell(
              child: Icon(Icons.settings_outlined, size: 23),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              },
            )
          ],
        ),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar[_currentIndex],
      body: IndexedStack(
        index: _currentIndex,
        children: [
          TabHome(),
          TabSearch(),
          TabBorrow(),
          TabClass(),
          TabProfile(),
        ],
      ),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CreatePost();
          }));
        },
        backgroundColor: primary,
        child: const Icon(Icons.add),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if(_currentIndex == 4){
              getData();
            }
          },
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: primary,
          items: [
            BottomNavigationBarItem(
              icon: _currentIndex == 0 ? Image.asset("assets/images/icon/clicked_beranda.png", width: 20) : Image.asset("assets/images/icon/beranda.png", width: 20),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: _currentIndex == 1 ? Image.asset("assets/images/icon/clicked_search.png", width: 20) : Image.asset("assets/images/icon/search.png", width: 20),
              label: "Eksplor",
            ),
            BottomNavigationBarItem(
              icon:  _currentIndex == 2 ? Image.asset("assets/images/icon/clicked_buku.png", width: 20) : Image.asset("assets/images/icon/buku.png", width: 20),
              label: "Perpustakaan",
            ),
            BottomNavigationBarItem(
              icon:  _currentIndex == 3 ? Image.asset("assets/images/icon/clicked_kelas.png", width: 20) : Image.asset("assets/images/icon/kelas.png", width: 20),
              label: "Kelas",
            ),
            BottomNavigationBarItem(
              icon:  _currentIndex == 4 ? Image.asset("assets/images/icon/clicked_akun.png", width: 20) : Image.asset("assets/images/icon/akun.png", width: 20),
              label: "Profil",
            ),
          ]
      ),
    );
  }
}