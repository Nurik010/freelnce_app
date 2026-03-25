import 'package:flutter/material.dart';
import 'package:my_diary_app/freelance_list.dart';
import 'package:my_diary_app/preferences.dart';
import 'package:my_diary_app/screens/work_detail_screen.dart';
import 'package:my_diary_app/widgets/card_work.dart';

class ListWork extends StatefulWidget {
  const ListWork({super.key});

  @override
  State<ListWork> createState() => _ListWorkState();
}

class _ListWorkState extends State<ListWork> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: freelance.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(freelance[index].title),
            onDismissed: (direction) {
              setState(() {
                freelance.removeAt(index);
              });
            },
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Подтверждение'),
                    content: Text(
                      'Удалить запись "${freelance[index].title}"?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Удалить'),
                      ),
                    ],
                  );
                },
              );
            },
            child: InkWell(
              onTap: () async {
                final deleted_work = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WorkDetailScreen(freelance_detail: freelance[index]),
                  ),
                );
                if (deleted_work != null) {
                  setState(() {
                    freelance.remove(deleted_work);
                  });
                  await StorageService.saveAll();
                  
                }
              },
              child: CardWork(index: index,),
            ),
          );
        },
      );
  }
}