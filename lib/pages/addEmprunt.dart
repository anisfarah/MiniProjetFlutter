import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/pages/emprunt_page.dart';

class addEmpruntPage extends StatefulWidget {
  @override
  _addEmpruntPageState createState() => _addEmpruntPageState();
}

class _addEmpruntPageState extends State<addEmpruntPage> {

  TextEditingController _controllerQteEmprunt = TextEditingController();



  var _selectedValueComposant;


  var _selectedValueMembClub;

  final dbHelper = DatabaseHelper.instance;

  List<DropdownMenuItem<String>> _composants = [];
  List<DropdownMenuItem<String>> _membres = [];

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadComposants();
    _loadMembreClub();
  }

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


  void _query() async {
    final allRows = await dbHelper.queryAllRowsEmprunts();
    print('query all rows:');
    allRows.forEach(print);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Ajouter Emprunt'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[

            DropdownButtonFormField(
              value: _selectedValueComposant,
              items: _composants,
              hint: Text('Composant'),
              onChanged: (value) {
                setState(() {
                  _selectedValueComposant = value;
                });
              },
            ),
            DropdownButtonFormField(
              value: _selectedValueMembClub,
              items: _membres,
              hint: Text('Membre club'),
              onChanged: (value) {
                setState(() {
                  _selectedValueMembClub = value;
                });
              },
            ),

            TextField(
              controller: _controllerQteEmprunt,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'quantite pour emprunt', labelText: 'quantite'),
            ),

            RaisedButton(
              onPressed: () async {


                if (  (_controllerQteEmprunt.text == "")   ) {
                  alertDialog(context, "Champ vide,ressayez!");
                }
                else if (int.parse(_controllerQteEmprunt.text) < 0 ) {
                  alertDialog(context, "Valeur négatif,ressayez!");


                }

                else {

                  int qte= int.parse(_controllerQteEmprunt.text);
              String comp=_selectedValueComposant.toString();


                  Map<String, dynamic> row = {
                    DatabaseHelper.columnEmpMembre: _selectedValueMembClub.toString(),
                    DatabaseHelper.columnEmpComposant: comp,
                    DatabaseHelper.columnQteEmprunt: qte
                  };

                  final id = await dbHelper.insertEmprunt(row).then((value) {
                    Navigator.pop(context);
                    alertDialog(context, "Emprunt ajouté avec succès");

                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => EmpruntPage()));
                  }).catchError((error) {
                    print(error);
                    alertDialog(context, "Error: Data Save Fail");
                  });
                }
              },
              color: Colors.red,
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
