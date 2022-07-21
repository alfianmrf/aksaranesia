import 'package:flutter/material.dart';
import 'package:aks/function/auth.dart';
import 'package:aks/function/validate_form.dart';
import 'package:aks/ui/elements.dart';
import 'package:aks/page/register.dart';
import 'package:aks/page/typeregist.dart';
import 'package:aks/page/teacherregist.dart';
import 'package:aks/page/login.dart';
import 'package:aks/page/home.dart';

class Typeregist extends StatefulWidget {
  @override
  TyperegistState createState() => TyperegistState();
}

class TyperegistState extends State<Typeregist> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                Text("Selamat datang di", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                Text(" Aksaranesia.co", style: TextStyle(color: Colors.blue, fontSize: 19, fontWeight: FontWeight.bold)),
                ] 
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "SMA Taruna Intensif Pembangunan Surabaya !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                "Daftar sebagai",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                ] 
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
                          return TeacherRegist();
                        }
                      ));
                    },
                    color: Color(0xff0095FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Guru", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text("atau"),
                  SizedBox(
                    height: 3,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Register();
                        }
                      ));
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Murid", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
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