import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_event.dart';
import 'package:freelance_app/bloc/bid_bloc/bid_bloc.dart';
import 'package:freelance_app/bloc/task_bloc/task_bloc.dart';
import 'package:freelance_app/repositories/local_storage.dart';
import 'package:freelance_app/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorage(prefs: prefs);
  
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final LocalStorage storage;
  
  const MyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(storage)..add(CheckAuthEvent())),
        BlocProvider(create: (_) => TaskBloc(storage)),
        BlocProvider(create: (_) => BidBloc(storage)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Фриланс Биржа',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}