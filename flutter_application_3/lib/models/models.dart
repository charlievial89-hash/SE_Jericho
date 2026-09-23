class Question {
  final String q;
  final List<String> options;
  final int answer;
  final String explanation;

  Question({
    required this.q,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  Question copyWith({
    String? q,
    List<String>? options,
    int? answer,
    String? explanation,
  }) {
    return Question(
      q: q ?? this.q,
      options: options ?? List.from(this.options),
      answer: answer ?? this.answer,
      explanation: explanation ?? this.explanation,
    );
  }

  Map<String, dynamic> toJson() => {
        'q': q,
        'options': options,
        'answer': answer,
        'explanation': explanation,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        q: json['q'] as String,
        options: List<String>.from(json['options']),
        answer: json['answer'] as int,
        explanation: json['explanation'] as String,
      );
}

class GradeMission {
  final int id;
  final String name;
  final String guardian;
  final String emoji;
  final String mission;
  final int reward;
  final String title;
  final String description;
  final String dialogue;
  final List<String> objectives;
  final List<String> concepts;
  final String summary;
  final List<Question> questions;

  GradeMission({
    required this.id,
    required this.name,
    required this.guardian,
    required this.emoji,
    required this.mission,
    required this.reward,
    required this.title,
    required this.description,
    required this.dialogue,
    required this.objectives,
    required this.concepts,
    required this.summary,
    required this.questions,
  });
}

class QuizResult {
  final int id;
  final String studentName;
  final int grade;
  final String mission;
  final int score;
  final int correct;
  final int wrong;
  final int accuracy;
  final String date;

  QuizResult({
    required this.id,
    required this.studentName,
    required this.grade,
    required this.mission,
    required this.score,
    required this.correct,
    required this.wrong,
    required this.accuracy,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentName': studentName,
        'grade': grade,
        'mission': mission,
        'score': score,
        'correct': correct,
        'wrong': wrong,
        'accuracy': accuracy,
        'date': date,
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        id: json['id'] as int,
        studentName: json['studentName'] as String,
        grade: json['grade'] as int,
        mission: json['mission'] as String,
        score: json['score'] as int,
        correct: json['correct'] as int,
        wrong: json['wrong'] as int,
        accuracy: json['accuracy'] as int,
        date: json['date'] as String,
      );
}

class AchievementItem {
  final String id;
  final String icon;
  final String title;
  final String description;

  const AchievementItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class StudentProfile {
  String name;
  int coins;
  List<int> completedGrades;
  int lastReward;
  Map<String, bool> achievements;
  int xp;
  int level;
  int totalPoints;
  int bonusRewards;

  StudentProfile({
    required this.name,
    this.coins = 0,
    List<int>? completedGrades,
    this.lastReward = 0,
    Map<String, bool>? achievements,
    this.xp = 0,
    this.level = 1,
    this.totalPoints = 0,
    this.bonusRewards = 0,
  })  : completedGrades = completedGrades ?? [],
        achievements = achievements ??
            {
              "firstMission": false,
              "perfectScore": false,
              "scienceExplorer": false,
              "biologyMaster": false,
              "earthExpert": false,
              "chemistryGenius": false,
              "spaceExplorer": false,
              "allGrades": false,
              "speedScientist": false,
            };

  int get nextXP => level * 100;
  double get xpProgressPercent => ((xp % nextXP) / nextXP).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
        'name': name,
        'coins': coins,
        'completedGrades': completedGrades,
        'lastReward': lastReward,
        'achievements': achievements,
        'xp': xp,
        'level': level,
        'totalPoints': totalPoints,
        'bonusRewards': bonusRewards,
      };

  factory StudentProfile.fromJson(Map<String, dynamic> json) => StudentProfile(
        name: json['name'] as String,
        coins: (json['coins'] as num?)?.toInt() ?? 0,
        completedGrades: (json['completedGrades'] as List?)?.map((e) => (e as num).toInt()).toList() ?? [],
        lastReward: (json['lastReward'] as num?)?.toInt() ?? 0,
        achievements: (json['achievements'] as Map?)?.map((k, v) => MapEntry(k.toString(), v == true)) ?? {},
        xp: (json['xp'] as num?)?.toInt() ?? 0,
        level: (json['level'] as num?)?.toInt() ?? 1,
        totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
        bonusRewards: (json['bonusRewards'] as num?)?.toInt() ?? 0,
      );
}

// Built-in Science Quest Grade Missions Data
final Map<int, GradeMission> scienceQuestGrades = {
  7: GradeMission(
    id: 7,
    name: "Young Biology Guardian",
    guardian: "Professor Bio",
    emoji: "🧬",
    mission: "Living Things",
    reward: 100,
    title: "Introduction to Cells",
    description: "Explore the basic unit of life and understand how cells help living organisms survive.",
    dialogue: "Welcome, Young Scientist! Defeat the minions and the Cell Beast by answering science questions!",
    objectives: [
      "Understand what a cell is.",
      "Identify basic cell structures.",
      "Explain why cells are important to living things."
    ],
    concepts: ["Cell", "Cell Membrane", "Nucleus"],
    summary: "Cells are the basic structural and functional units of living organisms. Different cells perform different functions that help organisms live and grow.",
    questions: [
      Question(
        q: "What is the basic unit of life?",
        options: ["Atom", "Cell", "Tissue", "Organ"],
        answer: 1,
        explanation: "The cell is the basic structural and functional unit of life.",
      ),
      Question(
        q: "Which structure controls many activities of a cell?",
        options: ["Nucleus", "Cell wall", "Vacuole", "Cytoplasm"],
        answer: 0,
        explanation: "The nucleus controls many activities of the cell and contains genetic material.",
      ),
      Question(
        q: "Which organisms are made of cells?",
        options: ["Only animals", "Only plants", "Living organisms", "Only bacteria"],
        answer: 2,
        explanation: "All living organisms are made of one or more cells.",
      ),
      Question(
        q: "Which organelle is commonly known as the powerhouse of the cell?",
        options: ["Nucleus", "Mitochondria", "Ribosome", "Vacuole"],
        answer: 1,
        explanation: "Mitochondria produce much of the usable energy needed by cells.",
      ),
      Question(
        q: "Which cell structure controls what enters and leaves the cell?",
        options: ["Cell membrane", "Nucleus", "Mitochondria", "Ribosome"],
        answer: 0,
        explanation: "The cell membrane controls what substances enter and leave the cell.",
      ),
    ],
  ),
  8: GradeMission(
    id: 8,
    name: "Earth Science Guardian",
    guardian: "Professor Terra",
    emoji: "🌎",
    mission: "Earth and Environment",
    reward: 120,
    title: "Our Dynamic Earth",
    description: "Discover Earth's systems, environment, and the processes that shape our planet.",
    dialogue: "Greetings, Young Scientist! Defeat the Earth minions and the Earth Titan with your science knowledge!",
    objectives: [
      "Identify Earth's major systems.",
      "Understand environmental processes.",
      "Recognize ways people can protect Earth."
    ],
    concepts: ["Geosphere", "Atmosphere", "Environment"],
    summary: "Earth is a dynamic planet made up of interacting systems. Human activities can affect these systems, making environmental awareness important.",
    questions: [
      Question(
        q: "Which layer of Earth do we live on?",
        options: ["Crust", "Core", "Inner core", "Mantle"],
        answer: 0,
        explanation: "We live on Earth's crust, the thin outermost solid layer.",
      ),
      Question(
        q: "Which gas is most abundant in Earth's atmosphere?",
        options: ["Oxygen", "Nitrogen", "Carbon dioxide", "Hydrogen"],
        answer: 1,
        explanation: "Nitrogen makes up about 78% of Earth's atmosphere.",
      ),
      Question(
        q: "What is the process by which water changes into vapor?",
        options: ["Condensation", "Evaporation", "Freezing", "Melting"],
        answer: 1,
        explanation: "Evaporation happens when liquid water changes into water vapor.",
      ),
      Question(
        q: "Which is an example of renewable energy?",
        options: ["Coal", "Oil", "Solar energy", "Natural gas"],
        answer: 2,
        explanation: "Solar energy comes from the Sun and is naturally replenished.",
      ),
      Question(
        q: "What protects Earth from much of the Sun's harmful ultraviolet radiation?",
        options: ["Ozone layer", "Clouds", "Oceans", "Soil"],
        answer: 0,
        explanation: "The ozone layer absorbs much of the Sun's harmful ultraviolet radiation.",
      ),
    ],
  ),
  9: GradeMission(
    id: 9,
    name: "Chemistry Guardian",
    guardian: "Professor Chem",
    emoji: "🧪",
    mission: "Matter and Reactions",
    reward: 150,
    title: "Matter and Chemical Reactions",
    description: "Learn about matter, elements, compounds, and the changes that happen during reactions.",
    dialogue: "Welcome to the laboratory! Defeat the chemical minions and the Reaction Beast using your science knowledge!",
    objectives: [
      "Identify different forms of matter.",
      "Distinguish elements and compounds.",
      "Understand basic chemical reactions."
    ],
    concepts: ["Matter", "Element", "Chemical Reaction"],
    summary: "Matter has mass and occupies space. Elements and compounds make up many substances, while chemical reactions transform substances into new products.",
    questions: [
      Question(
        q: "Which state of matter has a definite volume but no definite shape?",
        options: ["Solid", "Liquid", "Gas", "Plasma"],
        answer: 1,
        explanation: "A liquid has a definite volume but takes the shape of its container.",
      ),
      Question(
        q: "What is the smallest unit of an element that retains its properties?",
        options: ["Atom", "Cell", "Molecule", "Tissue"],
        answer: 0,
        explanation: "An atom is the smallest unit of an element that retains its chemical properties.",
      ),
      Question(
        q: "Which is an example of a chemical change?",
        options: ["Melting ice", "Cutting paper", "Rusting iron", "Breaking glass"],
        answer: 2,
        explanation: "Rusting forms a new substance, iron oxide, so it is a chemical change.",
      ),
      Question(
        q: "What is H₂O commonly called?",
        options: ["Oxygen", "Hydrogen", "Water", "Salt"],
        answer: 2,
        explanation: "H₂O is the chemical formula for water.",
      ),
      Question(
        q: "Which particle has a negative charge?",
        options: ["Proton", "Neutron", "Electron", "Nucleus"],
        answer: 2,
        explanation: "Electrons have a negative electrical charge.",
      ),
    ],
  ),
  10: GradeMission(
    id: 10,
    name: "Space Science Guardian",
    guardian: "Professor Nova",
    emoji: "🪐",
    mission: "Universe and Astronomy",
    reward: 200,
    title: "Journey Through the Universe",
    description: "Explore planets, stars, galaxies, and the amazing scale of our universe.",
    dialogue: "Prepare for launch! Defeat the space minions and the Galaxy Overlord by mastering astronomy!",
    objectives: [
      "Identify objects in our solar system.",
      "Understand basic astronomy concepts.",
      "Explore the relationship between Earth and the Sun."
    ],
    concepts: ["Solar System", "Planet", "Galaxy"],
    summary: "Our solar system contains the Sun, planets, moons, and other objects. Beyond it are countless stars and galaxies across the universe.",
    questions: [
      Question(
        q: "Which star is at the center of our solar system?",
        options: ["Sirius", "Polaris", "The Sun", "Alpha Centauri"],
        answer: 2,
        explanation: "The Sun is the star at the center of our solar system.",
      ),
      Question(
        q: "Which planet is known as the Red Planet?",
        options: ["Venus", "Mars", "Jupiter", "Mercury"],
        answer: 1,
        explanation: "Mars appears reddish because of iron minerals in its surface material.",
      ),
      Question(
        q: "What force keeps planets in orbit around the Sun?",
        options: ["Friction", "Gravity", "Magnetism", "Pressure"],
        answer: 1,
        explanation: "Gravity from the Sun keeps planets in their orbits.",
      ),
      Question(
        q: "Which is the largest planet in our solar system?",
        options: ["Earth", "Saturn", "Jupiter", "Neptune"],
        answer: 2,
        explanation: "Jupiter is the largest planet in our solar system.",
      ),
      Question(
        q: "What galaxy contains our solar system?",
        options: ["Andromeda", "Milky Way", "Whirlpool", "Sombrero"],
        answer: 1,
        explanation: "Our solar system is located in the Milky Way galaxy.",
      ),
    ],
  ),
};

final List<AchievementItem> allAchievements = const [
  AchievementItem(
    id: "firstMission",
    icon: "🚀",
    title: "First Mission",
    description: "Complete your first mission.",
  ),
  AchievementItem(
    id: "perfectScore",
    icon: "⭐",
    title: "Perfect Score",
    description: "Answer every question correctly.",
  ),
  AchievementItem(
    id: "scienceExplorer",
    icon: "🔬",
    title: "Science Explorer",
    description: "Complete missions from different grades.",
  ),
  AchievementItem(
    id: "biologyMaster",
    icon: "🧬",
    title: "Biology Master",
    description: "Complete Grade 7.",
  ),
  AchievementItem(
    id: "earthExpert",
    icon: "🌎",
    title: "Earth Expert",
    description: "Complete Grade 8.",
  ),
  AchievementItem(
    id: "chemistryGenius",
    icon: "🧪",
    title: "Chemistry Genius",
    description: "Complete Grade 9.",
  ),
  AchievementItem(
    id: "spaceExplorer",
    icon: "🪐",
    title: "Space Explorer",
    description: "Complete Grade 10.",
  ),
  AchievementItem(
    id: "allGrades",
    icon: "🏆",
    title: "Master Scientist",
    description: "Complete Grades 7–10.",
  ),
  AchievementItem(
    id: "speedScientist",
    icon: "⚡",
    title: "Speed Scientist",
    description: "Complete a mission quickly with no wrong answers.",
  ),
];
