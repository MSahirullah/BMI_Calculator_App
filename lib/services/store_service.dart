import 'package:shared_preferences/shared_preferences.dart';

class StoreServices {
  final SharedPreferences sharedPreferences;

  StoreServices({required this.sharedPreferences});

  bool saveData(type, key, value) {
    // Obtain shared preferences.

    try {
      if (type == 'str') {
        sharedPreferences.setString(key, value);
      }
      else if (type == 'list'){
        sharedPreferences.setStringList(key, value);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  dynamic retriveData(type, key) {
    try {
      if (type == 'str') {
        return sharedPreferences.getString(key);
      } else if(type == 'list') {
        return sharedPreferences.getStringList(key);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
