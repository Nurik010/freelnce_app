import 'package:flutter/material.dart';
import 'package:freelance_app/screens/my_bids_screen.dart';
import 'package:freelance_app/screens/my_tasks_screen.dart';
import 'package:freelance_app/screens/profile_screen.dart';
import 'package:freelance_app/screens/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int index = 0;
  final screens = [
    TasksScreen(),
    MyTasksScreen(),
    MyBidsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Задания'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Мои задания'),
          BottomNavigationBarItem(icon: Icon(Icons.gavel), label: 'Ставки'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Профиль'),
        ]
        ),
    );
  }
}
