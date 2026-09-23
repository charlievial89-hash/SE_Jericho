import 'package:flutter/material.dart';
import 'models/models.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'controllers/quiz_controller.dart';
import 'widgets/gamification_hud.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final studentName = await StorageService.getCurrentStudentName() ?? "Young Scientist";
  final profile = await StorageService.loadStudentProfile(studentName);

  runApp(ScienceQuestApp(initialProfile: profile));
}

class ScienceQuestApp extends StatefulWidget {
  final StudentProfile initialProfile;

  const ScienceQuestApp({super.key, required this.initialProfile});

  @override
  State<ScienceQuestApp> createState() => _ScienceQuestAppState();
}

class _ScienceQuestAppState extends State<ScienceQuestApp> {
  late QuizController quizController;
  String currentRoute = 'main';

  @override
  void initState() {
    super.initState();
    quizController = QuizController(profile: widget.initialProfile);
    quizController.addListener(_onQuizControllerChange);
  }

  void _onQuizControllerChange() {
    if (quizController.pendingLevelUp != null) {
      final notif = quizController.pendingLevelUp!;
      quizController.clearLevelUpNotification();
      showDialog(
        context: context,
        builder: (ctx) => LevelUpDialog(
          notification: notif,
          onClose: () => Navigator.pop(ctx),
        ),
      );
    }

    if (quizController.pendingBadgeUnlocked != null) {
      final badge = quizController.pendingBadgeUnlocked!;
      quizController.clearBadgeNotification();
      showDialog(
        context: context,
        builder: (ctx) => BadgeUnlockedDialog(
          achievement: badge,
          onClose: () => Navigator.pop(ctx),
        ),
      );
    }
  }

  @override
  void dispose() {
    quizController.removeListener(_onQuizControllerChange);
    quizController.dispose();
    super.dispose();
  }

  void navigateTo(String route, {dynamic arguments}) {
    setState(() {
      currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;

    switch (currentRoute) {
      case 'grades':
        currentWidget = GradeSelectionScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
      case 'guardian':
        currentWidget = GuardianBriefingScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
      case 'lesson':
        currentWidget = LessonScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
      case 'quiz':
        currentWidget = QuizBattleScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
      case 'result':
        currentWidget = QuizResultScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
      case 'achievements':
        currentWidget = AchievementsScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
      case 'certificate':
        currentWidget = CertificateScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
      case 'leaderboard':
        currentWidget = LeaderboardScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
      case 'admin_login':
        currentWidget = AdminLoginScreen(
          onNavigate: navigateTo,
        );
        break;
      case 'admin_dashboard':
        currentWidget = AdminDashboardScreen(
          onNavigate: navigateTo,
        );
        break;
      case 'main':
      default:
        currentWidget = MainMenuScreen(
          quizController: quizController,
          onNavigate: navigateTo,
        );
        break;
    }

    return MaterialApp(
      title: 'Science Quest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: currentWidget,
    );
  }
}
