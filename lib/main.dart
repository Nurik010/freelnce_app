import 'package:flutter/material.dart';
import 'package:my_diary_app/preferences.dart';
import 'package:my_diary_app/screens/home_screen.dart';

void main() async {
  await StorageService.init;
  await StorageService.loadAll;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Мой дневник',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

