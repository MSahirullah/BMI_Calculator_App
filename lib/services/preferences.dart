import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserData(
      String name, String profile, String gender, String dob) async {
    await _preferences.setString("name", name);
    await _preferences.setString("profile", profile);
    await _preferences.setString("gender", gender);
    await _preferences.setString("dob", dob);

    
  }

  static String? getUsername() {
    return _preferences.getString("name");
  }

  static String? getProfile() {
    return _preferences.getString("profile");
  }

  static String? getGender() {
    return _preferences.getString("gender");
  }

  static String? getDOB() {
    return _preferences.getString("dob");
  }

  static Future setBMIData(String height, String weight)async {
    await _preferences.setString("height", height);
    await _preferences.setString("weight", weight);
  }

    static String? getHeight() {
    return _preferences.getString("height");
  }

    static String? getWeight() {
    return _preferences.getString("weight");
  }
}
