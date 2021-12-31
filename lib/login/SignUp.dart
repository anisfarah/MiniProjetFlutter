import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/main.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/login/genTextFormField.dart';
import 'package:mini_projeet/pages/familleComposantPage.dart';
import 'package:mini_projeet/pages/homePage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = new GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;



  TextEditingController _conUserName = new TextEditingController();
  TextEditingController _conEmail = new TextEditingController();
  TextEditingController  _conPassword = new TextEditingController();
  TextEditingController  _conCPassword = new  TextEditingController();



  _signUp() async {
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;
    String cpasswd = _conCPassword.text;
    // row to insert

    if (_formKey.currentState!.validate()) {
      if (passwd != cpasswd) {
        alertDialog(context, 'Confirmer votre mdp svp!');
      } else {
        _formKey.currentState!.save();

        Map<String, dynamic> row = {
          DatabaseHelper.columnName: uname,
          DatabaseHelper.columnEmail: email,
          DatabaseHelper.columnPassword: passwd
        };

        final id = await dbHelper.insert(row).then((value) {
          alertDialog(context, "Ajout utilisateur réussit");

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginDemo()));
        }).catchError((error) {
          print(error);
          alertDialog(context, "Error: Data Save Fail");
          });
      }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),centerTitle: true,

      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(    margin: const EdgeInsets.only(top: 15.0),

            child: Center(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,


                children: [
                  getTextFormField(
                      controller: _conUserName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'User Name'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conEmail,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conCPassword,
                    icon: Icons.lock,
                    hintName: 'Confirm Password',
                    isObscureText: true,
                  ),

                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: FlatButton(
                      child: Text(
                        'Signup',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _signUp,

                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Avez-vous un compte? '),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text('Sign In'),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginDemo()),
                                    (Route<dynamic> route) => false);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

