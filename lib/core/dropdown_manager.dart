import 'package:shared_preferences/shared_preferences.dart';

class DropdownManager {
  static Future<List<String>> getValues(String key, List<String> defaults) async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(key);

    if (values == null) {
      await prefs.setStringList(key, defaults);
      return defaults;
    }
    print('hahaha');
    print(values);
    return values;
  }

  static Future<void> saveValues(String key, List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values);
  }

  static Future<void> addValue(String key, String newValue) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> values = prefs.getStringList(key) ?? [];
    if (!values.contains(newValue)) {
      values.insert(0, newValue);
      await prefs.setStringList(key, values);
    }
  }
  static Future<void> removeValue(String key, String valueToRemove) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> values = prefs.getStringList(key) ?? [];
    values.remove(valueToRemove);

    await prefs.setStringList(key, values);
  }

}

class DropdownKeys {
  static const subjectType = "Type";
  static const injurySeverity = "Severity";
  static const commonInjuryType = "Common Injury Type";
  static const dispositionsList = "Disposition & Notifications";
  static const commonIllnessType = "Common Illness Type";
  static const immediateTreatments = "Immediate Treatments";
}
