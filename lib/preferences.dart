import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:freelance_app/freelance_list.dart';
import 'package:freelance_app/freelance_model.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static const String _themKey = 'theme_mode';
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Сохранить все записи
  static Future<void> saveAll() async {
    if (_prefs == null) await init();
    
    List<String> jsonList = freelance.map((work) {
      Map<String, dynamic> map = {
        'title': work.title,
        'salary': work.salary,
        'preview': work.preview,
        'deadline': work.deadline,
        'hardlevel': work.hardlevel,
      };
      return jsonEncode(map);
    }).toList();
    
    await _prefs!.setStringList('freelance_data', jsonList);

  }
  

  static Future<void> loadAll() async {
    if (_prefs == null) await init();
    
    List<String>? jsonList = _prefs!.getStringList('freelance_data');
    
    if (jsonList != null && jsonList.isNotEmpty) {
      freelance.clear();
      
      for (String json in jsonList) {
        Map<String, dynamic> map = jsonDecode(json);
        freelance.add(Freelance(
          map['title'],
          map['salary'],
          map['preview'],
          map['deadline'],
          map['hardlevel'],
        ));
      }
      
      print('Загружено ${freelance.length} записей');
    } else {
      print('Нет сохранённых данных, используем начальные');
    }
  }

  static Future<void> saveThemMode(bool isDarkThem) async{
    if (_prefs == null) await init();
    await _prefs!.setBool(_themKey, isDarkThem);
  }
  
  static Future<bool> loadThemMode() async {
    if (_prefs == null) await init();
    bool? isDarkThem = await _prefs!.getBool(_themKey);
    return isDarkThem ?? false;
  }

}