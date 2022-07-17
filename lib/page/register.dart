import 'package:flutter/material.dart';
import 'package:aks/ui/elements.dart';
import 'package:aks/function/validate_form.dart';
import 'package:aks/function/auth.dart';
import 'package:aks/page/home.dart';


class Register extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final emailController = TextEditingController(); 
  final passwordController = TextEditingController(); 
  final nameController = TextEditingController(); 
  final confirmationController = TextEditingController();
  String currentSelectedValue = "10MIPA1";
  String tipeUser = '0';
  String errorText = "";
  bool isLoading = false;

  final List<Map<String, dynamic>> _items = [
    {
      'value': '10MIPA1',
      'label': '10 MIPA 1',
    },
    {
      'value': '10MIPA2',
      'label': '10 MIPA 2',
    },
    {
      'value': '10MIPA3',
      'label': '10 MIPA 3',
    },
    {
      'value': '10MIPA4',
      'label': '10 MIPA 4',
    },
    {
      'value': '10MIPA5',
      'label': '10 MIPA 5',
    },
    {
      'value': '10MIPA6',
      'label': '10 MIPA 6',
    },
    {
      'value': '10MIPA7',
      'label': '10 MIPA 7',
    },
    {
      'value': '10IPS1',
      'label': '10 IPS 1',
    },
    {
      'value': '10IPS2',
      'label': '10 IPS 2',
    },
    {
      'value': '10IPS3',
      'label': '10 IPS 3',
    },
    {
      'value': '10IBB',
      'label': '10 IBB',
    },
  ];

  final List<Map<String, dynamic>> _tipe = [
    {
      'value': 0,
      'label': 'Murid',
    },
    {
      'value': 1,
      'label': 'Guru',
    },
  ];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmationController.dispose();
    super.dispose();
  }

  void registerUser(dynamic context, int type) async {
    setState(() {
      isLoading = true;
    });

    AuthData result = await AuthService.register(
      emailController.text,
      passwordController.text,
      nameController.text
    );

    if(result.user != null) {
      AuthService.addUserToDatabase(result.user.user.uid, currentSelectedValue, nameController.text, type);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          return Home();
        }
      ), (Route<dynamic> route) => false);
    } else {
      final snackBar = SnackBar(
        content: Text(result.message),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {
          },
        ),
      );

      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  
  void validateForm(dynamic context, int type) {
    String passwordError = validatePasswordRegister(passwordController.value.text, confirmationController.value.text);
    String emailError = validateEmail(emailController.value.text);
    String nameError = validateName(nameController.value.text);
    var input = [passwordError, emailError, nameError];
    setState(() {
      input.forEach((element) {
        if(element != null) {
          return errorText = element;
        } else if(element == null  && input[0] == element) {
          return errorText = "";
        } else {
          isLoading = false;
        }
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
    errorText != "" ? ScaffoldMessenger.of(context).showSnackBar(snackBar) : registerUser(context, type);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: 2, 
                  child: isLoading ? LinearProgressIndicator(minHeight: 2) : SizedBox()
                ),
                Container (
                  width: size.width,
                  height: size.height,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text("Daftar Aksaranesia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              SizedBox(height: 10),
                              Text("Membuat Akun Baru Aksaranesia"),
                              SizedBox(height: 25),
                            ]
                          )
                        ),
                        Input(controller: nameController, hintText: "Nama Lengkap", icon: Icons.person_outline),
                        SizedBox(height: 15),
                        Input(controller: emailController, hintText: "Email", icon: Icons.email_outlined),
                        SizedBox(height: 15),
                        Input(controller: passwordController, hintText: "Password", icon: Icons.lock_outlined, secure: true),
                        SizedBox(height: 15),
                        Input(controller: confirmationController, hintText: "Konfirmasi Password", icon: Icons.lock_outlined, secure: true),
                        SizedBox(height: 15),
                        Select(
                          onChanged: (value) {
                            setState(() {
                              currentSelectedValue = value;
                            });
                          },
                          icon: Icons.school_outlined,
                          items: _items,
                          text: "Pilih Kelas",
                          currentSelectedValue: currentSelectedValue,
                        ),

                        SizedBox(height: 15),
                        Select(
                          onChanged: (value) {
                            setState(() {
                              tipeUser = value;
                            });
                          },
                          icon: Icons.supervised_user_circle_outlined,
                          items: _tipe,
                          text: "Pilih Kelas",
                          currentSelectedValue: tipeUser,
                        ),
                        SizedBox(height: 25),
                        Button(
                          onPressed: isLoading ? null : () => validateForm(context, int.parse(tipeUser)), 
                          color: Colors.blue, 
                          text: isLoading ? "Sedang Mendaftar..." : "Daftar"
                        ),
                      ]
                    )
                  )
                )),
              ],
            ),
          ),
        ],
      )
    );
  }
}