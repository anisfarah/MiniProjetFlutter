import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/models/Emprunt.dart';
import 'package:mini_projeet/pages/addEmprunt.dart';
import 'package:mini_projeet/pages/homePage.dart';



class EmpruntPage extends StatefulWidget {
  @override
  _EmpruntPageState createState() => _EmpruntPageState();
}

class _EmpruntPageState extends State<EmpruntPage> {
  final dbHelper = DatabaseHelper.instance;

  final _formKey = new GlobalKey<FormState>();

  TextEditingController _editcontrollerQteEmprunt  =new TextEditingController();


  var emprunt;
  var _emprunt= Emprunt();
  List<Emprunt> _empruntList = [];

  var _selectedValueComposant;
  var _selectedValueMembClub;
  List<DropdownMenuItem<String>> _composants = [];
  List<DropdownMenuItem<String>> _membres = [];


  _loadComposants() async {
    var composants = await dbHelper.queryAllRowsComposants();

    composants.forEach((composant) {
      setState(() {
        _composants.add(DropdownMenuItem(
          child: Text(composant['nom_composant']),
          value: composant['nom_composant'],
        ));
      });
    });
  }


  _loadMembreClub() async {
    var membres = await dbHelper.queryAllRowsMembres();

    membres.forEach((membre) {
      setState(() {
        _membres.add(DropdownMenuItem(
          child: Text(membre['nom_membre']+" "+membre['prenom_membre']),
          value: membre['nom_membre']+" "+membre['prenom_membre'],
        ));
      });
    });
  }

  getAllEmprunts() async {
    _empruntList = [];
    var emprunts = await dbHelper.queryAllRowsEmprunts();
    emprunts.forEach((emprunt) {
      setState(() {
        var emp = Emprunt();
        emp.id_emprunt=emprunt["id_emprunt"];
        emp.membre=emprunt["membre"];
        emp.composant=emprunt["composant"];
        _empruntList.add(emp);
      });
    });
  }

  readEmpruntById(id_emprunt) async {
    return await dbHelper.readEmpruntDataById('Emprunt', id_emprunt);
  }

  _editEmprunt(BuildContext context, id_emprunt) async {
    emprunt = await readEmpruntById(id_emprunt);
    setState(() {
      _selectedValueMembClub = emprunt[0]['membre'] ?? 'No membre';
      _selectedValueComposant = emprunt[0]['composant'] ?? 'No composant';
      _editcontrollerQteEmprunt.text = int.parse(emprunt[0]['qte_emprunt'] ?? 'No qte_emprunt').toInt().toString();


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
                  int qte= int.parse(_editcontrollerQteEmprunt.text);

                  _emprunt.id_emprunt= emprunt[0]['id_emprunt'];
                  _emprunt.membre= _selectedValueMembClub.toString();
                  _emprunt.composant= _selectedValueComposant.toString();
                  _emprunt.qte_emprunt= qte;



                  var result = await dbHelper.updateEmprunt(_emprunt.empruntMap());
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllEmprunts() ;
                    alertDialog(context, "Emprunt modifié");
                  }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Emprunt Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                    ),
                    iconSize: 50,
                    value: _selectedValueComposant,

                    items: _composants,
                    hint: Text('Select Composant'),
                    onChanged: (value) {
                      setState(() {
                        _selectedValueComposant = value;
                      });
                    },
                  ),
                  SizedBox(height: 7.0),

                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                    ),
                    iconSize: 50,
                    value: _selectedValueMembClub,

                    items: _membres,
                    hint: Text('Select Membre'),
                    onChanged: (value) {
                      setState(() {
                        _selectedValueMembClub = value;
                      });
                    },
                  ),

                  TextField(
                    controller: _editcontrollerQteEmprunt,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'quantite pour emprunt', labelText: 'quantite'),
                  ),

                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, id_emprunt) {
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
                  await dbHelper.deleteEmprunt(id_emprunt);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllEmprunts() ;
                    alertDialog(context, "Emprunt est supprimé");                  }
                },
                child: Text('Delete'),
              ),
            ],
            title: Text('Supprimer cette Emprunt?'),
          );
        });
  }







  @override
  void initState() {
    super.initState();
    _loadMembreClub();
    _loadComposants();
    getAllEmprunts() ;  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  void _query() async {
    final allRows = await dbHelper.queryAllRowsEmprunts();
    print('query all rows:');
    allRows.forEach(print);
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
          color: Colors.red,
        ),
        title: Text('Listes Emprunts'),centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          itemCount: _empruntList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                elevation: 8.0,
                child: ListTile(
                  dense: true,

                  leading: IconButton(
                      icon: Icon(Icons.edit,color: Colors.red),
                      onPressed: () {
                        _editEmprunt(context, _empruntList[index].id_emprunt);

                      }),


                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_empruntList[index].membre.toUpperCase()
                          +"\n"+"Composant: "+_empruntList[index].composant.toString(),
                          style: TextStyle(
                              color: Colors.black54 , fontWeight: FontWeight.bold,fontSize: 15)
                      ),


                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteFormDialog(context, _empruntList[index].id_emprunt);

                          })
                    ],
                  ),


                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton( backgroundColor: Colors.red,



        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => addEmpruntPage()));
        },
        child: Icon(Icons.add,
        ),

      ),
    );
  }
}
