import 'package:flutter/material.dart';

import 'package:my_diary_app/freelance_model.dart';
import 'package:my_diary_app/freelance_list.dart';
import 'package:my_diary_app/preferences.dart';
import 'package:my_diary_app/widgets/list_work.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Фриланс биржа'),
        centerTitle: true,
      ),
      body: ListWork(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialWind(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewWork(
    String title,
    String salary,
    String content,
    String deadline,
    String hardlevel,
  ) async{
    setState(() {
      freelance.add(Freelance(title, salary, content, deadline, hardlevel));
    });
    await StorageService.saveAll();
  }

  void dialWind(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController salaryController = TextEditingController();
        TextEditingController previewController = TextEditingController();
        TextEditingController deadlineController = TextEditingController();
        TextEditingController hardlevelController = TextEditingController();

        return AlertDialog(
          title: Text('Новая запись'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Заголовок"),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(hintText: "Оплата"),
              ),
              TextField(
                controller: previewController,
                decoration: InputDecoration(hintText: "Содержание"),
              ),
              TextField(
                controller: deadlineController,
                decoration: InputDecoration(hintText: "Дедлайн"),
              ),
              TextField(
                controller: hardlevelController,
                decoration: InputDecoration(hintText: "Уровень сложности 1-5"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                _addNewWork(
                  titleController.text,
                  salaryController.text,
                  previewController.text,
                  deadlineController.text,
                  hardlevelController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}
