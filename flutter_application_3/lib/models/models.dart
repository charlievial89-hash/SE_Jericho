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

class WarmUpQuestion {
  final String id;
  final int afterTopicNumber;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
  final String clue;

  const WarmUpQuestion({
    required this.id,
    required this.afterTopicNumber,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.clue,
  });
}

class LessonCard {
  final String icon;
  final String title;
  final String subtitle;
  final String content;
  final List<String> bulletPoints;
  final int topicNumber;
  final String category;
  final String? analogy;
  final String? filipinoNote;
  final String? rememberThis;

  const LessonCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.content,
    this.bulletPoints = const [],
    this.topicNumber = 1,
    this.category = "Cell Basics",
    this.analogy,
    this.filipinoNote,
    this.rememberThis,
  });
}

class TermMission {
  final int termNumber;
  final String title;
  final String topic;
  final String subtitle;
  final String description;
  final String dialogue;
  final String emoji;
  final String guardianName;
  final String guardianEmoji;
  final String guardianTitle;
  final int guardianMaxHP;
  final DateTime defaultStartDateTime;
  final bool isContentReady;
  final List<String> objectives;
  final List<String> concepts;
  final List<LessonCard> cards;
  final List<WarmUpQuestion> warmUps;
  final String summary;
  final List<Question> questions;

  TermMission({
    required this.termNumber,
    required this.title,
    required this.topic,
    required this.subtitle,
    required this.description,
    required this.dialogue,
    required this.emoji,
    required this.guardianName,
    required this.guardianEmoji,
    required this.guardianTitle,
    required this.guardianMaxHP,
    required this.defaultStartDateTime,
    required this.isContentReady,
    required this.objectives,
    required this.concepts,
    required this.cards,
    this.warmUps = const [],
    required this.summary,
    required this.questions,
  });

  // Backward compatibility getters
  int get id => termNumber;
  String get name => "$topic Guardian";
  String get guardian => guardianName;
  String get mission => topic;
}

typedef GradeMission = TermMission;

class QuizResult {
  final int id;
  final String studentName;
  final int grade; // Represents term number or grade 7
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
  List<int> completedGrades; // Stores completed terms (e.g. 1)
  Map<String, bool> achievements;
  int xp;
  int level;
  int totalPoints;

  StudentProfile({
    required this.name,
    List<int>? completedGrades,
    Map<String, bool>? achievements,
    this.xp = 0,
    this.level = 1,
    this.totalPoints = 0,
  })  : completedGrades = completedGrades ?? [],
        achievements = achievements ??
            {
              "firstMission": false,
              "perfectScore": false,
              "cellMaster": false,
              "speedScientist": false,
              "termMaster": false,
            };

  int get nextXP => level * 100;
  double get xpProgressPercent => ((xp % nextXP) / nextXP).clamp(0.0, 1.0);

  Map<String, dynamic> toJson() => {
        'name': name,
        'completedGrades': completedGrades,
        'achievements': achievements,
        'xp': xp,
        'level': level,
        'totalPoints': totalPoints,
      };

  factory StudentProfile.fromJson(Map<String, dynamic> json) => StudentProfile(
        name: json['name'] as String,
        // 'coins', 'lastReward', 'bonusRewards' are silently ignored if present in old save data
        completedGrades: (json['completedGrades'] as List?)?.map((e) => (e as num).toInt()).toList() ?? [],
        achievements: (json['achievements'] as Map?)?.map((k, v) => MapEntry(k.toString(), v == true)) ?? {},
        xp: (json['xp'] as num?)?.toInt() ?? 0,
        level: (json['level'] as num?)?.toInt() ?? 1,
        totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      );
}

// Configurable Date/Time Lock Settings
class TermUnlockConfig {
  DateTime term1Start;
  DateTime term2Start;
  DateTime term3Start;
  int timezoneOffsetHours;
  String timezoneName;

  TermUnlockConfig({
    required this.term1Start,
    required this.term2Start,
    required this.term3Start,
    this.timezoneOffsetHours = 8,
    this.timezoneName = "UTC+8 (Local School Time)",
  });

  factory TermUnlockConfig.defaultConfig() {
    return TermUnlockConfig(
      term1Start: DateTime.parse("2026-08-01T08:00:00"),
      term2Start: DateTime.parse("2026-11-15T08:00:00"),
      term3Start: DateTime.parse("2027-02-15T08:00:00"),
      timezoneOffsetHours: 8,
      timezoneName: "UTC+8 (Local School Time)",
    );
  }

  DateTime getNowInSchoolTime() {
    return DateTime.now().toUtc().add(Duration(hours: timezoneOffsetHours));
  }

  bool isTermUnlocked(int termNumber, [DateTime? testNow]) {
    final now = testNow ?? getNowInSchoolTime();
    if (termNumber == 1) {
      return now.isAfter(term1Start) || now.isAtSameMomentAs(term1Start);
    } else if (termNumber == 2) {
      return now.isAfter(term2Start) || now.isAtSameMomentAs(term2Start);
    } else if (termNumber == 3) {
      return now.isAfter(term3Start) || now.isAtSameMomentAs(term3Start);
    }
    return false;
  }

  DateTime getStartForTerm(int termNumber) {
    if (termNumber == 1) return term1Start;
    if (termNumber == 2) return term2Start;
    return term3Start;
  }

  Map<String, dynamic> toJson() => {
        'term1Start': term1Start.toIso8601String(),
        'term2Start': term2Start.toIso8601String(),
        'term3Start': term3Start.toIso8601String(),
        'timezoneOffsetHours': timezoneOffsetHours,
        'timezoneName': timezoneName,
      };

  factory TermUnlockConfig.fromJson(Map<String, dynamic> json) {
    final def = TermUnlockConfig.defaultConfig();
    return TermUnlockConfig(
      term1Start: json['term1Start'] != null ? DateTime.tryParse(json['term1Start']) ?? def.term1Start : def.term1Start,
      term2Start: json['term2Start'] != null ? DateTime.tryParse(json['term2Start']) ?? def.term2Start : def.term2Start,
      term3Start: json['term3Start'] != null ? DateTime.tryParse(json['term3Start']) ?? def.term3Start : def.term3Start,
      timezoneOffsetHours: (json['timezoneOffsetHours'] as num?)?.toInt() ?? 8,
      timezoneName: json['timezoneName'] as String? ?? "UTC+8 (Local School Time)",
    );
  }
}

// Built-in Grade 7 Three-Term Missions Data
final Map<int, TermMission> grade7Terms = {
  1: TermMission(
    termNumber: 1,
    title: "TERM 1",
    topic: "Cell Biology",
    subtitle: "Explore the basic unit of life.",
    description: "Discover the microscopic foundations of living organisms, from single cells to complex fungal mycelium networks.",
    dialogue: "Welcome, Young Scientist! I am the Cell Guardian. To complete Term 1, use your biology knowledge to conquer our battle!",
    emoji: "🧬",
    guardianName: "Cell Guardian",
    guardianEmoji: "🦠",
    guardianTitle: "Cell Biology Guardian",
    guardianMaxHP: 10,
    defaultStartDateTime: DateTime.parse("2026-08-01T08:00:00"),
    isContentReady: true,
    objectives: [
      "Understand what a cell is and why it is the basic unit of life.",
      "Learn Robert Hooke's historic observation of cork and coining of the term 'cell'.",
      "Distinguish between prokaryotic and eukaryotic organisms.",
      "Identify unicellular organisms such as bacteria.",
      "Understand the key functions of the cell membrane, mitochondrion, ribosome, and nucleus.",
      "Explain fungal hyphae and mycelium structures."
    ],
    concepts: [
      "Cell (Basic Unit of Life)",
      "Robert Hooke (Cork Observation)",
      "Prokaryote vs. Eukaryote",
      "Unicellular Organism",
      "Cell Membrane (Gatekeeper)",
      "Mitochondrion (Energy / ATP)",
      "Ribosome (Protein Synthesis)",
      "Nucleus (Genetic Vault & DNA)",
      "Hyphae & Mycelium Network"
    ],
    cards: [
      LessonCard(
        topicNumber: 1,
        category: "Cell Basics",
        icon: "🔬",
        title: "1. What is a Cell?",
        subtitle: "The microscopic unit of life",
        content: "Cells are tiny (microscopic) units of life. Together they perform all the jobs that make an organism alive. Your body contains trillions of cells in around 200 different specialized types!",
        bulletPoints: [
          "Examples of cell types: brain cells, bone cells, and heart (cardiac muscle) cells.",
          "Unicellular organisms have only ONE cell (like bacteria).",
          "Multicellular organisms have MANY cells (like humans and trees)."
        ],
        analogy: "Bricks in a House: Cells are like tiny bricks that join together to build a complete house (your body)!",
        filipinoNote: "Ibig sabihin: Kahit gaano kalaki ang tao o hayop, gawa pa rin ito sa pinagsama-samang napakaliit na mga 'blocks' o cells!",
        rememberThis: "Cells are the basic structural and functional building blocks of all living things.",
      ),
      LessonCard(
        topicNumber: 2,
        category: "Discovery & Theory",
        icon: "📜",
        title: "2. How Cells Were Discovered",
        subtitle: "Robert Hooke and the 1665 cork observation",
        content: "Before the early 1600s, people only knew creatures visible to the naked eye. In 1665, English scientist Robert Hooke examined a thin slice of tree cork under an early compound microscope.",
        bulletPoints: [
          "He saw tiny box-shaped compartments and named them 'cellulae' (Latin for 'small rooms') — the origin of 'cell'.",
          "Hooke published his microscopic drawings in his famous 1665 book 'Micrographia'.",
          "What he actually observed were the dead outer cell walls of plant cells.",
          "Hooke was also an inventor (universal joint, camera iris diaphragm, balance spring)."
        ],
        analogy: "Monastery Rooms: The square spaces reminded Hooke of rows of small bare rooms (cells) lived in by monks.",
        filipinoNote: "Ibig sabihin: Ang unang nakita ni Hooke ay mga lumang pader na lang ng patay na plant cells, pero ito ang nagpasimula ng Cell Biology!",
        rememberThis: "Robert Hooke named 'cells' in 1665 in Micrographia after observing cork tissue under a microscope.",
      ),
      LessonCard(
        topicNumber: 3,
        category: "Discovery & Theory",
        icon: "🏛️",
        title: "3. The Cell Theory",
        subtitle: "Schleiden, Schwann, and Virchow",
        content: "In 1839, German botanist Matthias Schleiden and German physician Theodor Schwann unified biology by stating: ALL LIVING THINGS ARE MADE OF CELLS. Rudolf Virchow later added that new cells only come from preexisting cells.",
        bulletPoints: [
          "Classical Cell Theory = Schleiden + Schwann + Virchow.",
          "Modern Addition 1: Energy flows continuously within living cells.",
          "Modern Addition 2: Cells contain DNA, passed to daughter cells during cell division.",
          "Modern Addition 3: All cells share the same basic chemical makeup.",
          "Modern Addition 4: Cell activity depends on subcellular structures inside."
        ],
        analogy: "Family Lineage: Just as children come from living parents, new cells can only be born by dividing from existing living cells.",
        filipinoNote: "Ibig sabihin: Hindi basta sumusulpot ang cell kung saan-saan; nanggagaling lamang sila sa kapwa cell na naghati (cell division)!",
        rememberThis: "All living things are made of cells, and all new cells come from preexisting cells!",
      ),
      LessonCard(
        topicNumber: 4,
        category: "Cell Types",
        icon: "🧬",
        title: "4. Prokaryotic vs. Eukaryotic Cells",
        subtitle: "Cells without and with a true nucleus",
        content: "Cells are categorized into two fundamental architectures based on their internal organization:",
        bulletPoints: [
          "Prokaryotic Cell: NO true membrane-bound nucleus and NO membrane-bound organelles. Simpler structure. Example: bacterium.",
          "Eukaryotic Cell: HAS a true nucleus enclosing its DNA, plus membrane-bound organelles. Examples: protozoa, fungi, plants, and animals.",
          "Memory trick: 'Pro' = NO nucleus. 'Eu' = TRUE nucleus.",
          "Bacteria parts: capsule, cell wall, flagellum tail, pili, plasmid, nucleoid DNA area, ribosomes.",
          "Muscle cells contain significantly more mitochondria because they constantly need ATP energy to contract."
        ],
        analogy: "Studio Apartment vs. Multi-Room Mansion: A prokaryote is like an open studio (all in one space); a eukaryote is a mansion with separate dedicated rooms (organelles)!",
        filipinoNote: "Tandaan: 'Pro' = walang true nucleus (lumulutang lang ang DNA). 'Eu' = may tunay at protektadong nucleus!",
        rememberThis: "'Pro' = NO nucleus (bacteria); 'Eu' = TRUE nucleus (plants, animals, fungi).",
      ),
      LessonCard(
        topicNumber: 5,
        category: "Cell Types",
        icon: "👥",
        title: "5. Unicellular vs. Multicellular",
        subtitle: "Solo organisms vs. cooperative teams",
        content: "Organisms are organized by cell count. A unicellular organism is a complete creature made of just ONE cell. Multicellular organisms consist of millions or trillions of cooperating cells.",
        bulletPoints: [
          "Unicellular: One cell carries out feeding, respiration, movement, and reproduction (e.g., bacteria, Amoeba, Paramecium).",
          "Multicellular: Cells depend on each other and specialize for distinct bodily tasks (e.g., plants, animals, most fungi).",
          "Specialized cells work together to form tissues, organs, and organ systems."
        ],
        analogy: "Solo Adventurer vs. Sports Team: Unicellular is a person doing all chores alone; multicellular is a championship team where each player has a dedicated role!",
        filipinoNote: "Ibig sabihin: Sa unicellular, kayang mabuhay ng nag-iisang cell. Sa multicellular tulad natin, kailangang magtulungan ng bilyun-bilyong cells!",
        rememberThis: "Unicellular = one cell does all life jobs. Multicellular = specialized cells work as a team.",
      ),
      LessonCard(
        topicNumber: 6,
        category: "Microbes & Kingdoms",
        icon: "🦠",
        title: "6. Bacteria — Ancient Survivors",
        subtitle: "Earth's oldest and most abundant organisms",
        content: "Bacteria are one of Earth's most abundant organisms, thriving on doorknobs, soil, coins, and inside our digestive systems. They have existed for more than 3.5 billion years!",
        bulletPoints: [
          "Around 3,000 bacteria could fit inside the period (.) at the end of a sentence.",
          "Prokaryotic: no nucleus, but fully alive and performing all life activities.",
          "Bacillus = Rod-shaped; Coccus = Spherical / round; Spirillum = Spiral.",
          "Vibrio = Comma-shaped; Spirochete = Coiled.",
          "Bacteria can live solitary, in colonies, clusters, or chains, and drive essential nutrient cycles."
        ],
        analogy: "Microscopic Nanobots: Billions of tiny microscopic machines running silently on every surface across the planet.",
        filipinoNote: "Ibig sabihin: Napakaliit ngunit napakatatag ng bacteria — 3.5 bilyong taon na silang naninirahan sa Mundo bago pa nagkaroon ng mga hayop!",
        rememberThis: "Bacteria are ancient prokaryotes with 5 main shapes: Bacillus (rod), Coccus (round), Spirillum (spiral), Vibrio (comma), and Spirochete (coiled).",
      ),
      LessonCard(
        topicNumber: 7,
        category: "Microbes & Kingdoms",
        icon: "🌊",
        title: "7. Protists — Diverse Eukaryotes",
        subtitle: "Plantlike, Animallike, and Fungus-like protists",
        content: "Protists are eukaryotic organisms that are not true plants, animals, or fungi. They are divided into three major functional groups based on nutrition and lifestyle:",
        bulletPoints: [
          "Plantlike Protists (Algae): Autotrophic (make their own food). Phytoplankton floating in waters produce 50% to 85% of Earth's atmospheric oxygen! Dinoflagellates have 2 flagella and can trigger toxic 'red tide'.",
          "Animallike Protists (Protozoans): Heterotrophic. Amoeba moves with pseudopodia ('false feet'); Paramecium glides via cilia; Trypanosoma uses a flagellum. Contractile vacuoles pump out extra water so cells don't burst.",
          "Fungus-like Protists (Slime molds): Saprophytic decomposers that feed on rotting organic material."
        ],
        analogy: "Nature's Oxygen Pumps: Tiny microscopic phytoplankton floating in the sea produce more than half the oxygen in the air we breathe!",
        filipinoNote: "Ibig sabihin: Ang amoeba ay gumagapang gamit ang 'false feet' (pseudopodia), habang ang phytoplankton ang nagbibigay sa atin ng sariwang hangin!",
        rememberThis: "Protists include plantlike algae (oxygen producers), animallike protozoans (amoeba, paramecium), and fungus-like slime molds.",
      ),
      LessonCard(
        topicNumber: 8,
        category: "Microbes & Kingdoms",
        icon: "🍄",
        title: "8. Fungi — Hyphae & Mycelium",
        subtitle: "Yeasts, molds, and mushrooms",
        content: "Fungi are eukaryotic decomposers with cell walls made of CHITIN. They have NO chlorophyll and cannot perform photosynthesis. Instead, they absorb nutrients from dead matter (saprophytic) or act as parasites.",
        bulletPoints: [
          "Yeasts are unicellular and reproduce by budding.",
          "Molds and mushrooms are multicellular and reproduce using microscopic spores.",
          "Hyphae: Long, slender, thread-like filaments of fungal cells.",
          "Mycelium: A dense, interconnected network of hyphae (the fuzzy web seen on old bread or beneath forest soil).",
          "Bread mold features rhizoids (anchors), stolons, and a sporangium (spore case)."
        ],
        analogy: "Underground Fiber-Optic Network: The mycelium spreads beneath the ground like an extensive web of cables absorbing food and moisture!",
        filipinoNote: "Ibig sabihin: Hindi halaman ang mushroom dahil wala itong chlorophyll; gawa sa chitin ang cell wall nito at may network ng hyphae na tinatawag na mycelium!",
        rememberThis: "Fungi have chitin cell walls, absorb organic nutrients (saprophytic), and form mycelium networks of threadlike hyphae.",
      ),
      LessonCard(
        topicNumber: 9,
        category: "Cell Anatomy",
        icon: "🛡️",
        title: "9. Parts of a Cell — Membrane, Nucleus, & Cytoplasm",
        subtitle: "The three foundational regions of a eukaryotic cell",
        content: "A eukaryotic cell is divided into three primary zones that maintain life: the outer Cell Membrane, the central Nucleus, and the fluid Cytoplasm.",
        bulletPoints: [
          "Cell Membrane (Plasma Membrane) = 'The Gatekeeper'. A flexible phospholipid bilayer (hydrophilic water-loving heads and hydrophobic tails) with protein channels. It is semipermeable, regulating what moves in and out.",
          "Nucleus = 'The Command Center / Genetic Vault'. Contains the organism's DNA/chromatin. The nuclear envelope contains ~2,000 nuclear pores for molecular transport, and the nucleolus makes ribosomes.",
          "Cytoplasm = The largest part by volume. Contains jelly-like cytosol and suspended organelles where vital metabolic reactions take place."
        ],
        analogy: "The School Grounds: The cell membrane is the school gate and security guard; the nucleus is the principal's office with all student records; and the cytoplasm is the open school quadrangle where everyone interacts!",
        filipinoNote: "Ibig sabihin: Ang membrane ang nagbabantay sa gate, ang nucleus ang punong-guro na may hawak ng mga plano (DNA), at ang cytoplasm ang malawak na espasyo sa loob!",
        rememberThis: "The 3 basic cell parts: Cell Membrane (gatekeeper), Nucleus (control center & DNA), and Cytoplasm (internal fluid space).",
      ),
      LessonCard(
        topicNumber: 10,
        category: "Organelles",
        icon: "⚙️",
        title: "10. Organelles & Their Jobs",
        subtitle: "Specialized cellular machinery",
        content: "Organelles are specialized cellular compartments that carry out unique tasks to sustain the living cell:",
        bulletPoints: [
          "Endoplasmic Reticulum (ER): Transport network. Rough ER has ribosomes (makes proteins); Smooth ER lacks ribosomes (makes lipids & steroids).",
          "Golgi Body: Packaging & shipping center. Stacks of flat discs that modify and package materials into vesicles.",
          "Lysosome: Recycling & cleanup crew with digestive enzymes that destroy worn-out parts.",
          "Peroxisome: Detox center. Uses catalase to convert toxic hydrogen peroxide into safe water and oxygen.",
          "Mitochondria: The 'Powerhouse' / energy generator! Converts nutrients into ATP energy via cellular respiration. Active liver/muscle cells have thousands.",
          "Vacuole: Storage tank for water, food, and pigments. One large central vacuole in plants maintains turgor pressure; small vacuoles in animals.",
          "Ribosome: Tiny protein factories. Assembles amino acids into proteins guided by mRNA.",
          "Cytoskeleton: Internal scaffolding made of microfilaments and microtubules for strength and motility."
        ],
        analogy: "A Busy City: Power station (mitochondria), factories (ribosomes), highways & courier trucks (ER), post office (Golgi), and sanitation crew (lysosomes)!",
        filipinoNote: "Ibig sabihin: Ang mitochondria ang nagbibigay ng kuryente (ATP) para makapagtrabaho ang protein factories (ribosomes) at mailipat sa Golgi body!",
        rememberThis: "Mitochondria generate ATP energy, ribosomes make proteins, ER transports, Golgi packages, and lysosomes digest waste.",
      ),
      LessonCard(
        topicNumber: 11,
        category: "Specialized Structures",
        icon: "🌿",
        title: "11. Specialized Organelles in Specific Organisms",
        subtitle: "Chloroplasts, Centrioles, Cell Walls, & Junctions",
        content: "Different kingdoms adapt specific organelles to thrive in their ecological niches:",
        bulletPoints: [
          "Plastids / Chloroplast: Found in plants and algae. Contains green chlorophyll to capture light energy for photosynthesis ('food factory'). Chromoplasts store colors; leucoplasts store starch.",
          "Centrioles: Rod-like structures found in pairs in ANIMAL cells. Organize spindle fibers that pull chromosomes apart during cell division.",
          "Cell Wall: Rigid protective outer wall made of cellulose in plants (also in fungi with chitin, bacteria with peptidoglycan). Keeps plants upright. Animal cells have NO cell wall!",
          "Plasmodesmata: Microscopic channels connecting neighboring plant cells through their cell walls.",
          "Animal Cell Junctions: Tight junctions (seal leaks), Desmosomes (resist stretch), and Gap junctions (rapid communication channels)."
        ],
        analogy: "Solar Panels & Armor: Chloroplasts are solar panels converting sunlight to sugar, while the cellulose cell wall is a sturdy protective wooden fortress around plant cells!",
        filipinoNote: "Ibig sabihin: Ang halaman ay may sariling 'armor' (cell wall) at 'solar generator' (chloroplast) kaya nakakatayo sila nang tuwid kahit walang skeleton!",
        rememberThis: "Plants have chloroplasts, cellulose cell walls, and large central vacuoles; animal cells have centrioles and cell junctions, but NO cell wall.",
      ),
      LessonCard(
        topicNumber: 12,
        category: "Comparison",
        icon: "⚖️",
        title: "12. Plant Cell vs. Animal Cell",
        subtitle: "Comparing structures and Table 4-4 distinctions",
        content: "Both plant and animal cells are eukaryotic and share fundamental organelles, but key differences define their structure and function:",
        bulletPoints: [
          "Shared Organelles: Cell membrane, nucleus, cytoplasm, ER, Golgi body, mitochondria, vacuoles, ribosomes, cytoskeleton, peroxisomes.",
          "Found ONLY in Plant Cells: Rigid cellulose Cell Wall, Chloroplasts/plastids, and One Large Central Vacuole.",
          "Found ONLY in Animal Cells: Centrioles for cell division, Cell Junctions (tight/gap/desmosomes), and Small Vacuoles.",
          "Textbook reference (Table 4-4): Lysosomes are marked as typical in animal cells and absent in plant cells; peroxisomes are present in both."
        ],
        analogy: "Stone Fortress vs. Flexible Creature: Plant cells have rigid rectangular outer walls; animal cells are flexible, allowing muscles and limbs to bend!",
        filipinoNote: "Tandaan: Walang cell wall ang animal cells kaya malambot ang balat at nakakagalaw ang mga hayop at tao!",
        rememberThis: "Plant cells = Cell Wall + Chloroplasts + 1 Large Central Vacuole. Animal cells = Flexible membrane + Centrioles + Small Vacuoles.",
      ),
      LessonCard(
        topicNumber: 13,
        category: "Cell Teamwork",
        icon: "🤝",
        title: "13. Division of Labor & Cell Cooperation",
        subtitle: "How organelles collaborate as a unified team",
        content: "In a cell, each organelle has its own specific duty (division of labor), yet all organelles constantly support each other (cooperation). If one organelle fails, the entire cell suffers!",
        bulletPoints: [
          "The Protein Assembly Chain: Nucleus sends mRNA blueprint -> Ribosomes build the protein -> Rough ER folds and transports it -> Golgi Body packages it into vesicles -> Cell Membrane secretes it!",
          "Mitochondria supply ATP energy at every stage of the assembly chain.",
          "Lysosomes and peroxisomes clean wastes and detoxify poisons to keep the cellular workspace safe.",
          "Gelatin Model Mini-Lab: Bowl = Cell membrane/wall; gelatin = cytoplasm; purple grape = nucleus; raisins = mitochondria; sprinkles = ribosomes!"
        ],
        analogy: "School Community: The principal (nucleus), teachers (ribosomes), campus couriers (ER), mailroom (Golgi), electrical generator (mitochondria), and janitors (lysosomes) work together in harmony!",
        filipinoNote: "Ibig sabihin: Kailangan ng 'bayanihan' sa loob ng cell! Walang silbi ang gawa ng ribosome kung hindi ito ibabalot ng Golgi at bibigyan ng kuryente ng mitochondria!",
        rememberThis: "Cells succeed through division of labor and teamwork: Nucleus directs, Ribosomes build, ER transports, Golgi packages, and Mitochondria power the team!",
      ),
    ],
    warmUps: [
      WarmUpQuestion(
        id: "warmup_1",
        afterTopicNumber: 3,
        question: "Who coined the word 'cell' in 1665 after observing cork under a microscope?",
        options: ["Rudolf Virchow", "Robert Hooke", "Theodor Schwann", "Matthias Schleiden"],
        answer: 1,
        explanation: "Correct! Robert Hooke observed cork compartments and called them 'cellulae' in his 1665 book Micrographia.",
        clue: "Think of the English scientist who published the famous book 'Micrographia' in 1665!",
      ),
      WarmUpQuestion(
        id: "warmup_2",
        afterTopicNumber: 5,
        question: "Which organism is an example of a unicellular prokaryote with NO true nucleus?",
        options: ["Bacterium", "Human muscle cell", "Mushroom", "Oak tree"],
        answer: 0,
        explanation: "Great job! Bacteria are single-celled organisms that lack a membrane-bound nucleus, making them unicellular prokaryotes.",
        clue: "Look for the ancient single-celled microbe that has existed for more than 3.5 billion years.",
      ),
      WarmUpQuestion(
        id: "warmup_3",
        afterTopicNumber: 8,
        question: "What is the dense, interconnected network of threadlike fungal filaments (hyphae) called?",
        options: ["Pseudopodia", "Mycelium", "Peptidoglycan", "Cytosol"],
        answer: 1,
        explanation: "Spot on! Individual fungal threads are called hyphae, and their vast interconnected web is called a mycelium.",
        clue: "It is the fuzzy white network that spreads through soil or old bread to absorb nutrients.",
      ),
      WarmUpQuestion(
        id: "warmup_4",
        afterTopicNumber: 10,
        question: "Which organelle is known as the energy generator or 'powerhouse' that produces ATP?",
        options: ["Golgi apparatus", "Lysosome", "Mitochondrion", "Vacuole"],
        answer: 2,
        explanation: "Correct! Mitochondria perform cellular respiration to turn food nutrients into usable ATP energy.",
        clue: "Active muscle cells have thousands of these organelles to power constant contraction!",
      ),
    ],
    summary: "Cells are the basic units of life. While prokaryotes like bacteria lack a true nucleus, eukaryotes house DNA within a nucleus and utilize specialized organelles: mitochondria generate ATP energy, ribosomes synthesize proteins, and the cell membrane regulates transport. Multicellular fungi create vast mycelium networks from filaments called hyphae.",
    questions: [
      Question(
        q: "What is the basic unit of life?",
        options: ["Tissue", "Organ", "Cell", "Organ system"],
        answer: 2,
        explanation: "The cell is the basic structural and functional unit of life.",
      ),
      Question(
        q: "Who coined the term “cell” after observing cork?",
        options: ["Theodor Schwann", "Robert Hooke", "Rudolf Virchow", "Matthias Schleiden"],
        answer: 1,
        explanation: "Robert Hooke coined the term “cell” after observing cork under a microscope in 1665.",
      ),
      Question(
        q: "Which type of cell does NOT have a true nucleus?",
        options: ["Animal cell", "Plant cell", "Eukaryotic cell", "Prokaryotic cell"],
        answer: 3,
        explanation: "Prokaryotic cells do not possess a true membrane-bound nucleus.",
      ),
      Question(
        q: "Which organism is an example of a prokaryote?",
        options: ["Amoeba", "Paramecium", "Bacterium", "Mushroom"],
        answer: 2,
        explanation: "Bacteria are unicellular prokaryotic organisms.",
      ),
      Question(
        q: "What do we call an organism made up of only one cell?",
        options: ["Multicellular", "Unicellular", "Colonial", "Specialized"],
        answer: 1,
        explanation: "An organism composed of only a single cell is unicellular.",
      ),
      Question(
        q: "What is the main function of the cell membrane?",
        options: ["Produce ATP", "Store DNA", "Control movement of materials into and out of the cell", "Produce ribosomes"],
        answer: 2,
        explanation: "The cell membrane controls and regulates the movement of materials into and out of the cell.",
      ),
      Question(
        q: "Which organelle is known as the energy generator of the cell?",
        options: ["Golgi apparatus", "Lysosome", "Mitochondrion", "Vacuole"],
        answer: 2,
        explanation: "The mitochondrion is known as the energy generator of the cell, producing ATP.",
      ),
      Question(
        q: "Which organelle is responsible for protein synthesis?",
        options: ["Ribosome", "Lysosome", "Vacuole", "Peroxisome"],
        answer: 0,
        explanation: "Ribosomes are responsible for protein synthesis.",
      ),
      Question(
        q: "Which structure contains the cell's DNA in a eukaryotic cell?",
        options: ["Golgi apparatus", "Nucleus", "Cytoplasm", "Cell membrane"],
        answer: 1,
        explanation: "In a eukaryotic cell, the DNA is contained inside the nucleus.",
      ),
      Question(
        q: "What is a network of hyphae called?",
        options: ["Nucleoid", "Mycelium", "Cytosol", "Chromatin"],
        answer: 1,
        explanation: "A network of hyphae is called a mycelium.",
      ),
    ],
  ),
  2: TermMission(
    termNumber: 2,
    title: "TERM 2",
    topic: "Coming Soon",
    subtitle: "Locked until Term 2 start",
    description: "Grade 7 Term 2 curriculum content will be unlocked when Term 2 officially begins.",
    dialogue: "Term 2 is currently locked. Master Term 1 Cell Biology first!",
    emoji: "🔒",
    guardianName: "Term 2 Guardian",
    guardianEmoji: "🛡️",
    guardianTitle: "Term 2 Boss",
    guardianMaxHP: 10,
    defaultStartDateTime: DateTime.parse("2026-11-15T08:00:00"),
    isContentReady: false,
    objectives: [],
    concepts: [],
    cards: [],
    summary: "Term 2 curriculum content will be provided later.",
    questions: [],
  ),
  3: TermMission(
    termNumber: 3,
    title: "TERM 3",
    topic: "Coming Soon",
    subtitle: "Locked until Term 3 start",
    description: "Grade 7 Term 3 / Level 3 curriculum content unlocks automatically at the exact configured date and time.",
    dialogue: "Level 3 is locked until official Term 3 start date and time!",
    emoji: "🔒",
    guardianName: "Term 3 Guardian",
    guardianEmoji: "⚡",
    guardianTitle: "Level 3 Boss",
    guardianMaxHP: 10,
    defaultStartDateTime: DateTime.parse("2027-02-15T08:00:00"),
    isContentReady: false,
    objectives: [],
    concepts: [],
    cards: [],
    summary: "Term 3 curriculum content will be provided later.",
    questions: [],
  ),
};

final Map<int, GradeMission> scienceQuestGrades = grade7Terms;

final List<AchievementItem> allAchievements = const [
  AchievementItem(
    id: "cellExplorer",
    icon: "🔬",
    title: "Cell Explorer",
    description: "Inspect organelles in the interactive cell diagram.",
  ),
  AchievementItem(
    id: "warmUpAce",
    icon: "🎯",
    title: "Warm-Up Ace",
    description: "Solve a quick warm-up practice check in the lesson.",
  ),
  AchievementItem(
    id: "firstMission",
    icon: "⚔️",
    title: "First Victory",
    description: "Conquer your first Grade 7 quiz battle.",
  ),
  AchievementItem(
    id: "streakMaster",
    icon: "🔥",
    title: "Combo Master",
    description: "Achieve a 3x or higher consecutive Biology Streak.",
  ),
  AchievementItem(
    id: "clutchAnswer",
    icon: "⏰",
    title: "Clutch Biologist",
    description: "Answer correctly under pressure with < 5s on the timer.",
  ),
  AchievementItem(
    id: "perfectScore",
    icon: "⭐",
    title: "Flawless Scientist",
    description: "Answer all 10 battle questions with 100% accuracy.",
  ),
  AchievementItem(
    id: "cellMaster",
    icon: "🦠",
    title: "Cell Guardian Slayer",
    description: "Deplete the Cell Guardian's HP to 0 in battle.",
  ),
  AchievementItem(
    id: "termMaster",
    icon: "🏆",
    title: "Term 1 Graduate",
    description: "Complete Grade 7 Term 1 Cell Biology with passing score (70%+).",
  ),
];

