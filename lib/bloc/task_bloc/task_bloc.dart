import 'package:bloc/bloc.dart';
import 'package:freelance_app/bloc/task_bloc/task_event.dart';
import 'package:freelance_app/bloc/task_bloc/task_state.dart';
import 'package:freelance_app/models/task_model.dart';
import 'package:freelance_app/repositories/local_storage.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final LocalStorage storage;

  TaskBloc(this.storage) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadMyTasksEvent>(_onLoadMyTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      var tasks = await storage.getTask();
      if (event.category != 'Все') {
        tasks = tasks.where((t) => t.category == event.category).toList();
      }
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onLoadMyTasks(
    LoadMyTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final user = await storage.getCurrentUser();
      var tasks = await storage.getTask();
      if (user != null) {
        tasks = tasks
            .where(
              (t) => t.customerID == user.id || t.status != TaskStatus.open,
            )
            .toList();
      }
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await storage.getTask();
      final updatedTasks = List<Task>.from(tasks)..add(event.task);
      await storage.saveTask(updatedTasks);
      emit(TaskCreated());
      emit(TasksLoaded(updatedTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await storage.getTask();
      final index = tasks.indexWhere((t) => t.id == event.task.id);
      if (index != -1) {
        tasks[index] = event.task;
        await storage.saveTask(tasks);
      }
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await storage.getTask();
      tasks.removeWhere((t) => t.id == event.taskId);
      await storage.saveTask(tasks);
      emit(TasksLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
