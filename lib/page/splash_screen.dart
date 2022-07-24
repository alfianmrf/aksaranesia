import 'package:aks/page/welcome.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:aks/model/dark_mode.dart';
import 'package:aks/page/login.dart';
import 'package:aks/page/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  void initState() {
    super.initState();
    return checkLogin();
  }

  void checkLogin() {
    var duration = Duration(seconds: 2);
    Timer(duration, () {
      if(_auth.currentUser != null) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) {
            return Home();
          }
        ), (Route<dynamic> route) => false);  
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return Welcome();
          }
        ));
      }
    });
  }

  Widget build(BuildContext context) {
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    Size size = MediaQuery.of(context).size;
    
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          if(notifier.darkMode == true) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.dark.copyWith(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.black, systemNavigationBarColor: Colors.black)
            );
          } else {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.white, systemNavigationBarColor: Colors.white)
            );
          }
          return Scaffold(
            body: Container(
              width: size.width,
              height: size.height,
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/new_logo.png', width: 80),
                  SizedBox(height: 20),
                  Text("Aksaranesia", style: TextStyle(fontSize: 18)),
                ]
              )
            )
          );
        },
      )
    );
  }
}