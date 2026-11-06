import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const String _keyCurrentStudent = "scienceQuestStudent";
  static const String _keyResults = "scienceQuestResults";
  static const String _keyAdmin = "scienceQuestAdmin";

  static String _profileKey(String name) {
    final safe = name.trim().toLowerCase();
    return "scienceQuestProfile_$safe";
  }

  static String _gamificationKey(String name) {
    final safe = name.trim().toLowerCase();
    return "scienceQuestGamification_$safe";
  }

  // Load active student name
  static Future<String?> getCurrentStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentStudent);
  }

  // Save active student name
  static Future<void> setCurrentStudentName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentStudent, name);
  }

  // Load student profile
  static Future<StudentProfile> loadStudentProfile(String name) async {
    if (name.isEmpty) {
      return StudentProfile(name: "");
    }
    final prefs = await SharedPreferences.getInstance();
    final rawProfile = prefs.getString(_profileKey(name));
    final rawGami = prefs.getString(_gamificationKey(name));

    StudentProfile profile = StudentProfile(name: name);

    if (rawProfile != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(rawProfile);
        profile = StudentProfile.fromJson(data);
      } catch (_) {}
    }

    if (rawGami != null) {
      try {
        final Map<String, dynamic> gami = jsonDecode(rawGami);
        profile.xp = (gami['xp'] as num?)?.toInt() ?? profile.xp;
        profile.level = (gami['level'] as num?)?.toInt() ?? profile.level;
        profile.totalPoints = (gami['totalPoints'] as num?)?.toInt() ?? profile.totalPoints;
        // 'bonusRewards' is silently ignored if present in old save data
      } catch (_) {}
    }

    return profile;
  }

  // Save student profile
  static Future<void> saveStudentProfile(StudentProfile profile) async {
    if (profile.name.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyCurrentStudent, profile.name);
    await prefs.setString(_profileKey(profile.name), jsonEncode(profile.toJson()));
    await prefs.setString(_gamificationKey(profile.name), jsonEncode({
      'xp': profile.xp,
      'level': profile.level,
      'totalPoints': profile.totalPoints,
    }));
  }

  // Load all quiz results
  static Future<List<QuizResult>> getQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyResults);
    if (raw == null) return [];
    try {
      final List list = jsonDecode(raw);
      return list.map((e) => QuizResult.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (_) {
      return [];
    }
  }

  // Save a quiz result
  static Future<void> saveQuizResult(QuizResult result) async {
    final results = await getQuizResults();
    results.add(result);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyResults, jsonEncode(results.map((r) => r.toJson()).toList()));
  }

  // Clear all quiz results
  static Future<void> clearAllQuizResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyResults);
  }

  // Admin login check
  static Future<bool> isAdminLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAdmin) ?? false;
  }

  static Future<void> setAdminLoggedIn(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAdmin, loggedIn);
  }

  static const String _keyTermUnlockConfig = "scienceQuestTermUnlockConfig";

  // Load configurable term unlock settings
  static Future<TermUnlockConfig> getTermUnlockConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyTermUnlockConfig);
    if (raw == null) {
      return TermUnlockConfig.defaultConfig();
    }
    try {
      final Map<String, dynamic> data = jsonDecode(raw);
      return TermUnlockConfig.fromJson(data);
    } catch (_) {
      return TermUnlockConfig.defaultConfig();
    }
  }

  // Save configurable term unlock settings
  static Future<void> saveTermUnlockConfig(TermUnlockConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTermUnlockConfig, jsonEncode(config.toJson()));
  }
}
