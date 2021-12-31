import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/pages/retourComposant_page.dart';

class addRetourComposantPage extends StatefulWidget {
  @override
  _addRetourComposantPageState createState() => _addRetourComposantPageState();
}

class _addRetourComposantPageState extends State<addRetourComposantPage> {


  DateTime _dateTime = DateTime.now();
  var _selectedValueEmprunt;
  var _selectedValueEtat;

  final dbHelper = DatabaseHelper.instance;

  List<String> _retours = ['intact', 'endommagé', 'gravement endommagé'];

  List<DropdownMenuItem<String>> _emprunts = [];

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadEmprunt();
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





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Ajouter Retour Composant'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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


            RaisedButton(
              onPressed: () async {


                if ( (_selectedValueEmprunt == "")     ) {
                  alertDialog(context, "Champ vide,ressayez!");
                }

                else {


                  Map<String, dynamic> row = {

                    DatabaseHelper.columnRetEmprunt: _selectedValueEmprunt.toString(),
                    DatabaseHelper.columnRetEtat: _selectedValueEtat.toString(),
                    DatabaseHelper.columnRetDate: DateFormat('yyyy-MM-dd hh:mm:ss').format(_dateTime)


                  };

                  final id = await dbHelper.insertRetourComposant(row).then((value) {
                    Navigator.pop(context);
                    alertDialog(context, "retour du composant est effectué avec succès");

                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => RetourComposantPage()));
                  }).catchError((error) {
                    print(error);
                    alertDialog(context, "Error: Data Save Fail");
                  });
                }
              },
              color: Colors.teal,
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
