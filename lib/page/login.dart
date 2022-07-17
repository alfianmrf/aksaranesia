import 'package:flutter/material.dart';
import 'package:aks/function/auth.dart';
import 'package:aks/function/validate_form.dart';
import 'package:aks/ui/elements.dart';
import 'package:aks/page/register.dart';
import 'package:aks/page/home.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorText = "";
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser(dynamic context) async {
    setState(() {
      isLoading = true;      
    });

    AuthData result = await AuthService.login(emailController.value.text, passwordController.value.text);
    if(result.user != null) {
      
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
            return Home();
          }
        ), 
        (Route<dynamic> route) => false
      );

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
  
  void validateForm(dynamic context) {
    String passwordError = validatePassword(passwordController.value.text);
    String emailError = validateEmail(emailController.value.text);
    var input = [passwordError, emailError];
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
    errorText != "" ? ScaffoldMessenger.of(context).showSnackBar(snackBar) : loginUser(context);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    height: 2, 
                    child: isLoading ? LinearProgressIndicator(minHeight: 2) : SizedBox()
                  ),
                  Container(
                    width: size.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            Image.asset('assets/images/logo.png', width: 100),
                            Text("Masuk ke Aksaranesia.co", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 40),
                            Input(controller: emailController, hintText: "Email", icon: Icons.email_outlined),
                            SizedBox(height: 20),
                            Input(controller: passwordController, hintText: "Password", icon: Icons.lock_outlined, secure: true),
                            SizedBox(height: 40),
                            Button(text: isLoading ? "Sedang Masuk..." : "Masuk", color: Colors.blue, onPressed: isLoading ? null :  () => validateForm(context)),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Belum punya akun ? "),
                                InkWell(onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Register();
                                    }
                                  ));
                                }, 
                                child: Text("Daftar Sekarang", style: TextStyle(color: Colors.blue))),
                              ],
                            )
                          ],
                        ),
                      )
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}