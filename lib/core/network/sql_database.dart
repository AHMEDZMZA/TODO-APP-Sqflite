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
    version: 4,
    onCreate: (Database db, int version) {
      if (kDebugMode) {
        print("Database created");
      }
      db.execute(
        "CREATE TABLE TASKS(id INTEGER PRIMARY KEY, title TEXT, description TEXT, dateTime TEXT, date TEXT, image TEXT , status TEXT)",
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
  database!.rawInsert("INSERT INTO TASKS(title, description, dateTime , date , image , status) VALUES('${task.title}', '${task.description}', '${task.dateTime}' ,'${task.date}', '${task.image}' , 'News')").then((onValue){
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


deleteDatabase( int? id ){
  database!.rawDelete("DELETE FROM TASKS WHERE id = $id").then((onValue) {
    if (kDebugMode) {
      print("$onValue Deleted Successfully");
    }
  }
  );
}

editDatabase(DatabaseModel task) {
  database!.rawUpdate("UPDATE TASKS SET title = '${task.title}', description = '${task.description}', dateTime = '${task.dateTime}', date = '${task.date}', image = '${task.image}' WHERE id = '${task.id}'").then((onValue) {
    if (kDebugMode) {
      print("$onValue Deleted Successfully");
    }
  }
  );
}
