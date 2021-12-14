import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' ;
import 'package:mini_projeet/models/Famille.dart';

class DatabaseHelper {

  static final _databaseName = "MiniProjet";
  static final _databaseVersion = 4;


  //table admin
  static final table_admin = 'admin';
  static final columnId = 'id_admin';
  static final columnName = 'nom_admin';
  static final columnPassword = 'password';
  static final columnEmail = 'email';
  //table famille
  static final table_famille = 'famille';
  static final columnIdFamille = 'id_famille';
  static final columnNomFamille = 'nom_famille';
  //table composant

  static final table_composant='composant';
  static final columnIdComposant='id_composant';
  static final columnNomComposant='nom_composant';
  static final columnRefComposant='ref_composant';
  static final columnFamComposant='id_famille';
  static final columnQteDispo='qte_dispo';
  static final columnDateAcqui='date_acquisition';


  //table membre_club
  static final table_membreClub='MembreClub';
  static final columnIdMembre='id_membre';
  static final columnNomMembre='nom_membre';
  static final columnPrenomMembre='prenom_membre';
  static final columnTel1='numtel1';
  static final columnTel2='numtel2';







  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  Database? _database = null;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table_admin (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnEmail TEXT NOT NULL
          )
          
          
    
          ''');
  }

  // Future _onUpgrade(Database db, int _oldVersion, int _newVersion) async {
  //   if (_oldVersion < _newVersion) {
  //     await db.execute('''
  //     CREATE TABLE $table_famille (
  //         $columnIdFamille INTEGER PRIMARY KEY AUTOINCREMENT,
  //         $columnNomFamille TEXT NOT NULL
  //     )
  //      ''');
  //   }
  // }

  // Future _onUpgrade(Database db, int _oldVersion, int _newVersion) async {
  //   if (_oldVersion < _newVersion) {
  //     await db.execute('''
  //     CREATE TABLE $table_composant (
  //         $columnIdComposant INTEGER PRIMARY KEY AUTOINCREMENT,
  //         $columnNomComposant TEXT NOT NULL,
  //         $columnRefComposant TEXT NOT NULL,
  //         $columnQteDispo INTEGER,
  //         $columnDateAcqui DATE,
  //         $columnFamComposant INTEGER,
  //         FOREIGN KEY($columnFamComposant) REFERENCES famille(id_famille)
  //
  //     )
  //      ''');
  //   }
  // }


  Future _onUpgrade(Database db, int _oldVersion, int _newVersion) async {
    if (_oldVersion < _newVersion) {
      await db.execute('''
      CREATE TABLE $table_membreClub (
          $columnIdMembre INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnNomMembre TEXT NOT NULL,
          $columnPrenomMembre TEXT NOT NULL,
          $columnTel1 TEXT NOT NULL,
          $columnTel2 TEXT NOT NULL


      )
       ''');
    }
  }


  // Helper methods



  Future<List<Map<String, dynamic>>?> getLoginUser(String userEm, String password) async {
    var dbClient = await database;
    var res = await dbClient.rawQuery("SELECT * FROM $table_admin WHERE "
        "$columnEmail = '$userEm' AND "
        "$columnPassword = '$password'");

    if (res.length > 0) {
      return res;
    }

    return null;
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table_admin, row
    );
  }



  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table_admin);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table_admin'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table_admin, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table_admin, where: '$columnId = ?', whereArgs: [id]);
  }




  //table famille
  Future<int> insertFamille(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table_famille, row
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRowsFamille() async {
    Database db = await instance.database;
    return await db.query(table_famille);
  }

  Future<int?> queryRowCountFamille() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table_famille'));
  }

  Future<int> updateFamille(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnIdFamille];
    return await db.update(table_famille, row, where: '$columnIdFamille = ?', whereArgs: [id]);
  }

  Future<int> deleteFamille(int id) async {
    Database db = await instance.database;
    return await db.delete(table_famille, where: '$columnIdFamille = ?', whereArgs: [id]);
  }

  readDataById(table, itemId) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnIdFamille =?', whereArgs: [itemId]);
  }



//table composant

  Future<int> insertComposant(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table_composant, row
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRowsComposants() async {
    Database db = await instance.database;
    return await db.query(table_composant);
  }

  Future<int?> queryRowCountComposant() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table_composant'));
  }

  Future<int> updateComposant(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnIdComposant];
    return await db.update(table_composant, row, where: '$columnIdComposant = ?', whereArgs: [id]);
  }

  Future<int> deleteComposant(int id) async {
    Database db = await instance.database;
    return await db.delete(table_composant, where: '$columnIdComposant = ?', whereArgs: [id]);
  }


  //table membre_club

  Future<int> insertMembre(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table_membreClub, row
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRowsMembres() async {
    Database db = await instance.database;
    return await db.query(table_membreClub);
  }

  Future<int?> queryRowCountMembre() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table_membreClub'));
  }

  Future<int> updateMembre(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnIdMembre];
    return await db.update(table_membreClub, row, where: '$columnIdMembre = ?', whereArgs: [id]);
  }

  Future<int> deleteMembre(int id) async {
    Database db = await instance.database;
    return await db.delete(table_membreClub, where: '$columnIdMembre = ?', whereArgs: [id]);
  }

  readMembreDataById(table, itemId) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnIdMembre =?', whereArgs: [itemId]);
  }
}