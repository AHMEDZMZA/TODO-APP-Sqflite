import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/data/database_model.dart';

/// DataBase
Database? database;

/// في حال اضافه عمود جديد يبقى لازم اغير ال version عشان يعترف بال تغيير و ال DATABASE هتفضل شكل ما هيا عليه
/// Create Database
createDatabase() async {
  database = await openDatabase(
    "Database.db",
    version: 2,
    onCreate: (Database db, int version) {
      if (kDebugMode) {
        print("Database created");
      }
      db.execute(
        "CREATE TABLE TASKS(id INTEGER PRIMARY KEY, title TEXT, description TEXT, date TEXT, status TEXT)",
      ).then((onValue){
        if (kDebugMode) {
          print("Table created");
        }
      });
    },
    onOpen: (Database db){
      if (kDebugMode) {
        print("Database opened");
      }
    }
  );
}

/// Insert DataBase
insertIntoDatabase(DatabaseModel task){
  database!.rawInsert("INSERT INTO TASKS(title, description, date , status) VALUES('${task.title}', '${task.description}', '${task.date}', 'News')").then((onValue){
    if (kDebugMode) {
      print("$onValue Inserted Successfully");
    }
  });
}

/// GetDataBase
Future<List<Map<String, dynamic>>> getDatabase() async {
  final onValue = await database!.rawQuery('SELECT * FROM TASKS');
  if (kDebugMode) {
    print("$onValue Get Successfully");
  }
  return onValue;
}
