import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../controllers/quiz_controller.dart';

class GamificationHud extends StatelessWidget {
  final StudentProfile profile;

  const GamificationHud({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hudWidth = (screenWidth - 32).clamp(200.0, 300.0);

    return Positioned(
      left: 16,
      bottom: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: hudWidth,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.darkBg.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.4)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "🧪 SCIENCE QUEST",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "LEVEL ${profile.level}",
                    style: const TextStyle(
                      color: AppTheme.cyanAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "XP ${profile.xp} / ${profile.nextXP}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: AppTheme.mutedText, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: profile.xpProgressPercent,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF334155),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.cyanAccent),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "⭐ Points: ${profile.totalPoints}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: AppTheme.yellowAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "🏅 Badges: ${profile.achievements.values.where((v) => v).length}",
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: AppTheme.yellowAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelUpDialog extends StatelessWidget {
  final LevelUpNotification notification;
  final VoidCallback onClose;

  const LevelUpDialog({
    super.key,
    required this.notification,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.darkBg2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.cyanAccent, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 30,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "🎉",
              style: TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 12),
            Text(
              "LEVEL ${notification.newLevel} UNLOCKED!",
              style: const TextStyle(
                color: AppTheme.cyanAccent,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your science knowledge is getting stronger!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF241D08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF725C16)),
              ),
              child: Column(
                children: [
                  const Text(
                    "🎁 LEVEL-UP REWARD",
                    style: TextStyle(color: AppTheme.yellowAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "⭐ +${notification.bonusPoints} Points",
                    style: const TextStyle(color: AppTheme.yellowAccent, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.blueAccent,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text("CONTINUE 🚀"),
            ),
          ],
        ),
      ),
    );
  }
}

class BadgeUnlockedDialog extends StatelessWidget {
  final AchievementItem achievement;
  final VoidCallback onClose;

  const BadgeUnlockedDialog({
    super.key,
    required this.achievement,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.darkBg2,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.purpleAccent, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 30,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              achievement.icon,
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 10),
            const Text(
              "BADGE UNLOCKED!",
              style: TextStyle(
                color: AppTheme.yellowAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              achievement.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.purpleAccent,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text("AWESOME! 🏆"),
            ),
          ],
        ),
      ),
    );
  }
}
