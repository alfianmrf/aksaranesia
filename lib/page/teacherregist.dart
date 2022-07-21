import 'package:flutter/material.dart';
import 'package:aks/function/auth.dart';
import 'package:aks/function/validate_form.dart';
import 'package:aks/ui/elements.dart';
import 'package:aks/page/register.dart';
import 'package:aks/page/typeregist.dart';
import 'package:aks/page/login.dart';
import 'package:aks/page/home.dart';

class TeacherRegist extends StatefulWidget {
  @override
  TeacherRegistState createState() => TeacherRegistState();
}

class TeacherRegistState extends State<TeacherRegist> {

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
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cant.png'),
                  ),
                ),
              ),
              Text(
                "Maaf saat ini belum bisa",
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
              Text(
                "daftar sebagai guru",
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}