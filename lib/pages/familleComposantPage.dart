import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/login/genTextFormField.dart';
import 'package:mini_projeet/models/Famille.dart';
import 'package:mini_projeet/pages/homePage.dart';


class FamillesScreen extends StatefulWidget {
  @override
  _FamillesScreenState createState() => _FamillesScreenState();
}

class _FamillesScreenState extends State<FamillesScreen> {
  final dbHelper = DatabaseHelper.instance;

  final _formKey = new GlobalKey<FormState>();
  TextEditingController _familleNameController  =new TextEditingController();
  TextEditingController _editfamilleNameController  =new TextEditingController();

  var famille;
  var _famille= Famille();
  List<Famille> _familleList = [];


  getAllFamilles() async {
    _familleList = [];
    var familles = await dbHelper.queryAllRowsFamille();
    familles.forEach((famille) {
      setState(() {
        var fam = Famille();
        fam.id_famille = famille['id_famille'];
        fam.nom_famille = famille['nom_famille'];
        _familleList.add(fam);
      });
    });
  }

  readFamilleById(id_famille) async {
    return await dbHelper.readDataById('famille', id_famille);
  }

  _editCategory(BuildContext context, id_famille) async {
    famille = await readFamilleById(id_famille);
    setState(() {
      _familleNameController.text = famille[0]['nom_famille'] ?? 'No nom_famille';

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

                  _famille.id_famille = famille[0]['id_famille'];
                  _famille.nom_famille = _editfamilleNameController.text;



                  var result = await dbHelper.updateFamille(_famille.familleMap());
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllFamilles();
                    alertDialog(context, "Famille modifiée");
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit familles Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editfamilleNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a famille composant', labelText: 'famille'),
                  ),

                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, id_famille) {
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
                  await dbHelper.deleteFamille(id_famille);
                  if (result > 0) {
                    Navigator.pop(context);
                  getAllFamilles();
                  alertDialog(context, "Famille composant est supprimée");                  }
                },
                child: Text('Delete'),
              ),
            ],
            title: Text('Supprimer cette famille?'),
          );
        });
  }







  @override
  void initState() {
    super.initState();
    getAllFamilles();  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  void _query() async {
    final allRows = await dbHelper.queryAllRowsComposants();
    print('query all rows:');
    allRows.forEach(print);
  }




  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () => Navigator.pop(context) ,
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Colors.indigo,
                onPressed: () async {
          String uname= _familleNameController.text;

          if (uname == "") {
          alertDialog(context, "le champ est vide!");
          }
          else {


          Map<String, dynamic> row = {
          DatabaseHelper.columnNomFamille: uname,

          };

          final id = await dbHelper.insertFamille(row).then((value) {
          Navigator.pop(context);
          alertDialog(context, "Famille ajoutée");

          Navigator.push(
          context, MaterialPageRoute(builder: (_) => FamillesScreen()));
          }).catchError((error) {
          print(error);
          alertDialog(context, "Error: Data Save Fail");
          });
          }
          },


                child: Text('Save'),
              ),
            ],
            title: Text('Famille composant Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  getTextFormField(
                      controller: _familleNameController,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'Nom famille composant'),


                ],
              ),
            ),
          );
        });
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
          color: Colors.blue,
        ),
        title: Text('Familles composants'),centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _familleList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(Icons.edit,color: Colors.blue),
                      onPressed: () {
                        _editCategory(context, _familleList[index].id_famille);

                      }),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_familleList[index].nom_famille),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteFormDialog(context, _familleList[index].id_famille);

                          })
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
