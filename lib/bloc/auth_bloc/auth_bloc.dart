import 'package:bloc/bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_event.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_state.dart';
import 'package:freelance_app/models/user_model.dart';
import 'package:freelance_app/repositories/local_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalStorage storage;

  AuthBloc(this.storage) : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<UpdateUserEvent>(_onUpdate);
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = await storage.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await storage.saveCurrentUser(event.user);
    emit(AuthAuthenticated(event.user));
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = User(
        id: '1',
        name: 'Тестовый пользователь',
        email: event.email,
        role: 'executor',
        skills: ['Flutter'],
      );
      await storage.saveCurrentUser(user);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await storage.clearCurrentUser();
    emit(AuthUnauthenticated());
  }

    Future<void> _onUpdate(UpdateUserEvent event, Emitter<AuthState> emit) async {
    await storage.saveCurrentUser(event.user);
    emit(AuthAuthenticated(event.user));
  }

}
