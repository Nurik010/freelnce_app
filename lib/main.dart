import 'package:flutter/material.dart';
import 'package:freelance_app/preferences.dart';
import 'package:freelance_app/provider_theme.dart';
import 'package:freelance_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await StorageService.loadAll();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProviderTheme(),
      child: Consumer<ProviderTheme>(
        builder: (context, themeProvide, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Фриланс биржа',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            useMaterial3: true
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            useMaterial3: true
          ),
          themeMode: themeProvide.themeMode,
          home: HomeScreen(),
          );
        }
        ),
       );
  }
}

