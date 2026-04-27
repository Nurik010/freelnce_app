import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/task_bloc/task_bloc.dart';
import 'package:freelance_app/bloc/task_bloc/task_event.dart';
import 'package:freelance_app/bloc/task_bloc/task_state.dart';
import 'package:freelance_app/models/category_model.dart';
import 'package:freelance_app/screens/add_task_screen.dart';
import 'package:freelance_app/screens/task_detal_screen.dart';
import 'package:freelance_app/widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedCategory = 'Все';

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasksEvent(_selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задания'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => AddTaskScreen()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          _categoryFilter(),
          Expanded(child: _buildTasksList())
        ],
      ),
    );
  }
  Widget _categoryFilter() {
    final categories = ['Все', ...TaskCategory.categories.map((e) => e.name)];
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index){
          final category = categories[index];
          final isSelected = categories[index] == category;
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
            child: FilterChip(
              label: Text(category), 
              selected: isSelected,
              onSelected: (_){
                setState(() => _selectedCategory = category);
                context.read<TaskBloc>().add(LoadTasksEvent(category));
              },
              ),
            );
        }
        ),
    );
  }
  Widget _buildTasksList(){
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state){
        if (state is TaskLoading){
          return CircularProgressIndicator();
        }
        if (state is TasksLoaded ){
          if (state.tasks.isEmpty){
            return Center(child: Text('Нет доступных заданий'),);
          }
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index){
              final task = state.tasks[index];
              return TaskCard(
                task: task,
                onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => TaskDetalScreen(task: task,)),
              );
                },
              );
            }
            );
        }
        if(state is TaskError){
          return Center(child: Text(state.message),);
        }
        return const SizedBox.shrink();
      }, 
      
      );
  }
}
