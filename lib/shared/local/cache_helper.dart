import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static SharedPreferences? prefs;

  static Future<bool> setUserId(String id) async{
    return await prefs!.setString("uid", id);
  }
  static String? getUserId(){
    return prefs!.getString("uid");
  }
  static void clearid(){
    prefs!.remove("uid");
  }
}