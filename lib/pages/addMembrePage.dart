import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/main.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/login/genTextFormField.dart';
import 'package:mini_projeet/pages/familleComposantPage.dart';
import 'package:mini_projeet/pages/homePage.dart';
import 'package:mini_projeet/pages/membres_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class addMembrePage extends StatefulWidget {
  @override
  _addMembrePageState createState() => _addMembrePageState();
}

class _addMembrePageState extends State<addMembrePage> {
  final _formKey = new GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;



  TextEditingController _conNomMembre = new TextEditingController();
  TextEditingController  _conPrenomMembre = new TextEditingController();
  TextEditingController  _conMobile1 = new TextEditingController();
  TextEditingController  _conMobile2 = new  TextEditingController();


// pour tester
  void _query() async {
    final allRows = await dbHelper.queryAllRowsMembres();
    print('query all rows:');
    allRows.forEach(print);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Membre'),
        centerTitle: true,
        backgroundColor: Colors.green,

      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(    margin: const EdgeInsets.only(top: 25.0),

            child: Center(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,


                children: [
                  getTextFormField(
                      controller: _conNomMembre,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'Nom membre'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conPrenomMembre,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Prenom membre',
                  ),

                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conMobile1,
                    icon: Icons.add_ic_call,
                    hintName: 'mobile 1',
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conMobile2,
                    icon: Icons.add_ic_call,
                    hintName: 'mobile 2',
                  ),

                  Container(
                    margin: EdgeInsets.all(30.0),

                    width: double.infinity,
                    child: FlatButton(

                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),

                      ),
                      onPressed: () async {
                        String uname = _conNomMembre.text;
                        String prenom = _conPrenomMembre.text;
                        String tel1 = _conMobile1.text;
                        String tel2 = _conMobile2.text;
                        if ( (uname == "")  || (prenom == "") || (tel1 == "")  || (tel2 == "")  ) {
                          alertDialog(context, "Champ vide,ressayez!");
                        }

                        else {



                          Map<String, dynamic> row = {
                            DatabaseHelper.columnNomMembre: uname,
                            DatabaseHelper.columnPrenomMembre: prenom,
                            DatabaseHelper.columnTel1: tel1,
                            DatabaseHelper.columnTel2: tel2,

                          };

                          final id = await dbHelper.insertMembre(row).then((value) {
                            Navigator.pop(context);
                            alertDialog(context, "Membre ajouté avec succès");

                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => MembresPage()));
                          }).catchError((error) {
                            print(error);
                            alertDialog(context, "Error: Data Save Fail");
                          });
                        }



                      },

                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30.0),
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

