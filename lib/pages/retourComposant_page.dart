import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/login/genTextFormField.dart';
import 'package:mini_projeet/models/Famille.dart';
import 'package:mini_projeet/models/MembreClub.dart';
import 'package:mini_projeet/models/RetourComposant.dart';
import 'package:mini_projeet/pages/addMembrePage.dart';
import 'package:mini_projeet/pages/addRetourComposant.dart';
import 'package:mini_projeet/pages/homePage.dart';
import 'package:intl/intl.dart';


class RetourComposantPage extends StatefulWidget {
  @override
  _RetourComposantPageState createState() => _RetourComposantPageState();
}

class _RetourComposantPageState extends State<RetourComposantPage> {
  final dbHelper = DatabaseHelper.instance;

  final _formKey = new GlobalKey<FormState>();

  DateTime _dateTime = DateTime.now();
  var _selectedValueEmprunt;
  var _selectedValueEtat;
  List<String> _retours = ['intact', 'endommagé', 'gravement endommagé'];
  List<DropdownMenuItem<String>> _emprunts = [];
  TextEditingController _editEmpruntController  =new TextEditingController();
  TextEditingController _editEtatController  =new TextEditingController();





  var retourComposant;
  var _retourComposant= RetourComposant();
  List<RetourComposant> _retourList = [];


  getAllRetours() async {
    _retourList = [];
    var retours = await dbHelper.queryAllRowsRetourComposants();
    retours.forEach((retourComposant) {
      setState(() {
        var ret = RetourComposant();
        ret.id_retour = retourComposant['id_retour'];
        ret.emprunt = retourComposant['emprunt'];
        ret.date_retour = retourComposant['date_retour'];
        ret.etat = retourComposant['etat'];
        _retourList.add(ret);
      });
    });
  }

  _loadEmprunt() async {
    var emprunts = await dbHelper.queryAllRowsEmprunts();

    emprunts.forEach((emprunt) {
      setState(() {
        _emprunts.add(DropdownMenuItem(
          child: Text(emprunt['membre']+" - "+emprunt['composant']),
          value: emprunt['membre']+" - "+emprunt['composant'],
        ));
      });
    });
  }


  readRetourById(id_retour) async {
    return await dbHelper.readRetourComposantDataById('RetourComposant', id_retour);
  }

  _editRetourComposant(BuildContext context, id_retour) async {
    retourComposant = await readRetourById(id_retour);
    setState(() {
      _selectedValueEmprunt = retourComposant[0]['emprunt'] ?? 'No emprunt';
      _selectedValueEtat = retourComposant[0]['etat'] ?? 'No etat';


    });
    _editFormDialog(context);
  }



  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () async {

                  _retourComposant.id_retour= retourComposant[0]['id_retour'];
                  _retourComposant.emprunt=_selectedValueEmprunt.toString();
                  _retourComposant.etat=_selectedValueEtat.toString();
                  _retourComposant.date_retour= DateFormat('yyyy-MM-dd hh:mm:ss').format(_dateTime);


                  var result = await dbHelper.updateRetourComposant(_retourComposant.RetourComposantMap());
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllRetours() ;
                    alertDialog(context, "Retour du comosant est modifié modifié");
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Membre Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField(
                    value: _selectedValueEmprunt,
                    items: _emprunts,
                    hint: Text('Emprunt'),
                    onChanged: (value) {
                      setState(() {
                        _selectedValueEmprunt = value;
                      });
                    },
                  ),
                  DropdownButtonFormField(
                    value: _selectedValueEtat,
                    hint: Text(
                      'Etat',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedValueEtat = value;
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        _selectedValueEtat = value;
                      });
                    },

                    items: _retours
                        .map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),

                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, id_retour) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.indigo,
                onPressed: () async {
                  var result =
                  await dbHelper.deleteRetourComposant(id_retour);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllRetours() ;
                    alertDialog(context, "Retour comp est supprimé");                  }
                },
                child: Text('Delete'),
              ),
            ],
            title: Text('Supprimer ce membre?'),
          );
        });
  }







  @override
  void initState() {
    super.initState();
    _loadEmprunt();
    getAllRetours();  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  void _query() async {
    final allRows = await dbHelper.queryAllRowsComposants();
    print('query all rows:');
    allRows.forEach(print);
  }




  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState!.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_globalKey,
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MainPage())),
          elevation: 0.0,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: Colors.teal,
        ),
        title: Text('Listes des retours composants'),centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
          itemCount: _retourList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  dense: true,

                  leading: IconButton(
                      icon: Icon(Icons.edit,color: Colors.teal),
                      onPressed: () {
                        _editRetourComposant(context, _retourList[index].id_retour);

                      }),


                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_retourList[index].emprunt+"\n"+"Etat: "+_retourList[index].etat+"\n"
                          "Time: "+_retourList[index].date_retour,
                          style: TextStyle(
                              color: Colors.black54 , fontWeight: FontWeight.bold,fontSize: 15)
                      ),


                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteFormDialog(context, _retourList[index].id_retour);

                          })
                    ],
                  ),


                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton( backgroundColor: Colors.teal,



        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => addRetourComposantPage()));
        },
        child: Icon(Icons.add,
        ),

      ),
    );
  }
}
