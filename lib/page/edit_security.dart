import "package:flutter/material.dart";
import "package:aks/ui/elements.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:aks/function/validate_form.dart";

class EditSecurity extends StatefulWidget {
  @override
  EditSecurity(this.credential);
  UserCredential credential;
  _EditSecurity createState() => _EditSecurity();
}

class _EditSecurity extends State<EditSecurity> {
  final _password = TextEditingController();
  final _passwordConfirmation = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String errorText = "";

  @override
  void initState() {
    super.initState();
  }

  void validateForm(dynamic context) {
    String passwordError = validatePasswordRegister(_password.value.text, _passwordConfirmation.value.text);
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
    errorText != "" ? ScaffoldMessenger.of(context).showSnackBar(snackBar) : changeData(widget.credential);
  }

  void changeData(UserCredential creds) async {
    await creds.user.updatePassword(_password.value.text);
    final snackBar = SnackBar(
      content: Text("Data Berhasil Diubah"),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Edit Keamanan", style: TextStyle(fontSize: 18)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Input(controller: _password, hintText: "Password", icon: Icons.lock_outlined, secure: true),
                  SizedBox(height: 20),
                  Input(controller: _passwordConfirmation, hintText: "Konfirmasi Password", icon: Icons.lock_outlined, secure: true),
                  SizedBox(height: 30),
                  Button(color: Colors.blue, text: "Simpan", onPressed: () {
                    validateForm(context);
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}