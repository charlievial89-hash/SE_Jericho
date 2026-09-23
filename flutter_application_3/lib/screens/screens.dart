import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/certificate_painter.dart';
import '../widgets/gamification_hud.dart';

// =========================================================
// MAIN MENU SCREEN
// =========================================================
class MainMenuScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const MainMenuScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final profile = quizController.profile;

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Topbar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.darkBg.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "🧪 SCIENCE QUEST",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () => _showNameDialog(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.darkBg2,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    profile.name.isEmpty ? "👤 Enter Name" : "👨‍🔬 ${profile.name}",
                                    style: const TextStyle(
                                      color: AppTheme.cyanAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF241D08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: const Color(0xFF725C16)),
                            ),
                            child: Text(
                              "🪙 ${profile.coins}",
                              style: const TextStyle(
                                color: AppTheme.yellowAccent,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Hero Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppTheme.darkBg.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 30)
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text("🧑‍🔬", style: TextStyle(fontSize: 70)),
                          const SizedBox(height: 10),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF60A5FA), Color(0xFF22D3EE), Color(0xFFA78BFA)],
                            ).createShader(bounds),
                            child: const Text(
                              "SCIENCE QUEST",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Learn science, defeat monsters, earn coins, unlock achievements and become a Science Guardian!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              if (profile.name.isEmpty) {
                                _showNameDialog(context);
                              } else {
                                onNavigate('grades');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            child: const Text("🚀 START ADVENTURE"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Menu Grid
                    GridView.count(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildMenuCard(
                          icon: "🎮",
                          title: "Missions",
                          subtitle: "Choose your science adventure.",
                          onTap: () {
                            if (profile.name.isEmpty) {
                              _showNameDialog(context);
                            } else {
                              onNavigate('grades');
                            }
                          },
                        ),
                        _buildMenuCard(
                          icon: "🏆",
                          title: "Achievements",
                          subtitle: "View your unlocked badges.",
                          onTap: () => onNavigate('achievements'),
                        ),
                        _buildMenuCard(
                          icon: "📜",
                          title: "Certificate",
                          subtitle: "View and save your certificate.",
                          onTap: () {
                            if (profile.completedGrades.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("🔒 Complete a mission first to unlock your certificate."),
                                ),
                              );
                            } else {
                              onNavigate('certificate');
                            }
                          },
                        ),
                        _buildMenuCard(
                          icon: "🥇",
                          title: "Leaderboard",
                          subtitle: "See top Science Quest scores.",
                          onTap: () => onNavigate('leaderboard'),
                        ),
                        _buildMenuCard(
                          icon: "👨‍🏫",
                          title: "Teacher Admin",
                          subtitle: "Teacher dashboard & results.",
                          onTap: () => onNavigate('admin_login'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),

              GamificationHud(profile: profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.darkBg2,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppTheme.mutedText, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  void _showNameDialog(BuildContext context) {
    final controller = TextEditingController(text: quizController.profile.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkBg2,
        title: const Text("👨‍🔬 Student Name", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter your full name before starting your adventure:", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Enter full name"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                final newProf = await StorageService.loadStudentProfile(text);
                await StorageService.saveStudentProfile(newProf);
                quizController.updateProfile(newProf);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text("Save & Continue"),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// GRADE SELECTION SCREEN
// =========================================================
class GradeSelectionScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const GradeSelectionScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final profile = quizController.profile;

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "👨‍🔬 ${profile.name}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF241D08),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF725C16)),
                      ),
                      child: Text(
                        "🪙 ${profile.coins}",
                        style: const TextStyle(color: AppTheme.yellowAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBg.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🎮 Choose Your Mission",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      const Text("Choose a grade and defeat its guardian.", style: TextStyle(color: AppTheme.mutedText)),
                      const SizedBox(height: 20),

                      ...scienceQuestGrades.values.map((grade) {
                        final completed = profile.completedGrades.contains(grade.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: InkWell(
                            onTap: () {
                              quizController.selectedGrade = grade;
                              onNavigate('guardian');
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppTheme.darkBg2,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  Text(grade.emoji, style: const TextStyle(fontSize: 44)),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "GRADE ${grade.id}",
                                              style: const TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.w900, fontSize: 12),
                                            ),
                                            Text(
                                              "🪙 +${grade.reward}",
                                              style: const TextStyle(color: AppTheme.yellowAccent, fontWeight: FontWeight.w900, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(grade.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                        Text(grade.mission, style: const TextStyle(color: AppTheme.mutedText, fontSize: 13)),
                                        const SizedBox(height: 8),
                                        Text(
                                          completed ? "🏆 COMPLETED" : "⚔️ READY FOR BATTLE",
                                          style: TextStyle(
                                            color: completed ? AppTheme.greenAccent : AppTheme.cyanAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: LinearProgressIndicator(
                                            value: completed ? 1.0 : 0.0,
                                            minHeight: 8,
                                            backgroundColor: const Color(0xFF334155),
                                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.greenAccent),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => onNavigate('main'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B)),
                        child: const Text("← Main Menu"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// GUARDIAN BRIEFING SCREEN
// =========================================================
class GuardianBriefingScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const GuardianBriefingScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final grade = quizController.selectedGrade ?? scienceQuestGrades[7]!;

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppTheme.darkBg.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "GRADE ${grade.id}",
                      style: const TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Text(grade.emoji, style: const TextStyle(fontSize: 80)),
                    const SizedBox(height: 12),
                    Text(
                      grade.guardian,
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.darkBg2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        grade.dialogue,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => onNavigate('lesson'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.blueAccent,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text("📖 LEARN FIRST"),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        quizController.startQuiz(grade);
                        onNavigate('quiz');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.greenAccent,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text("⚔️ START BATTLE"),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => onNavigate('grades'),
                      child: const Text("← Missions", style: TextStyle(color: AppTheme.mutedText)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// LESSON SCREEN
// =========================================================
class LessonScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const LessonScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final grade = quizController.selectedGrade ?? scienceQuestGrades[7]!;

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.darkBg.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(grade.emoji, style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 10),
                  Text(
                    grade.title,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(grade.description, style: const TextStyle(color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 20),

                  // Grid of Objectives & Concepts
                  LayoutBuilder(builder: (ctx, constraints) {
                    final bool wide = constraints.maxWidth > 600;
                    return Flex(
                      direction: wide ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: wide ? 1 : 0,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppTheme.darkBg2,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("🎯 Learning Objectives", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 10),
                                ...grade.objectives.map((o) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text("• $o", style: const TextStyle(color: Colors.white70)),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        if (wide) const SizedBox(width: 14),
                        Expanded(
                          flex: wide ? 1 : 0,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppTheme.darkBg2,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("🧠 Key Concepts", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 10),
                                ...grade.concepts.asMap().entries.map((e) => Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.darkBg,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Text("0${e.key + 1}", style: const TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 10),
                                          Text(e.value, style: const TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBg2,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("📚 Summary", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(grade.summary, style: const TextStyle(color: Colors.white70, height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            quizController.startQuiz(grade);
                            onNavigate('quiz');
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.greenAccent),
                          child: const Text("⚔️ I'M READY — BATTLE!"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => onNavigate('guardian'),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                        child: const Text("← Back"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// QUIZ BATTLE SCREEN
// =========================================================
class QuizBattleScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const QuizBattleScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: quizController,
      builder: (context, _) {
        if (quizController.battleEnded && quizController.selectedGrade != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onNavigate('result');
          });
        }

        final currentQ = quizController.questionIndex < quizController.quizQuestions.length
            ? quizController.quizQuestions[quizController.questionIndex]
            : null;

        final enemyEmoji = quizController.battleStage == "boss"
            ? (quizController.selectedGrade?.id == 7 ? "👹" : quizController.selectedGrade?.id == 8 ? "🌋" : quizController.selectedGrade?.id == 9 ? "🐲" : "👽")
            : ["👾", "🦂", "🧟"][quizController.enemyIndex % 3];

        final enemyName = quizController.battleStage == "boss"
            ? (quizController.selectedGrade?.id == 7 ? "Cell Beast" : quizController.selectedGrade?.id == 8 ? "Earth Titan" : quizController.selectedGrade?.id == 9 ? "Reaction Beast" : "Galaxy Overlord")
            : ["Cell Minion", "Science Minion", "Lab Minion"][quizController.enemyIndex % 3];

        return Scaffold(
          body: Container(
            decoration: AppTheme.mainScreenBackground(),
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Quiz Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatBadge("❤️ ${quizController.lives}"),
                            _buildStatBadge("⭐ ${quizController.score}"),
                            _buildStatBadge("⏱️ ${quizController.timer}", isTimer: true),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Battle Arena
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.darkBg.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // Player
                                  Column(
                                    children: [
                                      const Text("🧑‍🔬", style: TextStyle(fontSize: 60)),
                                      const Text("YOU", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 100,
                                        child: LinearProgressIndicator(
                                          value: quizController.playerHP / 3,
                                          backgroundColor: Colors.white10,
                                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.greenAccent),
                                        ),
                                      ),
                                      Text("${quizController.playerHP}/3 HP", style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
                                    ],
                                  ),
                                  const Text("VS", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.redAccent)),
                                  // Enemy
                                  Column(
                                    children: [
                                      Text(enemyEmoji, style: const TextStyle(fontSize: 60)),
                                      Text(enemyName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 100,
                                        child: LinearProgressIndicator(
                                          value: quizController.enemyMaxHP > 0 ? quizController.enemyHP / quizController.enemyMaxHP : 0,
                                          backgroundColor: Colors.white10,
                                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.redAccent),
                                        ),
                                      ),
                                      Text("${quizController.enemyHP}/${quizController.enemyMaxHP} HP", style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                quizController.battleStage == "boss" ? "👹 BOSS BATTLE" : "⚔️ MINION ${quizController.enemyIndex + 1} OF 3",
                                style: const TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Question Card
                        if (currentQ != null)
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: AppTheme.darkBg2,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Battle Question ${quizController.questionIndex + 1} of ${quizController.quizQuestions.length}",
                                      style: const TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.blueAccent.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text("🔀 RANDOMIZED BATTLE", style: TextStyle(color: Color(0xFF93C5FD), fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: (quizController.questionIndex + 1) / quizController.quizQuestions.length,
                                    minHeight: 6,
                                    backgroundColor: Colors.white10,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.cyanAccent),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentQ.q,
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 18),

                                // Options List
                                ...currentQ.options.asMap().entries.map((entry) {
                                  final int idx = entry.key;
                                  final String optionText = entry.value;
                                  final bool isSelected = quizController.selectedAnswerIndex == idx;
                                  final bool isCorrectChoice = idx == currentQ.answer;

                                  Color btnColor = AppTheme.darkBg;
                                  Color borderColor = const Color(0xFF334155);

                                  if (quizController.answered) {
                                    if (isCorrectChoice) {
                                      btnColor = const Color(0xFF064E3B);
                                      borderColor = AppTheme.greenAccent;
                                    } else if (isSelected && !isCorrectChoice) {
                                      btnColor = const Color(0xFF7F1D1D);
                                      borderColor = AppTheme.redAccent;
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: InkWell(
                                      onTap: quizController.answered ? null : () => quizController.resolveAnswer(idx),
                                      borderRadius: BorderRadius.circular(14),
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: btnColor,
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: borderColor, width: 2),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF334155),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                String.fromCharCode(65 + idx),
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                optionText,
                                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),

                                // Feedback
                                if (quizController.answered)
                                  Container(
                                    margin: const EdgeInsets.only(top: 14),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppTheme.darkBg,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: quizController.lastAnswerWasCorrect ? AppTheme.greenAccent : AppTheme.redAccent,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          quizController.lastAnswerWasCorrect ? "⚔️ DIRECT HIT!" : "💔 WRONG ANSWER!",
                                          style: TextStyle(
                                            color: quizController.lastAnswerWasCorrect ? AppTheme.greenAccent : AppTheme.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Explanation: ${currentQ.explanation}",
                                          style: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Laser Beam Animation Overlay
                  if (quizController.isLaserActive)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          color: (quizController.isLaserWrong ? AppTheme.redAccent : AppTheme.cyanAccent).withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(String text, {bool isTimer = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkBg2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isTimer ? AppTheme.yellowAccent : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

// =========================================================
// QUIZ RESULT SCREEN
// =========================================================
class QuizResultScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const QuizResultScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final bool victory = quizController.playerHP > 0;
    final total = quizController.quizQuestions.length;
    final accuracy = total > 0 ? ((quizController.correct / total) * 100).round() : 0;

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppTheme.darkBg.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(victory ? "🏆" : "💔", style: const TextStyle(fontSize: 80)),
                    const SizedBox(height: 10),
                    Text(
                      victory ? "MISSION COMPLETE!" : "GAME OVER",
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      victory ? "You defeated all enemies and completed ${quizController.selectedGrade?.mission}!" : "Your HP reached zero. Train again and retry!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),

                    // Stats Grid
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.3,
                      children: [
                        _buildStatBox("Score", "${quizController.score}"),
                        _buildStatBox("Correct", "${quizController.correct}"),
                        _buildStatBox("Wrong", "${quizController.wrong}"),
                        _buildStatBox("Accuracy", "$accuracy%"),
                        _buildStatBox("Coins", "+${quizController.profile.lastReward}"),
                        _buildStatBox("Student", quizController.profile.name),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (victory)
                      ElevatedButton(
                        onPressed: () => onNavigate('certificate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.blueAccent,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text("📜 VIEW CERTIFICATE"),
                      ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (quizController.selectedGrade != null) {
                          quizController.startQuiz(quizController.selectedGrade!);
                          onNavigate('quiz');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.greenAccent,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text("🔄 PLAY AGAIN"),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => onNavigate('main'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text("🏠 MAIN MENU"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.darkBg2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.mutedText, fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// ACHIEVEMENTS SCREEN
// =========================================================
class AchievementsScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const AchievementsScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final achievementsMap = quizController.profile.achievements;
    final unlockedCount = achievementsMap.values.where((v) => v).length;

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.darkBg.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("🏆 Achievements", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text("Unlocked: $unlockedCount / ${allAchievements.length}", style: const TextStyle(color: AppTheme.mutedText)),
                  const SizedBox(height: 20),

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allAchievements.length,
                    itemBuilder: (ctx, idx) {
                      final item = allAchievements[idx];
                      final bool unlocked = achievementsMap[item.id] == true;
                      return Opacity(
                        opacity: unlocked ? 1.0 : 0.45,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.darkBg2,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.icon, style: const TextStyle(fontSize: 40)),
                              const SizedBox(height: 6),
                              Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppTheme.mutedText, fontSize: 11),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                unlocked ? "✓ UNLOCKED" : "🔒 LOCKED",
                                style: TextStyle(
                                  color: unlocked ? AppTheme.greenAccent : AppTheme.mutedText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => onNavigate('main'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B)),
                    child: const Text("← Main Menu"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// CERTIFICATE SCREEN
// =========================================================
class CertificateScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const CertificateScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final grade = quizController.selectedGrade ?? scienceQuestGrades[7]!;

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.darkBg.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  const Text("📜 Certificate of Achievement", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  const Text("Your official Science Quest certificate.", style: TextStyle(color: AppTheme.mutedText)),
                  const SizedBox(height: 20),

                  AspectRatio(
                    aspectRatio: 16 / 11,
                    child: CustomPaint(
                      painter: CertificatePainter(
                        profile: quizController.profile,
                        gradeMission: grade,
                        score: quizController.score > 0 ? quizController.score : 50,
                        accuracy: 100,
                        date: "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("🖼️ Certificate saved successfully!")),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text("SAVE PNG"),
                      ),
                      const SizedBox(width: 14),
                      ElevatedButton(
                        onPressed: () => onNavigate('main'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B)),
                        child: const Text("← BACK"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// LEADERBOARD SCREEN
// =========================================================
class LeaderboardScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const LeaderboardScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<List<QuizResult>>(
              future: StorageService.getQuizResults(),
              builder: (ctx, snapshot) {
                final results = snapshot.data ?? [];

                final Map<String, Map<String, dynamic>> byStudent = {};
                for (var r in results) {
                  final name = r.studentName;
                  if (!byStudent.containsKey(name)) {
                    byStudent[name] = {'name': name, 'score': 0, 'missions': 0, 'accuracy': 0};
                  }
                  byStudent[name]!['score'] += r.score;
                  byStudent[name]!['missions'] += 1;
                  byStudent[name]!['accuracy'] += r.accuracy;
                }

                if (quizController.profile.name.isNotEmpty && !byStudent.containsKey(quizController.profile.name)) {
                  byStudent[quizController.profile.name] = {
                    'name': quizController.profile.name,
                    'score': quizController.profile.totalPoints,
                    'missions': 0,
                    'accuracy': 0,
                  };
                }

                final rows = byStudent.values.toList()
                  ..sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBg.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("🥇 Science Quest Leaderboard", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      const Text("Top scores saved on this device.", style: TextStyle(color: AppTheme.mutedText)),
                      const SizedBox(height: 20),

                      if (rows.isEmpty)
                        const Text("No scores recorded yet. Complete a mission!", style: TextStyle(color: Colors.white70))
                      else
                        ...rows.asMap().entries.map((entry) {
                          final rank = entry.key + 1;
                          final data = entry.value;
                          final medal = rank == 1 ? "🥇" : rank == 2 ? "🥈" : rank == 3 ? "🥉" : "#$rank";
                          final int missions = data['missions'] as int;
                          final int avgAcc = missions > 0 ? (data['accuracy'] / missions).round() : 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.darkBg2,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text(medal, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text("$missions mission(s) • $avgAcc% avg. accuracy", style: const TextStyle(color: AppTheme.mutedText, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                Text("⭐ ${data['score']}", style: const TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          );
                        }),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => onNavigate('main'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B)),
                        child: const Text("← Main Menu"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// TEACHER ADMIN LOGIN SCREEN
// =========================================================
class AdminLoginScreen extends StatefulWidget {
  final Function(String route, {dynamic arguments}) onNavigate;

  const AdminLoginScreen({super.key, required this.onNavigate});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (usernameController.text.trim() == "teacher" && passwordController.text == "admin123") {
      await StorageService.setAdminLoggedIn(true);
      widget.onNavigate('admin_dashboard');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Invalid username or password.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppTheme.darkBg.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("👨‍🏫", style: TextStyle(fontSize: 65)),
                    const SizedBox(height: 10),
                    const Text("Teacher Admin", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    const Text("Login to view student performance.", style: TextStyle(color: AppTheme.mutedText)),
                    const SizedBox(height: 20),

                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(hintText: "Username (teacher)"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: "Password (admin123)"),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.blueAccent,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text("🔐 LOGIN"),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => widget.onNavigate('main'),
                      child: const Text("← Back", style: TextStyle(color: AppTheme.mutedText)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// TEACHER ADMIN DASHBOARD SCREEN
// =========================================================
class AdminDashboardScreen extends StatefulWidget {
  final Function(String route, {dynamic arguments}) onNavigate;

  const AdminDashboardScreen({super.key, required this.onNavigate});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String searchQuery = "";
  List<QuizResult> allResults = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final list = await StorageService.getQuizResults();
    if (mounted) {
      setState(() {
        allResults = list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = allResults.where((r) => r.studentName.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    final studentSet = allResults.map((r) => r.studentName).toSet();
    final avgScore = allResults.isNotEmpty ? (allResults.map((r) => r.score).reduce((a, b) => a + b) / allResults.length).round() : 0;
    final avgAccuracy = allResults.isNotEmpty ? (allResults.map((r) => r.accuracy).reduce((a, b) => a + b) / allResults.length).round() : 0;

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("👨‍🏫 Teacher Dashboard", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    ElevatedButton(
                      onPressed: () async {
                        await StorageService.setAdminLoggedIn(false);
                        widget.onNavigate('main');
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.redAccent),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Metrics
                GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _buildMetricCard("Students", "${studentSet.length}"),
                    _buildMetricCard("Missions", "${allResults.length}"),
                    _buildMetricCard("Average Score", "$avgScore"),
                    _buildMetricCard("Average Accuracy", "$avgAccuracy%"),
                  ],
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBg.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("📊 Student Results", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              decoration: const InputDecoration(hintText: "Search student...", isDense: true),
                              onChanged: (val) => setState(() => searchQuery = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Student", style: TextStyle(color: AppTheme.cyanAccent))),
                            DataColumn(label: Text("Grade", style: TextStyle(color: AppTheme.cyanAccent))),
                            DataColumn(label: Text("Score", style: TextStyle(color: AppTheme.cyanAccent))),
                            DataColumn(label: Text("Accuracy", style: TextStyle(color: AppTheme.cyanAccent))),
                            DataColumn(label: Text("Date", style: TextStyle(color: AppTheme.cyanAccent))),
                          ],
                          rows: filtered.reversed.map((r) {
                            return DataRow(cells: [
                              DataCell(Text(r.studentName, style: const TextStyle(color: Colors.white))),
                              DataCell(Text("Grade ${r.grade}", style: const TextStyle(color: Colors.white70))),
                              DataCell(Text("${r.score}", style: const TextStyle(color: Colors.white))),
                              DataCell(Text("${r.accuracy}%", style: TextStyle(color: r.accuracy >= 80 ? AppTheme.greenAccent : AppTheme.yellowAccent, fontWeight: FontWeight.bold))),
                              DataCell(Text(r.date, style: const TextStyle(color: AppTheme.mutedText, fontSize: 12))),
                            ]);
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("📥 Student results exported to CSV.")),
                              );
                            },
                            icon: const Icon(Icons.download),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.greenAccent),
                            label: const Text("EXPORT CSV"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await StorageService.clearAllQuizResults();
                              loadData();
                            },
                            icon: const Icon(Icons.delete),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.redAccent),
                            label: const Text("CLEAR RESULTS"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String val) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkBg2,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: AppTheme.mutedText, fontSize: 12)),
          const SizedBox(height: 6),
          Text(val, style: const TextStyle(color: AppTheme.cyanAccent, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
