import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

dynamic database;

class EmployeeData {
  int empId;
  double sal;
  String name;

  EmployeeData({required this.empId, required this.sal, required this.name});

  Map<String, dynamic> empData() {
    return ({
      'name': name,
      'empID': empId,
      'empSal': sal,
    });
  }
}

Future<void> insertEmpData(EmployeeData emp) async {
  final localDB = await database;
  localDB.inset(
    'Employee',
    emp.empData(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> getEmpData() async {
  final localDB = await database;
  List<Map<String, dynamic>> empEntry = localDB.query("Employee");
  return empEntry;
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

  EmployeeData emp1 = EmployeeData(empId: 12, sal: 2.3, name: "Rushikesh");
  insertEmpData(emp1);

  EmployeeData emp2 = EmployeeData(empId: 18, sal: 2.1, name: "Sangam");
  insertEmpData(emp2);

  EmployeeData emp3 = EmployeeData(empId: 15, sal: 2.9, name: "Rohan");
  insertEmpData(emp3);

  EmployeeData emp4 = EmployeeData(empId: 42, sal: 1.4, name: "Pruthviraj");
  insertEmpData(emp4);

  EmployeeData emp5 = EmployeeData(empId: 32, sal: 3.1, name: "Yogesh");
  insertEmpData(emp5);

  print(getEmpData());
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
