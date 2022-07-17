import 'package:flutter/material.dart';
import "package:aks/ui/elements.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:aks/function/validate_form.dart";
import "package:aks/page/edit_security.dart";

class ReLogin extends StatefulWidget {
  @override
  _ReLogin createState() => _ReLogin();
}

class _ReLogin extends State<ReLogin> {
  String errorText = "";
  final _pass = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  
  void validateForm(dynamic context) {
    String passwordError = validatePassword(_pass.value.text);
    var input = [passwordError];
    setState(() {
      input.forEach((element) {
        if(element != null) {
          return errorText = element;
        } else if(element == null  && input[0] == element) {
          return errorText = "";
        } else {}
      });
    });

    final snackBar = SnackBar(
      content: Text(errorText),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {
        },
      ),
    );
    errorText != "" ? ScaffoldMessenger.of(context).showSnackBar(snackBar) : getToken(context);
  }

  void getToken(context) async {
    setState(() {
      isLoading = true;      
    });
    var creds = EmailAuthProvider.credential(email: _auth.currentUser.email, password: _pass.value.text);
    try {
      var result = await _auth.signInWithCredential(creds);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return EditSecurity(result);
        }
      ));
    } on Exception {
      setState(() {
        isLoading = false;      
      });
      final snackBar = SnackBar(
        content: Text("Password Salah"),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Edit Keamanan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge.color),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading ? Container(
              height: 2,
              child: LinearProgressIndicator(minHeight: 2),
            ) :
            SizedBox(),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Masukkan Katasandi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Untuk memperbarui katasandi anda", style: TextStyle(fontSize: 14)),
                      SizedBox(height: 30),
                      Input(controller: _pass, hintText: "Katasandi", icon: Icons.lock_outlined, secure: true),
                      SizedBox(height: 40),
                      Button(text: isLoading ? "Mengotentikasi..." : "Simpan", color: Colors.blue, onPressed: isLoading ? null : () {
                        validateForm(context);
                      }),
                    ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityArguments {
  final UserCredential credential;
  SecurityArguments(this.credential);
}