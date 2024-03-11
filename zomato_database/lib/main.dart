import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Zomato {
  final int orderNo;
  final String custName;
  final String hotelName;
  final String food;
  final double bill;

  Zomato({
    required this.orderNo,
    required this.custName,
    required this.hotelName,
    required this.food,
    required this.bill,
  });

  //map method
  Map<String, dynamic> zomatoEntry() {
    return {
      'orderNo': orderNo,
      'custName': custName,
      'hotelName': hotelName,
      'food': food,
      'bill': bill,
    };
  }

  @override
  String toString() {
    return '{orderNo: $orderNo, custName: $custName, hotelName: $hotelName, food: $food, bill: $bill, }';
  }
}

dynamic database;

//insert method
Future<void> insertZomatoData(Zomato obj) async {
  final localDB = await database;

  await localDB.insert(
    'Zomato',
    obj.zomatoEntry(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//retrive data
Future<List<Map<String, dynamic>>> retriveData() async {
  final localDB = await database;

  List<Map<String, dynamic>> retData = await localDB.query('Zomato');
  return retData;
}

//delete order data
Future<void> deleteOrderData(Zomato obj) async {
  final localDB = await database;

  await localDB.delete(
    'Zomato',
    where: 'orderNo=?',
    whereArgs: [obj.orderNo],
  );
}

//update order data
Future<void> updateOrderData(Zomato obj) async {
  final localDB = await database;

  await localDB.update(
    'Zomato',
    obj.zomatoEntry(),
    where: 'orderNo=?',
    whereArgs: [obj.orderNo],
  );
}

void main() async {
  runApp(const MainApp());
  database = openDatabase(
    join(await getDatabasesPath(), "Zomato2DB. db"),
    version: 1,
    onCreate: (db, version) {
      db.execute('''
        CREATE TABLE Zomato(
          orderNo INT PRIMARY KEY,
          custName TEXT,
          hotelName TEXT,
          food TEXT,
          bill REAL)
        ''');
    },
  );

  Zomato order1 = Zomato(
    orderNo: 1,
    custName: "Rushikesh",
    hotelName: "Maratha",
    food: "Onion pizza",
    bill: 290.78,
  );

  // order 1
  insertZomatoData(order1);
  print("New orders");
  print(await retriveData());

  print("after added new entry");
  Zomato order2 = Zomato(
    orderNo: 2,
    custName: "Sangam",
    hotelName: "Dominos",
    food: "burger",
    bill: 110.78,
  );
  insertZomatoData(order2);

  print("3rd order");
  Zomato order3 = Zomato(
      orderNo: 3,
      custName: "Shirish",
      hotelName: "Burger king",
      food: "veg burger",
      bill: 90.21);
  insertZomatoData(order3);
  print(await retriveData());

  deleteOrderData(order1);
  print("After delete");

  print(await retriveData());

  order2 = Zomato(
    orderNo: order2.orderNo,
    custName: order2.custName,
    hotelName: order2.hotelName,
    food: order2.food,
    bill: order2.bill + 100,
  );

  updateOrderData(order2);

  print("After update order");

  print(await retriveData());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
