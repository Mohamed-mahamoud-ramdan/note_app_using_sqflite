import 'package:flutter/material.dart'; // Flutter material components
import 'package:sql_lite/helper/databse_helpter.dart';

import 'package:sql_lite/view/home_view.dart';

void main() {
  var var1 = DatabaseHelper.db;
  var var2 = DatabaseHelper.db;
  print("${var2.hashCode} hey");
  print(var1.hashCode);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
