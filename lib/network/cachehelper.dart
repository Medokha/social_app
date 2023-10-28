import 'package:shared_preferences/shared_preferences.dart';

class cache_helper {
  static SharedPreferences? sharedPreferences ;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> putdata({required String key,required bool value}) async {
    return await sharedPreferences?.setBool(key, value);
  }
  static Future<bool?> getdata({required String key}) async {
    return await sharedPreferences?.getBool(key);
  }

  static Future<Object?> putid({required String key,required String value}) async {
    return await sharedPreferences?.setString(key, value);
  }
  static Future<Object?> getid({required String key}) async {
    return await sharedPreferences?.get(key);
  }
  static Future<Object?> deleteid() async {
    return await sharedPreferences?.clear();
  }
}