import 'package:flutter/material.dart';
import 'package:freelance_app/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  
  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${task.budget.toStringAsFixed(0)} ₽'),
                const SizedBox(width: 12),
                Text('${task.deadline.day}.${task.deadline.month}'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(task.category, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
        trailing: _buildStatusChip(),
      ),
    );
  }
  
  Widget _buildStatusChip() {
    Color color;
    switch (task.status) {
      case TaskStatus.open: color = Colors.green; break;
      case TaskStatus.inProgress: color = Colors.orange; break;
      case TaskStatus.completed: color = Colors.blue; break;
      case TaskStatus.cancelled: color = Colors.red; break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(task.statusDisplay, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}