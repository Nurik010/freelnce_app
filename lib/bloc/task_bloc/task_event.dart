import 'package:freelance_app/models/task_model.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent{
  final String category;

  LoadTasksEvent(this.category);
}

class LoadMyTasksEvent extends TaskEvent{}

class CreateTaskEvent extends TaskEvent {
  final Task task;

  CreateTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);

}