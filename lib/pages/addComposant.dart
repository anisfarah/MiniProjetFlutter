import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_projeet/database/DatabaseHelper.dart';
import 'package:mini_projeet/login/comHelper.dart';
import 'package:mini_projeet/pages/composant_page.dart';
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
        backgroundColor: Colors.deepPurple,

      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(    margin: const EdgeInsets.only(top: 20.0,left: 10,right: 10),


            child: Center(
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,


                children: [

                  TextField(
                    keyboardType: TextInputType.name,
                    controller: _conNomComposant,
                    decoration: InputDecoration(
                      hintText: 'Nom composant', labelText: 'Nom composant',
                      prefixIcon: InkWell(

                        child: Icon(Icons.person_outline,size: 25,),
                      )
                      ,),
                  ),
                  SizedBox(height: 10.0),

                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _conRefenceComposant,
                    decoration: InputDecoration(
                        hintText: 'Reference composant', labelText: 'Reference',
                      prefixIcon: InkWell(

                        child: Icon(Icons.email,size: 25,),
                      )
                      ,),
                  ),
                  SizedBox(height: 10.0),

                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _conQteDispo,
                    decoration: InputDecoration(
                        hintText: 'Quantite stock', labelText: 'Quantite',
                      prefixIcon: InkWell(

                        child: Icon(Icons.format_list_numbered_sharp ,size: 25,),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // getTextFormField(
                  //   controller: _conMobile2,
                  //   icon: Icons.add_ic_call,
                  //   hintName: 'date_acquisaition',
                  // ),

                  TextField(
                    controller: _conDateAqui,
                    decoration: InputDecoration(

                      labelText: 'Date',
                      hintText: 'Pick a Date',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: Icon(Icons.calendar_today,size: 25,),
                      ),
                    ),
                  ),
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(

                      prefixIcon: Icon(Icons.find_replace_outlined,size: 25),
                    ),
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
                    margin: EdgeInsets.all(25.0),

                    width: double.infinity,
                    child: FlatButton(

                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),

                      ),
                      onPressed: () async {
                        String uname = _conNomComposant.text;
                        String ref = _conRefenceComposant.text;

                        String  dateAqui= _conDateAqui.text;
                        if ( (uname == "")  || (ref == "") || (_conQteDispo.text == "")  || (dateAqui == "")  ) {
                          alertDialog(context, "Champ vide,ressayez!");
                        }
                       else if (int.parse(_conQteDispo.text) < 0 ) {
                          alertDialog(context, "Valeur négatif,ressayez!");
                        }

                        else {

                          int qte= int.parse(_conQteDispo.text);


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
                      color: Colors.deepPurple,
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

