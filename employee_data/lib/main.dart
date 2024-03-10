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
      'empId': empId,
      'sal': sal,
      'eName': name,
    });
  }
}

Future<void> insertEmpData(EmployeeData emp) async {
  final localDB = await database;
  localDB.insert(
    'Employee',
    emp.empData(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> getEmpData() async {
  final localDB = await database;
  List<Map<String, dynamic>> empEntry = await localDB.query("Employee");
  return empEntry;
}

Future<void> deleteEmpData(EmployeeData emp) async {
  final localDB = await database;
  await localDB.delete(
    "Employee",
    where: "empId = ?",
    whereArgs: [emp.empId],
  );
}

void main() async {
  runApp(const MyApp());

  database = openDatabase(
    join(await getDatabasesPath(), "EmployeeDB.db"),
    version: 1,
    onCreate: (db, version) {
      db.execute('''CREATE TABLE Employee (
      empId INT PRIMARY KEY,
      sal REAL 
      eName TEXT,
      
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

  List retData = await getEmpData();
  for (int i = 0; i < retData.length; i++) {
    print(retData[i]);
  }

  await deleteEmpData(emp1);
  await deleteEmpData(emp4);
  await deleteEmpData(emp5);

  print("After delete");
  retData = await getEmpData();
  for (int i = 0; i < retData.length; i++) {
    print(retData[i]);
  }

  EmployeeData emp8 = EmployeeData(empId: 59, sal: 2.5, name: "Suresh");
  insertEmpData(emp8);
  print("update entry");
  retData = await getEmpData();
  for (int i = 0; i < retData.length; i++) {
    print(retData[i]);
  }

  EmployeeData emp9 = EmployeeData(empId: 98, sal: 4.2, name: "Rupesh");
  insertEmpData(emp9);
  print("New entry");
  retData = await getEmpData();
  for (int i = 0; i < retData.length; i++) {
    print(retData[i]);
  }
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
