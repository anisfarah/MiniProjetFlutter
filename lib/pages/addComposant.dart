import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/main.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/login/genTextFormField.dart';
import 'package:mini_projeet/models/Famille.dart';
import 'package:mini_projeet/pages/button_widget.dart';
import 'package:mini_projeet/pages/composant_page.dart';
import 'package:mini_projeet/pages/familleComposantPage.dart';
import 'package:mini_projeet/pages/homePage.dart';
import 'package:mini_projeet/pages/membres_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';



class addComposantPage extends StatefulWidget {


  @override
  _addComposantPageState createState() => _addComposantPageState();
}

class _addComposantPageState extends State<addComposantPage> {
  final _formKey = new GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;
  var _selectedValue;
  List<DropdownMenuItem<String>> _familles = [];
  DateTime? date;




  TextEditingController _conNomComposant = new TextEditingController();
  TextEditingController  _conRefenceComposant = new TextEditingController();
  TextEditingController  _conQteDispo = new TextEditingController();
  TextEditingController  _conDateAqui = new TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadFamilles();
  }

  String getText() {
    if (date == null) {
      return 'Date acquisition';
    } else {
      return DateFormat('dd-MM-yyyy').format(date);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  _loadFamilles() async {
    var familles = await dbHelper.queryAllRowsFamille();
    familles.forEach((famille) {
      setState(() {
        _familles.add(DropdownMenuItem(
          child: Text(famille['nom_famille']),
          value: famille['nom_famille'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _conDateAqui.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter composant'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,

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
                      controller: _conNomComposant,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'Nom composant'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conRefenceComposant,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Reference composant'),
                  SizedBox(height: 10.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _conQteDispo,
                    decoration: InputDecoration(
                        hintText: 'Quantite stock', labelText: 'quantite'),
                  ),
                  SizedBox(height: 10.0),
                  // getTextFormField(
                  //   controller: _conMobile2,
                  //   icon: Icons.add_ic_call,
                  //   hintName: 'date_acquisaition',
                  // ),
                  SizedBox(height: 10.0),

                  TextField(
                    controller: _conDateAqui,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: 'Date',
                      hintText: 'Pick a Date',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0,width: 158),
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),

                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    iconSize: 50,
                    value: _selectedValue,

                    items: _familles,
                    hint: Text('Select Famille'),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
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
                        String uname = _conNomComposant.text;
                        String ref = _conRefenceComposant.text;
                        int qte= int.parse(_conQteDispo.text);

                        String  dateAqui= _conDateAqui.text;
                        if ( (uname == "")  || (ref == "") || (qte == "")  || (dateAqui == "")  ) {
                          alertDialog(context, "Champ vide,ressayez!");
                        }

                        else {



                          Map<String, dynamic> row = {
                            DatabaseHelper.columnNomComposant: uname,
                            DatabaseHelper.columnRefComposant: ref,
                            DatabaseHelper.columnQteDispo: qte,
                            DatabaseHelper.columnFamComposant: _selectedValue.toString(),
                            DatabaseHelper.columnDateAcqui: dateAqui

                          };

                          final id = await dbHelper.insertComposant(row).then((value) {
                            Navigator.pop(context);
                            alertDialog(context, "Composant ajouté avec succès");

                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => ComposantPage()));
                          }).catchError((error) {
                            print(error);
                            alertDialog(context, "Error: Data Save Fail");
                          });
                        }



                      },

                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
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

