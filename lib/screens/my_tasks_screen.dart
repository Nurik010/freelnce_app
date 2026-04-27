import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_state.dart';
import 'package:freelance_app/bloc/task_bloc/task_bloc.dart';
import 'package:freelance_app/bloc/task_bloc/task_event.dart';
import 'package:freelance_app/bloc/task_bloc/task_state.dart';
import 'package:freelance_app/models/task_model.dart';
import 'package:freelance_app/screens/task_detal_screen.dart';
import 'package:freelance_app/widgets/task_card.dart';

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои задания'), centerTitle: true,),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: Text('Войдите в систему'));
          }

          return BlocBuilder<TaskBloc, TaskState>(
            builder: (context, taskState) {
              if (taskState is TaskInitial) {
                context.read<TaskBloc>().add(LoadMyTasksEvent());
                return const Center(child: CircularProgressIndicator());
              }

              if (taskState is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (taskState is TasksLoaded) {
                final user = authState.user;
                final myTasks = taskState.tasks.where((task) {
                  if (user.isCustomer) {
                    return task.customerID == user.id;
                  } else {
                    return task.status != TaskStatus.open;
                  }
                }).toList();

                if (myTasks.isEmpty) {
                  return const Center(child: Text('У вас пока нет заданий'));
                }

                return ListView.builder(
                  itemCount: myTasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      task: myTasks[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TaskDetalScreen(task: myTasks[index]),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
