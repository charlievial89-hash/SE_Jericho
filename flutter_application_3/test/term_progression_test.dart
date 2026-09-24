import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_3/models/models.dart';
import 'package:flutter_application_3/controllers/quiz_controller.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('Grade 7 Curriculum & Term Progression', () {
    test('Contains only Grade 7 Three Terms (Term 1, 2, 3)', () {
      expect(grade7Terms.length, equals(3));
      expect(grade7Terms.containsKey(1), isTrue);
      expect(grade7Terms.containsKey(2), isTrue);
      expect(grade7Terms.containsKey(3), isTrue);

      // Verify Grades 8, 9, 10 are not present
      expect(grade7Terms.containsKey(8), isFalse);
      expect(grade7Terms.containsKey(9), isFalse);
      expect(grade7Terms.containsKey(10), isFalse);
    });

    test('Term 1 contains exact 10 Cell Biology questions', () {
      final term1 = grade7Terms[1]!;
      expect(term1.topic, equals("Cell Biology"));
      expect(term1.questions.length, equals(10));

      // Question 1
      expect(term1.questions[0].q, equals("What is the basic unit of life?"));
      expect(term1.questions[0].options, equals(["Tissue", "Organ", "Cell", "Organ system"]));
      expect(term1.questions[0].answer, equals(2)); // C — Cell

      // Question 2
      expect(term1.questions[1].q, equals("Who coined the term “cell” after observing cork?"));
      expect(term1.questions[1].options, equals(["Theodor Schwann", "Robert Hooke", "Rudolf Virchow", "Matthias Schleiden"]));
      expect(term1.questions[1].answer, equals(1)); // B — Robert Hooke

      // Question 3
      expect(term1.questions[2].q, equals("Which type of cell does NOT have a true nucleus?"));
      expect(term1.questions[2].options, equals(["Animal cell", "Plant cell", "Eukaryotic cell", "Prokaryotic cell"]));
      expect(term1.questions[2].answer, equals(3)); // D — Prokaryotic cell

      // Question 4
      expect(term1.questions[3].q, equals("Which organism is an example of a prokaryote?"));
      expect(term1.questions[3].options, equals(["Amoeba", "Paramecium", "Bacterium", "Mushroom"]));
      expect(term1.questions[3].answer, equals(2)); // C — Bacterium

      // Question 5
      expect(term1.questions[4].q, equals("What do we call an organism made up of only one cell?"));
      expect(term1.questions[4].options, equals(["Multicellular", "Unicellular", "Colonial", "Specialized"]));
      expect(term1.questions[4].answer, equals(1)); // B — Unicellular

      // Question 6
      expect(term1.questions[5].q, equals("What is the main function of the cell membrane?"));
      expect(term1.questions[5].options, equals(["Produce ATP", "Store DNA", "Control movement of materials into and out of the cell", "Produce ribosomes"]));
      expect(term1.questions[5].answer, equals(2)); // C — Control movement of materials into and out of the cell

      // Question 7
      expect(term1.questions[6].q, equals("Which organelle is known as the energy generator of the cell?"));
      expect(term1.questions[6].options, equals(["Golgi apparatus", "Lysosome", "Mitochondrion", "Vacuole"]));
      expect(term1.questions[6].answer, equals(2)); // C — Mitochondrion

      // Question 8
      expect(term1.questions[7].q, equals("Which organelle is responsible for protein synthesis?"));
      expect(term1.questions[7].options, equals(["Ribosome", "Lysosome", "Vacuole", "Peroxisome"]));
      expect(term1.questions[7].answer, equals(0)); // A — Ribosome

      // Question 9
      expect(term1.questions[8].q, equals("Which structure contains the cell's DNA in a eukaryotic cell?"));
      expect(term1.questions[8].options, equals(["Golgi apparatus", "Nucleus", "Cytoplasm", "Cell membrane"]));
      expect(term1.questions[8].answer, equals(1)); // B — Nucleus

      // Question 10
      expect(term1.questions[9].q, equals("What is a network of hyphae called?"));
      expect(term1.questions[9].options, equals(["Nucleoid", "Mycelium", "Cytosol", "Chromatin"]));
      expect(term1.questions[9].answer, equals(1)); // B — Mycelium
    });

    test('Cell Guardian battle enemy configuration', () {
      final term1 = grade7Terms[1]!;
      expect(term1.guardianName, equals("Cell Guardian"));
      expect(term1.guardianEmoji, equals("🦠"));
      expect(term1.guardianMaxHP, equals(10));
    });

    test('Date/Time Lock System tests', () {
      final config = TermUnlockConfig(
        term1Start: DateTime.parse("2026-08-01T08:00:00"),
        term2Start: DateTime.parse("2026-11-15T08:00:00"),
        term3Start: DateTime.parse("2027-02-15T08:00:00"),
        timezoneOffsetHours: 8,
      );

      // Current mock time: September 2026
      final mockNow = DateTime.parse("2026-09-24T12:00:00");

      // Term 1 should be unlocked
      expect(config.isTermUnlocked(1, mockNow), isTrue);

      // Term 2 should be locked
      expect(config.isTermUnlocked(2, mockNow), isFalse);

      // Term 3 should be locked
      expect(config.isTermUnlocked(3, mockNow), isFalse);

      // When mock time reaches or passes Term 3 start date (Feb 15, 2027 08:00)
      final mockAfterTerm3 = DateTime.parse("2027-02-15T08:00:01");
      expect(config.isTermUnlocked(3, mockAfterTerm3), isTrue);
    });

    test('Battle mechanics: Correct answer damages Cell Guardian, wrong does not', () {
      final profile = StudentProfile(name: "Scientist Alice");
      final controller = QuizController(profile: profile);
      final term1 = grade7Terms[1]!;

      controller.startQuiz(term1);
      expect(controller.enemyHP, equals(10));
      expect(controller.enemyMaxHP, equals(10));

      final q0 = controller.quizQuestions[0];
      final correctIdx = q0.answer;
      final wrongIdx = (correctIdx + 1) % 4;

      // 1. Correct answer
      controller.resolveAnswer(correctIdx);
      expect(controller.enemyHP, equals(9), reason: "Cell Guardian loses 1 HP on correct answer");
      expect(controller.score, equals(10));

      // Reset answered flag for test
      controller.answered = false;

      // 2. Incorrect answer
      controller.resolveAnswer(wrongIdx);
      expect(controller.enemyHP, equals(9), reason: "Cell Guardian does NOT lose HP on incorrect answer");
      expect(controller.playerHP, equals(2), reason: "Player loses 1 HP on wrong answer");
    });

    test('Biology Streak / Combo mechanics and bonus coins', () {
      final profile = StudentProfile(name: "Scientist Bob");
      final controller = QuizController(profile: profile);
      final term1 = grade7Terms[1]!;

      controller.startQuiz(term1);
      expect(controller.currentStreak, equals(0));

      // 1st correct answer -> Streak = 1
      controller.resolveAnswer(controller.quizQuestions[0].answer);
      expect(controller.currentStreak, equals(1));
      expect(controller.bestStreak, equals(1));
      expect(controller.streakBonusCoins, equals(0));

      // 2nd consecutive correct answer -> Streak = 2 (2x Biology Streak!)
      controller.answered = false;
      controller.questionIndex = 1;
      controller.resolveAnswer(controller.quizQuestions[1].answer);
      expect(controller.currentStreak, equals(2));
      expect(controller.bestStreak, equals(2));
      expect(controller.streakBonusCoins, equals(4), reason: "2 * 2 bonus coins awarded");

      // 3rd consecutive correct answer -> Streak = 3 (3x Biology Streak!)
      controller.answered = false;
      controller.questionIndex = 2;
      controller.resolveAnswer(controller.quizQuestions[2].answer);
      expect(controller.currentStreak, equals(3));
      expect(controller.bestStreak, equals(3));
      expect(controller.streakBonusCoins, equals(10), reason: "4 + (3 * 2) = 10 bonus coins awarded");

      // Wrong answer resets streak to 0 and triggers counter-attack
      controller.answered = false;
      controller.questionIndex = 3;
      final wrongChoice = (controller.quizQuestions[3].answer + 1) % 4;
      controller.resolveAnswer(wrongChoice);
      expect(controller.currentStreak, equals(0), reason: "Wrong answer resets current streak");
      expect(controller.bestStreak, equals(3), reason: "Best streak is preserved");
      expect(controller.isCounterAttacking, isTrue, reason: "Counter-attack triggered on wrong answer");
    });

    test('Term 1 contains 13 curriculum topics and 4 in-line warm-up checks', () {
      final term1 = grade7Terms[1]!;
      expect(term1.cards.length, equals(13));

      // Verify all 13 topics exist with appropriate properties
      for (int i = 1; i <= 13; i++) {
        final card = term1.cards.firstWhere((c) => c.topicNumber == i);
        expect(card.title, isNotEmpty);
        expect(card.subtitle, isNotEmpty);
        expect(card.content, isNotEmpty);
        expect(card.analogy, isNotNull);
        expect(card.rememberThis, isNotNull);
      }

      // Verify 4 Warm-up questions
      expect(term1.warmUps.length, equals(4));
      expect(term1.warmUps[0].afterTopicNumber, equals(3));
      expect(term1.warmUps[1].afterTopicNumber, equals(5));
      expect(term1.warmUps[2].afterTopicNumber, equals(8));
      expect(term1.warmUps[3].afterTopicNumber, equals(10));

      for (final warmUp in term1.warmUps) {
        expect(warmUp.options.length, equals(4));
        expect(warmUp.answer, inInclusiveRange(0, 3));
        expect(warmUp.explanation, isNotEmpty);
        expect(warmUp.clue, isNotEmpty);
      }
    });

    test('Grade 7 Achievements list contains all 8 enhanced achievements', () {
      expect(allAchievements.length, equals(8));
      final ids = allAchievements.map((a) => a.id).toSet();
      expect(ids.contains("cellExplorer"), isTrue);
      expect(ids.contains("warmUpAce"), isTrue);
      expect(ids.contains("firstMission"), isTrue);
      expect(ids.contains("streakMaster"), isTrue);
      expect(ids.contains("clutchAnswer"), isTrue);
      expect(ids.contains("perfectScore"), isTrue);
      expect(ids.contains("cellMaster"), isTrue);
      expect(ids.contains("termMaster"), isTrue);
    });

    test('QuizController achievement unlock triggers (StreakMaster and ClutchAnswer)', () {
      final profile = StudentProfile(name: "Young Scientist");
      final controller = QuizController(profile: profile);
      final term1 = grade7Terms[1]!;

      controller.startQuiz(term1);

      // Verify Clutch Biologist unlocks when answering under 5 seconds
      controller.timer = 4; // in red urgency zone (< 5s)
      controller.resolveAnswer(controller.quizQuestions[0].answer);
      expect(profile.achievements["clutchAnswer"], isTrue);

      // Verify 2nd and 3rd correct answers trigger streakMaster
      controller.answered = false;
      controller.questionIndex = 1;
      controller.timer = 15;
      controller.resolveAnswer(controller.quizQuestions[1].answer); // streak = 2

      controller.answered = false;
      controller.questionIndex = 2;
      controller.timer = 15;
      controller.resolveAnswer(controller.quizQuestions[2].answer); // streak = 3 -> Combo Master!
      expect(profile.achievements["streakMaster"], isTrue);

      // Verify cellExplorer & warmUpAce manual triggers
      controller.unlockAchievement("cellExplorer");
      expect(profile.achievements["cellExplorer"], isTrue);

      controller.unlockAchievement("warmUpAce");
      expect(profile.achievements["warmUpAce"], isTrue);
    });
  });
}


