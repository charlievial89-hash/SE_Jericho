import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class LevelUpNotification {
  final int oldLevel;
  final int newLevel;
  final int bonusCoins;
  final int bonusPoints;

  LevelUpNotification({
    required this.oldLevel,
    required this.newLevel,
    required this.bonusCoins,
    required this.bonusPoints,
  });
}

class QuizController extends ChangeNotifier {
  StudentProfile profile;

  GradeMission? selectedGrade;
  List<Question> quizQuestions = [];
  int questionIndex = 0;

  int lives = 3;
  int playerHP = 3;
  int score = 0;
  int correct = 0;
  int wrong = 0;
  int totalAnswered = 0;

  bool answered = false;
  int timer = 30;
  Timer? _timerTicker;

  bool battleEnded = false;
  bool resultSaved = false;
  DateTime? missionStartTime;

  String battleStage = "minion"; // "minion" or "boss"
  int enemyIndex = 0;
  int enemyHP = 1;
  int enemyMaxHP = 1;

  int? selectedAnswerIndex;
  bool lastAnswerWasCorrect = false;

  LevelUpNotification? pendingLevelUp;
  AchievementItem? pendingBadgeUnlocked;

  bool isLaserActive = false;
  bool isLaserWrong = false;

  QuizController({required this.profile});

  void updateProfile(StudentProfile newProfile) {
    profile = newProfile;
    notifyListeners();
  }

  void startQuiz(GradeMission grade) {
    _timerTicker?.cancel();
    selectedGrade = grade;

    // Fisher-Yates Shuffle algorithm for questions & choices
    final rng = Random();
    quizQuestions = grade.questions.map((q) {
      final shuffledOptions = List<String>.from(q.options);
      final correctValue = q.options[q.answer];

      // Shuffle options
      for (int i = shuffledOptions.length - 1; i > 0; i--) {
        int j = rng.nextInt(i + 1);
        var temp = shuffledOptions[i];
        shuffledOptions[i] = shuffledOptions[j];
        shuffledOptions[j] = temp;
      }
      int newCorrectIndex = shuffledOptions.indexOf(correctValue);

      return Question(
        q: q.q,
        options: shuffledOptions,
        answer: newCorrectIndex,
        explanation: q.explanation,
      );
    }).toList();

    // Shuffle questions sequence
    for (int i = quizQuestions.length - 1; i > 0; i--) {
      int j = rng.nextInt(i + 1);
      var temp = quizQuestions[i];
      quizQuestions[i] = quizQuestions[j];
      quizQuestions[j] = temp;
    }

    questionIndex = 0;
    lives = 3;
    playerHP = 3;
    score = 0;
    correct = 0;
    wrong = 0;
    totalAnswered = 0;
    answered = false;
    battleEnded = false;
    resultSaved = false;
    missionStartTime = DateTime.now();

    battleStage = "minion";
    enemyIndex = 0;
    enemyHP = 1;
    enemyMaxHP = 1;
    selectedAnswerIndex = null;

    loadQuestion();
  }

  void loadQuestion() {
    if (battleEnded) return;
    if (questionIndex >= quizQuestions.length) {
      victory();
      return;
    }

    answered = false;
    selectedAnswerIndex = null;
    timer = 30;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timerTicker?.cancel();
    _timerTicker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (battleEnded || answered) {
        t.cancel();
        return;
      }
      if (timer > 0) {
        timer--;
        notifyListeners();
      } else {
        t.cancel();
        if (!answered) {
          resolveAnswer(-1, isTimeout: true);
        }
      }
    });
  }

  void resolveAnswer(int index, {bool isTimeout = false}) {
    if (battleEnded || answered) return;
    answered = true;
    totalAnswered++;
    selectedAnswerIndex = index;
    _timerTicker?.cancel();

    final currentQ = quizQuestions[questionIndex];
    final bool isCorrect = !isTimeout && index == currentQ.answer;
    lastAnswerWasCorrect = isCorrect;

    // Laser Animation Trigger
    isLaserActive = true;
    isLaserWrong = !isCorrect;

    if (isCorrect) {
      correct++;
      score += 10;
      enemyHP = max(0, enemyHP - 1);
      addXP(20, 10);
    } else {
      wrong++;
      lives = max(0, lives - 1);
      playerHP = max(0, playerHP - 1);
      addXP(5, 0);
    }

    notifyListeners();

    // Reset laser trigger state after animation finishes
    Future.delayed(const Duration(milliseconds: 600), () {
      isLaserActive = false;
      notifyListeners();
    });

    // Advance battle after short delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      advanceBattle();
    });
  }

  void advanceBattle() {
    if (battleEnded) return;

    if (playerHP <= 0) {
      gameOver();
      return;
    }

    if (enemyHP <= 0) {
      if (questionIndex >= quizQuestions.length - 1) {
        victory();
        return;
      }

      if (questionIndex == 2) {
        battleStage = "boss";
        enemyHP = 2;
        enemyMaxHP = 2;
      } else {
        enemyIndex++;
        enemyHP = 1;
        enemyMaxHP = 1;
      }
    }

    if (questionIndex >= quizQuestions.length - 1) {
      victory();
      return;
    }

    questionIndex++;
    loadQuestion();
  }

  void victory() {
    if (battleEnded) return;
    battleEnded = true;
    _timerTicker?.cancel();

    final totalQ = quizQuestions.length;
    final accuracy = totalQ > 0 ? ((correct / totalQ) * 100).round() : 0;
    final reward = selectedGrade?.reward ?? 100;

    profile.coins += reward;
    profile.lastReward = reward;

    if (selectedGrade != null && !profile.completedGrades.contains(selectedGrade!.id)) {
      profile.completedGrades.add(selectedGrade!.id);
    }

    final beforeAchievements = Map<String, bool>.from(profile.achievements);

    // Achievements verification
    profile.achievements["firstMission"] = true;
    if (accuracy == 100) profile.achievements["perfectScore"] = true;
    if (profile.completedGrades.length >= 2) profile.achievements["scienceExplorer"] = true;
    if (selectedGrade?.id == 7) profile.achievements["biologyMaster"] = true;
    if (selectedGrade?.id == 8) profile.achievements["earthExpert"] = true;
    if (selectedGrade?.id == 9) profile.achievements["chemistryGenius"] = true;
    if (selectedGrade?.id == 10) profile.achievements["spaceExplorer"] = true;
    if (profile.completedGrades.length >= 4) profile.achievements["allGrades"] = true;

    final elapsedSeconds = missionStartTime != null
        ? DateTime.now().difference(missionStartTime!).inSeconds
        : 999;
    if (wrong == 0 && elapsedSeconds <= totalQ * 15) {
      profile.achievements["speedScientist"] = true;
    }

    // Extra mission XP
    final missionXP = 50 + correct * 10 + (accuracy / 10).round();
    final bonusPoints = accuracy == 100 ? 50 : 25;
    final bonusCoins = accuracy == 100 ? 30 : 15;

    profile.coins += bonusCoins;
    profile.bonusRewards += bonusCoins;
    addXP(missionXP, score + bonusPoints);

    _saveQuizResult(accuracy);
    StorageService.saveStudentProfile(profile);

    _checkNewBadges(beforeAchievements);

    notifyListeners();
  }

  void gameOver() {
    if (battleEnded) return;
    battleEnded = true;
    _timerTicker?.cancel();

    final totalQ = quizQuestions.length;
    final accuracy = totalQ > 0 ? ((correct / totalQ) * 100).round() : 0;

    _saveQuizResult(accuracy);
    profile.lastReward = 0;
    StorageService.saveStudentProfile(profile);

    notifyListeners();
  }

  void _saveQuizResult(int accuracy) {
    if (resultSaved || selectedGrade == null) return;
    resultSaved = true;

    final result = QuizResult(
      id: DateTime.now().millisecondsSinceEpoch,
      studentName: profile.name,
      grade: selectedGrade!.id,
      mission: selectedGrade!.mission,
      score: score,
      correct: correct,
      wrong: wrong,
      accuracy: accuracy,
      date: "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
    );

    StorageService.saveQuizResult(result);
  }

  void addXP(int xpAmount, int pointsAmount) {
    final oldLevel = profile.level;
    profile.xp += max(0, xpAmount);
    profile.totalPoints += max(0, pointsAmount);

    int newLevel = (profile.xp / 100).floor() + 1;
    if (newLevel > 99) newLevel = 99;

    profile.level = newLevel;

    if (newLevel > oldLevel) {
      final bonusCoins = newLevel * 10;
      final bonusPoints = newLevel * 25;
      profile.coins += bonusCoins;
      profile.bonusRewards += bonusCoins;

      pendingLevelUp = LevelUpNotification(
        oldLevel: oldLevel,
        newLevel: newLevel,
        bonusCoins: bonusCoins,
        bonusPoints: bonusPoints,
      );
    }
    StorageService.saveStudentProfile(profile);
  }

  void _checkNewBadges(Map<String, bool> before) {
    for (final item in allAchievements) {
      if ((before[item.id] != true) && profile.achievements[item.id] == true) {
        pendingBadgeUnlocked = item;
        break;
      }
    }
  }

  void clearLevelUpNotification() {
    pendingLevelUp = null;
    notifyListeners();
  }

  void clearBadgeNotification() {
    pendingBadgeUnlocked = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timerTicker?.cancel();
    super.dispose();
  }
}
