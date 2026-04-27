import 'package:freelance_app/models/user_model.dart';

abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final User user;
  RegisterEvent(this.user);
}

class LoginEvent extends AuthEvent {
  final String email;
  LoginEvent(this.email);
}

class LogoutEvent extends AuthEvent{}

class UpdateUserEvent extends AuthEvent {
  final User user;

  UpdateUserEvent(this.user);
}

