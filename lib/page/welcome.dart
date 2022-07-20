import 'package:aks/page/typeregist.dart';
import 'package:flutter/material.dart';
import 'package:aks/function/auth.dart';
import 'package:aks/function/validate_form.dart';
import 'package:aks/ui/elements.dart';
import 'package:aks/page/register.dart';
import 'package:aks/page/typeregist.dart';
import 'package:aks/page/login.dart';
import 'package:aks/page/home.dart';

class Welcome extends StatefulWidget {
  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                Image.asset('assets/images/logo.png', width: 50),
                Text("Aksaranesia.co", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ] 
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/welcomeUI.png'),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Text(
                "Selamat Datang di",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                " Aksaranesia.co",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                "!",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                ]
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Aplikasi pendukung Gerakan Literasi Sekolah untuk menciptakan generasi Cermat Membaca, Cakap Menulis.",
                style: TextStyle(
                  fontSize: 15,
                  ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        }
                      ));
                    },
                    color: Color(0xff0095FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Log in", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Typeregist();
                        }
                      ));
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Sign up", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
          ),
        ),
      ),
    );
  }
}