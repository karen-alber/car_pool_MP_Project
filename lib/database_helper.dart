import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class mydatabaseclass {
  Database? mydb;

  Future<Database?> mydbcheck() async {
    if (mydb == null) {
      mydb = await initiatedatabase();
      return mydb;
    } else {
      return mydb;
    }
  }

  int Version = 1;
  initiatedatabase() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase2.db');
    Database mydatabase = await openDatabase(
      databasepath,
      version: Version,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE IF NOT EXISTS 'TABLE'(
      'EMAIL' TEXT NOT NULL PRIMARY KEY,
      'NAME' TEXT NOT NULL,
      'PASSWORD' TEXT NOT NULL,
      'TYPE' TEXT NOT NULL)
       ''');
        print("Database has been created");
      },
    );
    return mydatabase;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? somevariable = await mydbcheck();
    return somevariable!.query('TABLE');
  }

  checking() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase2.db');
    await databaseExists(databasepath) ? print("it exists") : print("hardluck");
  }

  reseting() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase2.db');
    await deleteDatabase(databasepath);
  }

  reading(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawQuery(sql);
    return response;
  }

  writing(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawInsert(sql);
    return response;
  }

  deleting(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawDelete(sql);
    return response;
  }

  updating(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawUpdate(sql);
    return response;
  }
}
