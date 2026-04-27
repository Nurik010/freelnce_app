import 'dart:convert';

import 'package:freelance_app/models/bid_model.dart';
import 'package:freelance_app/models/task_model.dart';
import 'package:freelance_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalStorage {
  final SharedPreferences prefs;
  static const String CURRENT_USER_KEY = 'current_user';
  static const String CURRENT_TASKS_KEY = 'current_tasks';
  static const String CURRENT_BIDS_KEY = 'current_bids';

  LocalStorage({required this.prefs});

  Future<void> saveCurrentUser(User user) async{
    await prefs.setString(CURRENT_USER_KEY, jsonEncode(user.toJson()));
  }

  Future<User?> getCurrentUser() async{
    final jsonUser = await prefs.getString(CURRENT_USER_KEY);
    return jsonUser != null ? User.fromJson(jsonDecode(jsonUser)) : null;
  }

  Future<void> clearCurrentUser() async{
    await prefs.remove(CURRENT_USER_KEY);
  }

  Future<void> saveTask(List<Task> tasks) async{
    final jsonList = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(CURRENT_TASKS_KEY, jsonList);
  }

  Future<List<Task>> getTask() async{
    final json = prefs.getString(CURRENT_TASKS_KEY);
    if (json == null) return [];
    final List<dynamic> list = jsonDecode(json);
    return list.map((e) => Task.fromJson(e)).toList();
  }

  Future<void> saveBids(List<Bid> bids) async{
    final jsonList = jsonEncode(bids.map((b) => b.toJson()).toList());
    await prefs.setString(CURRENT_BIDS_KEY, jsonList);
  }

  Future<List<Bid>> getBids() async{
    final json = prefs.getString(CURRENT_BIDS_KEY);
    if (json == null) return [];
    final List<dynamic> list = jsonDecode(json);
    return list.map((e) => Bid.fromJson(e)).toList();
  }
}