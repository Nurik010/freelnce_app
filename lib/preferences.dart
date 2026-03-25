import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:my_diary_app/freelance_list.dart';
import 'package:my_diary_app/freelance_model.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  // Инициализация (вызвать в main.dart)
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
    print('Сохранено ${jsonList.length} записей'); // для отладки
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
      
      print('Загружено ${freelance.length} записей'); // для отладки
    } else {
      // Если данных нет, оставляем начальные
      print('Нет сохранённых данных, используем начальные');
    }
  }
  
  // Очистить все данные
  static Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.remove('freelance_data');
    freelance.clear();
    print('Все данные удалены');
  }
  
  // Проверить, есть ли сохранённые данные
  static Future<bool> hasData() async {
    if (_prefs == null) await init();
    List<String>? data = _prefs!.getStringList('freelance_data');
    return data != null && data.isNotEmpty;
  }
}