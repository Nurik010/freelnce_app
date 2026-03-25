import 'package:flutter/material.dart';
import 'package:my_diary_app/freelance_list.dart';

class CardWork extends StatelessWidget {
  int index;
  CardWork({super.key, required this.index});


  @override
  Widget build(BuildContext context) {
    return Card(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        freelance[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Оплата: ${freelance[index].salary} долларов',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Выполнить до ${freelance[index].deadline}',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        freelance[index].preview.length > 50
                            ? '${freelance[index].preview.substring(0, 50)}...'
                            : freelance[index].preview,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
  }
}