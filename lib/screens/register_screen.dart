import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_event.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_state.dart';
import 'package:freelance_app/models/user_model.dart';
import 'package:freelance_app/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  String _role = '';
  final RegExp _regEmail = RegExp(r'^[a-zA-Z0-9._%+]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  final List<String> _skills = [];
  final List<String> _availableSkills = [
    'Flutter',
    'Android',
    'Python',
    'Java',
    'Figma',
    'Photoshop',
    'Sound Design',
  ];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Фриланс биржа'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Регистрация',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: 'Имя'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите email';
                  }
                  if (!_regEmail.hasMatch(value)) {
                    return 'Введите корректный email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите пароль';
                  }
                  if (value.length < 6) {
                    return 'Пароль должен содержать от 6 символов ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Роль:', style: TextStyle(fontSize: 18)),
              RadioListTile<String>(
                title: Text('Исполнитель'),
                value: 'executor',
                groupValue: _role,
                onChanged: (value) => setState(() {
                  _role = value!;
                }),
                activeColor: Colors.blue,
              ),
              RadioListTile<String>(
                title: Text('Заказчик'),
                value: 'customer',
                groupValue: _role,
                onChanged: (value) => setState(() {
                  _role = value!;
                }),
                activeColor: Colors.blue,
              ),
              SizedBox(height: 20),
              if (_role == 'executor') ...[
                Text('Навыки'),
                ..._availableSkills.map(
                  (skill) => CheckboxListTile(
                    title: Text(skill),
                    value: _skills.contains(skill),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _skills.add(skill);
                        } else {
                          _skills.remove(skill);
                        }
                      });
                    },
                  ),
                ),
              ],
              SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state){
                  if (state is AuthAuthenticated){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (_) => MainScreen()
                      ));
                  }
                  if(state is AuthError){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is AuthLoading ? null : _register, 
                    child: state is AuthLoading ? CircularProgressIndicator() : Text('Зарегистрироваться')
                    );
                },
                )
            ],
          ),
        ),
      ),
    );
  }

  void _register (){
    if(_formKey.currentState!.validate()){
      if(_role == 'executor' && _skills.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Выберите навык(и)')));
      return;
      }
        final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name.text,
        email: _email.text,
        role: _role,
        skills: _skills,
      );
      
      context.read<AuthBloc>().add(RegisterEvent(user));

    } 
  }
}
