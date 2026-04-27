import 'package:freelance_app/models/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState{}

class TaskLoading extends TaskState{}

class TasksLoaded extends TaskState {
  final List<Task> tasks;

  TasksLoaded(this.tasks);
}

class TaskCreated extends TaskState {}

class TaskUpdated extends TaskState{}

class TaskDeleted extends TaskState{}

class TaskError extends TaskState{
  final String message;

  TaskError(this.message);
}