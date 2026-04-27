import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_state.dart';
import 'package:freelance_app/bloc/task_bloc/task_bloc.dart';
import 'package:freelance_app/bloc/task_bloc/task_event.dart';
import 'package:freelance_app/bloc/task_bloc/task_state.dart';
import 'package:freelance_app/models/category_model.dart';
import 'package:freelance_app/models/task_model.dart';
import 'package:freelance_app/screens/main_screen.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgeteController = TextEditingController();
  String _selectedCategory = '';
  DateTime _deadline = DateTime.now().add(Duration(days: 7));
  RegExp _regFinance = RegExp(r'^[0-9]+$');

  @override
  void initState() {
    super.initState();
    if (TaskCategory.categories.isNotEmpty) {
      _selectedCategory = TaskCategory.categories.first.name;
    } else {
      _selectedCategory = 'Программирование'; // Значение по умолчанию
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _budgeteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать задание'), centerTitle: true,
        leading: IconButton(
          onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
              );
            },
          icon: Icon(Icons.arrow_back),
        ),),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Введите название' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Введите описание' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _budgeteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Бюджет',
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Введите бюджет';
                }
                if (value.length > 7 || !_regFinance.hasMatch(value)) {
                  return 'Введите корректный бюджет';
                }
                  },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(label: Text('Выберите категорию')),
              items: TaskCategory.categories.map((v) {
                return DropdownMenuItem(
                  value: v.name,
                  child: Row(
                    children: [Icon(v.icon), SizedBox(width: 10), Text(v.name)],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() {
                _selectedCategory = v!;
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Выберите категорию';
                }
                return null;
              },
            ),
            ListTile(
              title: Text('Срок выполнения'),
              trailing: Icon(Icons.calendar_month),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _deadline = date;
                  });
                }
              },
            ),
            SizedBox(height: 10),
            BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is TaskCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Задание опубликовано')),
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
                }
                if (state is TaskError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () => state is TaskLoading ? null : _createTask(),
                  child: state is TaskLoading
                      ? const CircularProgressIndicator()
                      : const Text('Опубликовать'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createTask() {
    if (!_formKey.currentState!.validate()) return;
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      budget: double.parse(_budgeteController.text),
      deadline: _deadline,
      category: _selectedCategory,
      customerID: authState.user.id,
      customerName: authState.user.name,
      status: TaskStatus.open,
      createdAt: DateTime.now(),
    );
   
    context.read<TaskBloc>().add(CreateTaskEvent(task));

  }
}
