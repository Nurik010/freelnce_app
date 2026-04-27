import 'package:flutter/material.dart';

class TaskCategory {
  final String id;
  final String name;
  final IconData icon;
  
  TaskCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
  
  static final List<TaskCategory> categories = [
    TaskCategory(id: 'dev', name: 'Разработка', icon: Icons.code),
    TaskCategory(id: 'design', name: 'Дизайн', icon: Icons.brush),
    TaskCategory(id: 'marketing', name: 'Маркетинг', icon: Icons.trending_up),
    TaskCategory(id: 'sound', name: 'Обработка звука', icon: Icons.music_note),
    TaskCategory(id: 'translate', name: 'Переводы', icon: Icons.language),
  ];
}