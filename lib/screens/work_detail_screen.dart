import 'package:flutter/material.dart';
import 'package:my_diary_app/freelance_model.dart';

class WorkDetailScreen extends StatefulWidget {
  Freelance freelance_detail;

  WorkDetailScreen({super.key, required this.freelance_detail});

  @override
  State<WorkDetailScreen> createState() => _EntyDetailScreenState();
}

class _EntyDetailScreenState extends State<WorkDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.freelance_detail.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.freelance_detail.preview,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
                Text(
                  'Выполнить до ${widget.freelance_detail.deadline}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10),
                Text(
                  'Оплата: ${widget.freelance_detail.salary} долларов',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'Сложность работы: ${widget.freelance_detail.hardlevel} ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, widget.freelance_detail);
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
