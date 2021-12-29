import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/login/genTextFormField.dart';
import 'package:mini_projeet/models/Famille.dart';
import 'package:mini_projeet/models/MembreClub.dart';
import 'package:mini_projeet/pages/addMembrePage.dart';
import 'package:mini_projeet/pages/homePage.dart';


class MembresPage extends StatefulWidget {
  @override
  _MembresPageState createState() => _MembresPageState();
}

class _MembresPageState extends State<MembresPage> {
  final dbHelper = DatabaseHelper.instance;

  final _formKey = new GlobalKey<FormState>();
  TextEditingController _editMembreNameController  =new TextEditingController();
  TextEditingController _editMembreNPrenomController  =new TextEditingController();
  TextEditingController _editMembreMobile1Controller  =new TextEditingController();
  TextEditingController _editMembreMobile2Controller  =new TextEditingController();




  var membre;
  var _membre= MembreClub();
  List<MembreClub> _membreList = [];


  getAllMembres() async {
    _membreList = [];
    var membres = await dbHelper.queryAllRowsMembres();
    membres.forEach((membre) {
      setState(() {
        var mem = MembreClub();
        mem.id_membre = membre['id_membre'];
        mem.nom_membre = membre['nom_membre'];
        mem.prenom_membre = membre['prenom_membre'];
        mem.numtel1 = membre['numtel1'];
        mem.numtel2 = membre['numtel2'];
        _membreList.add(mem);
      });
    });
  }

  readMembreById(id_membre) async {
    return await dbHelper.readMembreDataById('MembreClub', id_membre);
  }

  _editMembre(BuildContext context, id_membre) async {
    membre = await readMembreById(id_membre);
    setState(() {
      _editMembreNameController.text = membre[0]['nom_membre'] ?? 'No nom_membre';
      _editMembreNPrenomController.text = membre[0]['prenom_membre'] ?? 'No prenom_membre';
      _editMembreMobile1Controller.text = membre[0]['numtel1'] ?? 'No numtel1';
      _editMembreMobile2Controller.text = membre[0]['numtel2'] ?? 'No numtel2';

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
                  _membre.id_membre = membre[0]['id_membre'];
                  _membre.nom_membre = _editMembreNameController.text;
                  _membre.prenom_membre = _editMembreNPrenomController.text;
                  _membre.numtel1 = _editMembreMobile1Controller.text;
                  _membre.numtel2 = _editMembreMobile2Controller.text;


                  var result = await dbHelper.updateMembre(_membre.MembreClubMap());
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllMembres() ;
                    alertDialog(context, "Membre modifié");
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Membre Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editMembreNameController,
                    decoration: InputDecoration(
                        hintText: 'Nom membre', labelText: 'Nom'),
                  ),
                  TextField(
                    controller: _editMembreNPrenomController,
                    decoration: InputDecoration(
                        hintText: 'Prenom membre', labelText: 'Prenom'),
                  ),
                  TextField(
                    controller: _editMembreMobile1Controller,
                    decoration: InputDecoration(
                        hintText: 'mobile 1', labelText: 'Mobile 1'),
                  ),
                  TextField(
                    controller: _editMembreMobile2Controller,
                    decoration: InputDecoration(
                        hintText: 'mobile 2', labelText: 'Mobile 2'),
                  ),

                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, id_membre) {
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
                  await dbHelper.deleteMembre(id_membre);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllMembres() ;
                    alertDialog(context, "Membre club est supprimé");                  }
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
    getAllMembres() ;  }

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
          color: Colors.green,
        ),
        title: Text('Listes des membres'),centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
          itemCount: _membreList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  dense: true,

                  leading: IconButton(
                      icon: Icon(Icons.edit,color: Colors.green),
                      onPressed: () {
                        _editMembre(context, _membreList[index].id_membre);

                      }),


                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_membreList[index].prenom_membre.toUpperCase()+" "+_membreList[index].nom_membre.toUpperCase()+"\n"
                          "Tel1:"+_membreList[index].numtel1+" Tel2:"+_membreList[index].numtel2,
                          style: TextStyle(
                              color: Colors.black54 , fontWeight: FontWeight.bold,fontSize: 15)
                      ),


                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteFormDialog(context, _membreList[index].id_membre);

                          })
                    ],
                  ),


                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton( backgroundColor: Colors.green,



        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => addMembrePage()));
        },
        child: Icon(Icons.add,
        ),

      ),
    );
  }
}
