import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/models/Composant.dart';
import 'package:mini_projeet/pages/addComposant.dart';
import 'package:mini_projeet/pages/homePage.dart';
import 'package:intl/intl.dart';

class ComposantPage extends StatefulWidget {
  @override
  _ComposantPageState createState() => _ComposantPageState();
}

class _ComposantPageState extends State<ComposantPage> {
  final dbHelper = DatabaseHelper.instance;

  TextEditingController _editComposantNameController  =new TextEditingController();
  TextEditingController _editComposantRefController  =new TextEditingController();
  TextEditingController _editFamComposantController  =new TextEditingController();
  TextEditingController _editQteComposantController  =new TextEditingController();
  TextEditingController _editDateController  =new TextEditingController();




  var composant;
  var _composant= Composant();

  List<Composant> _composantList = [];
  List<Composant> _composantsForDisplay = [];
  var _selectedValue;
  List<DropdownMenuItem<String>>_familles = [];

  DateTime _dateTime = DateTime.now();


  TextEditingController teSeach = TextEditingController();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _editDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
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


  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Search...'
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _composantsForDisplay = _composantList.where((composant) {
              var nameComposant = composant.nom_composant.toLowerCase();
              return nameComposant.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  getAllComposants() async {
    _composantList = [];
    var composants = await dbHelper.queryAllRowsComposants();
    composants.forEach((composant) {
      setState(() {
        var comp = Composant();
        comp.id_composant = composant['id_composant'];
        comp.nom_composant = composant['nom_composant'];
        comp.famille = composant['famille'];
        comp.date_acquisition = composant['date_acquisition'];
        comp.qte_dispo = int.parse(composant['qte_dispo']);
        comp.ref_composant = composant['ref_composant'];
        _composantList.add(comp);
        _composantsForDisplay = _composantList;

      });
    });
  }

  readComposantById(id_composant) async {
    return await dbHelper.readComposantDataById('Composant', id_composant);
  }

  _editComposant(BuildContext context, id_composant) async {
    composant = await readComposantById(id_composant);
    setState(() {
      _editComposantNameController.text = composant[0]['nom_composant'] ?? 'No nom_composant';
      _editComposantRefController.text = composant[0]['ref_composant'] ?? 'No ref_composant';
      _editQteComposantController.text = int.parse(composant[0]['qte_dispo'] ?? 'No qte_dispo').toInt().toString();
      _editDateController.text = composant[0]['date_acquisition'] ?? 'No date_acquisition';
      _selectedValue = composant[0]['famille'] ?? 'No famille';


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
                  int qte= int.parse(_editQteComposantController.text);


                  _composant.id_composant= composant[0]['id_composant'];
                  _composant.ref_composant = _editComposantRefController.text;
                 _composant.date_acquisition = _editDateController.text;
                  _composant.famille= _selectedValue.toString();
                  _composant.nom_composant = _editComposantNameController.text;
                  _composant.qte_dispo = qte;


                  var result = await dbHelper.updateComposant(_composant.composantMap());
                  if (result > 0) {
                     Navigator.pop(context);
                     getAllComposants() ;
                     alertDialog(context, "Composant modifié");
                   }
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Composant Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editComposantNameController,
                    decoration: InputDecoration(
                        hintText: 'Nom composant', labelText: 'Nom'),
                  ),
                  TextField(
                    controller: _editComposantRefController,
                    decoration: InputDecoration(
                        hintText: 'Reference composant', labelText: 'Reference'),
                  ),
                  TextField(
                    controller: _editQteComposantController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'qte dispo', labelText: 'Qte dispo'),
                  ),
                  TextField(
                    controller: _editDateController,
                    decoration: InputDecoration(
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
                  SizedBox(height: 7.0),

                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

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

                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, id_composant) {
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
                  await dbHelper.deleteComposant(id_composant);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllComposants() ;
                    alertDialog(context, "Composant est supprimé");                  }
                },
                child: Text('Delete'),
              ),
            ],
            title: Text('Supprimer ce composant?'),
          );
        });
  }

  _listItem(index) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
      child: Card(
        elevation: 8.0,
        child: ListTile(
          dense: true,

          leading: IconButton(
              icon: Icon(Icons.edit,color: Colors.deepPurple),
              onPressed: () {
                _editComposant(context, _composantList[index].id_composant);

              }),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(_composantsForDisplay[index].nom_composant+"\n"+"Qte:"+_composantsForDisplay[index].qte_dispo.toString(),
                  style: TextStyle(
                      color: Colors.black54 , fontWeight: FontWeight.bold,fontSize: 15)
              ),

              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _deleteFormDialog(context, _composantsForDisplay[index].id_composant);

                  })
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _loadFamilles();
    getAllComposants() ;  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

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
          color: Colors.deepPurple,
        ),
        title: Text('Listes Composants'),centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
          children: <Widget>[

    Expanded( child:
       ListView.builder(
          itemCount: _composantsForDisplay.length+1,
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index-1);

          }),
    ),
          ],
      ),
      floatingActionButton: FloatingActionButton( backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => addComposantPage()));
        },
        child: Icon(Icons.add,
        ),
      ),
    );
  }
}


