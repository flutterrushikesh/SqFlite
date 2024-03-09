import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

dynamic database;

class EmployeeData {
  int empId;
  double sal;
  String name;

  EmployeeData({required this.empId, required this.sal, required this.name});
}

void main() async {
  runApp(const MyApp());

  database = openDatabase(
    join(await getDatabasesPath(), "EmployeeDB.db"),
    version: 1,
    onCreate: (db, version) {
      db.execute('''CREATE TABLE Employee (
      empId INT PRIMARY KEY,
      eName TEXT,
      sal REAL 
      )''');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Hello world"),
        ),
      ),
    );
  }
}
