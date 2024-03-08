// import 'package:demo_player/referance.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

dynamic database;

class PlayerData {
  final String name;
  final int jerNo;
  final int runs;
  final double avg;

  PlayerData(
      {required this.name,
      required this.jerNo,
      required this.runs,
      required this.avg});

  //method for add data in database
  Map<String, dynamic> addPlayerData() {
    return {
      'name': name,
      'jerNo': jerNo,
      'runs': runs,
      'avg': avg,
    };
  }

  @override
  String toString() {
    return '{name:$name,jerNo:$jerNo,runs:$runs,avg:$avg}';
  }
}

Future insertData(PlayerData obj) async {
  final localDB = await database;
  await localDB.insert(
    "Player",
    obj.addPlayerData(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future getData() async {
  final localDB = await database;
  List<Map<String, dynamic>> playerList = await localDB.query("Player");
  return List.generate(
    playerList.length,
    (i) {
      return PlayerData(
        name: playerList[i]['name'],
        jerNo: playerList[i]['jerNo'],
        runs: playerList[i]['runs'],
        avg: playerList[i]['avg'],
      );
    },
  );
  // await localDB
}

void main() async {
  runApp(const MainApp());

  database = openDatabase(
    join(await getDatabasesPath(), "PlayerDB.db"),
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''CREATE TABLE Player(
          name TEXT,
          jerNo INTEGER PRIMARY KEY,
          runs INT,
          avg REAL,) ''');
    },
  );
  //insert player data into table using object key value.
  //player 1
  PlayerData player1 = PlayerData(
    name: "Rohit",
    jerNo: 45,
    runs: 5600,
    avg: 44.5,
  );
  await insertData(player1);

  //player2
  PlayerData player2 = PlayerData(
    name: "Virat Kohli",
    jerNo: 18,
    runs: 14000,
    avg: 60.3,
  );
  await insertData(player2);

  //palyer3
  PlayerData player3 = PlayerData(
    name: "Shubaman gill ",
    jerNo: 77,
    runs: 6000,
    avg: 20.14,
  );
  await insertData(player3);

  //print data on console
  print(await getData());
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
