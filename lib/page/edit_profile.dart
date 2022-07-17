import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:aks/ui/elements.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aks/function/validate_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:aks/model/user_model.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _bio = TextEditingController();
  final _name = TextEditingController();
  final picker = ImagePicker();
  String errorText = "";
  bool isLoading = true;
  File _imageFile;

  void validateForm(dynamic context, UserNotifier user) {
    String nameError = validateName(_name.value.text);
    var input = [nameError];
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
    errorText != "" ? ScaffoldMessenger.of(context).showSnackBar(snackBar) : saveProfile(context, user);
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
      (value) => {
        _auth.currentUser.updatePhotoURL(value),
        FirebaseFirestore.instance.collection("/users").doc(_auth.currentUser.uid).set({
          "photoURL": value,
        }, SetOptions(merge: true))
      },
    );
  }

  void saveProfile(context, UserNotifier user) async {
    UserData userData = user.user;
    FirebaseFirestore.instance.collection("/users").doc(_auth.currentUser.uid).update({"displayName": _name.value.text, "bio": _bio.value.text});
    if(_imageFile != null) {
      await uploadImageToFirebase();
    }
    final snackBar = SnackBar(
      content: Text("Data Telah Berhasil di Perbarui"),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {
        },
      ),
    );

    user.setUser(
      userData.classCode,
      userData.address,
      _bio.value.text,
      userData.points,
      userData.type
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = context.watch<UserNotifier>().user;
    _name.text = _auth.currentUser.displayName;
    _bio.text = userData.bio;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text("Edit Profil", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge.color)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Container(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              child: ClipOval(
                                child: _imageFile == null ? _auth.currentUser.photoURL == null ? Image.asset('assets/images/user.png', fit: BoxFit.cover) 
                                : FadeInImage(image: NetworkImage(_auth.currentUser.photoURL), placeholder: AssetImage('assets/images/user.png'))
                                : Image.file(_imageFile, fit: BoxFit.cover, height: 500, width: 500),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 2,
                            bottom: 0,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Icon(Icons.camera_alt, color: Colors.white, size: 17)
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                      child: Column(
                        children: [
                          Input(controller: _name, hintText: "Nama Lengkap", icon: Icons.person_outlined),
                          SizedBox(height: 20),
                          TextArea(controller: _bio, hintText: "Bio", maxLines: 3, maxLength: 50),
                          SizedBox(height: 30),
                          Button(onPressed: () {
                            validateForm(context, context.read<UserNotifier>());
                          }, color: Colors.blue, text: "Simpan"),
                        ],
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

class TextArea extends StatelessWidget {
  TextArea({
    this.expands = false,
    this.controller, 
    this.hintSize = 14, 
    this.hintText, 
    this.contentPadding = const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
    this.transparency = 0.1, this.maxLines = 6, 
    this.icon, this.secure = false, 
    this.maxLength = 20000,
    this.minLength = 1
  });
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool secure, expands;
  final int maxLength, maxLines, minLength;
  final double transparency, hintSize;
  final EdgeInsetsGeometry contentPadding;
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      expands: expands,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      obscureText: secure,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: (maxLines - 1) * 18.0),
          child: Icon(Icons.edit_outlined, color: secondary),
        ),
        prefixIconColor: secondary,
        counterText: "",
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: hintSize,
          color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor.withOpacity(0.5),
        ),
        contentPadding: contentPadding,
        disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent)
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent)
        ), 
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent)
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent)
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.transparent)
        ),
      ),
    );
  }
}