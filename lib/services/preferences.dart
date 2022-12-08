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

  static Future setGenderAndDoB(String gender, String dob) async {
    await _preferences.setString("gender", gender);
    await _preferences.setString("dob", dob);
  }

  static String? getUsername() => _preferences.getString("name");
  static String? getProfile() => _preferences.getString("profile");
  static String? getGender() => _preferences.getString("gender");
  static String? getDOB() => _preferences.getString("dob");

  static Future setBMIData(String height, String weight) async {
    await _preferences.setString("height", height);
    await _preferences.setString("weight", weight);
  }

  static String? getHeight() => _preferences.getString("height");
  static String? getWeight() => _preferences.getString("weight");

  static Future setSettingsData(String minHeight, String maxHeight,
      String minWeight, String maxWeight) async {
    await _preferences.setString("minHeight", minHeight);
    await _preferences.setString("maxHeight", maxHeight);
    await _preferences.setString("minWeight", minWeight);
    await _preferences.setString("maxWeight", maxWeight);
  }

  static String? getMinHeight() => _preferences.getString("minHeight");
  static String? getMaxHeight() => _preferences.getString("maxHeight");
  static String? getMinWeight() => _preferences.getString("minWeight");
  static String? getMaxWeight() => _preferences.getString("maxWeight");
}
