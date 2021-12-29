// ignore_for_file: prefer_const_constructors
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/models/Admin.dart';
import 'package:mini_projeet/pages/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_projeet/login/SignUp.dart';
import 'package:mini_projeet/login/comHelper.dart';

import 'database/DatabaseHelper.dart';
import 'login/genTextFormField.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final myEmailController = TextEditingController();
  final myPwdController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  final tab_admin = 'admin';




  login() async {
    String uid = myEmailController.text;
    String passwd = myPwdController.text;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', uid);

    if (uid.isEmpty) {
      alertDialog(context, "Please Enter Email");
    } else if (passwd.isEmpty) {
      alertDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        if (userData != null) {
          alertDialog(context, "Login successful");
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainPage()),
                    (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Utilisateur non trouvé");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(Admin user) async {
    final SharedPreferences sp = await _pref;
    sp.setString("id_admin", user.id_admin.toString());
    sp.setString("nom_admin", user.nom_admin);
    sp.setString("password", user.email);
    sp.setString("email", user.password);
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myEmailController.dispose();
    myPwdController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 180,

                    child: Image.asset('assets/jeune.png',height: 100,width:200)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15.0,top:20,bottom: 0),


              child: getTextFormField(
                  controller: myEmailController,
                  icon: Icons.email,
                  inputType: TextInputType.emailAddress,
                  hintName: 'Email'),

            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: getTextFormField(
                controller: myPwdController,
                icon: Icons.lock,
                hintName: 'Password',
                isObscureText: true,
              ),
            ),
            TextButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: login,

                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignupForm()));
                },
              child: Text(
                'New User? Create Account',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}