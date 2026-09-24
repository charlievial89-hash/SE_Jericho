import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/certificate_painter.dart';
import '../widgets/gamification_hud.dart';

// =========================================================
// CELL GUARDIAN AVATAR WIDGET
// =========================================================
class CellGuardianAvatar extends StatelessWidget {
  final double size;
  final bool isHit;

  const CellGuardianAvatar({super.key, this.size = 80, this.isHit = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: isHit
              ? [const Color(0xFFF87171), const Color(0xFF991B1B)]
              : [const Color(0xFF22D3EE), const Color(0xFF0D9488), const Color(0xFF042F2E)],
          radius: 0.85,
        ),
        boxShadow: [
          BoxShadow(
            color: (isHit ? Colors.redAccent : const Color(0xFF06B6D4)).withValues(alpha: 0.45),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: isHit ? Colors.redAccent : const Color(0xFF67E8F9),
          width: 3,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Organelles - Mitochondria (Orange bean)
          Positioned(
            top: size * 0.16,
            right: size * 0.18,
            child: Container(
              width: size * 0.22,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(size * 0.08),
                border: Border.all(color: Colors.white60, width: 1),
              ),
            ),
          ),
          // Organelles - Vacuole / Chloroplast (Green bean)
          Positioned(
            bottom: size * 0.20,
            left: size * 0.16,
            child: Container(
              width: size * 0.20,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(size * 0.08),
                border: Border.all(color: Colors.white60, width: 1),
              ),
            ),
          ),
          // Ribosome dots (Yellow speckles)
          Positioned(
            top: size * 0.30,
            left: size * 0.20,
            child: Container(
              width: size * 0.08,
              height: size * 0.08,
              decoration: const BoxDecoration(
                color: Color(0xFFFBBF24),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: size * 0.26,
            right: size * 0.22,
            child: Container(
              width: size * 0.07,
              height: size * 0.07,
              decoration: const BoxDecoration(
                color: Color(0xFFFBBF24),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Nucleus with membrane & DNA center
          Container(
            width: size * 0.46,
            height: size * 0.46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFFA855F7), Color(0xFF581C87)],
              ),
              border: Border.all(color: const Color(0xFFC084FC), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Video game boss eyes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size * 0.08,
                      height: size * 0.08,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: size * 0.04,
                          height: size * 0.04,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size * 0.06),
                    Container(
                      width: size * 0.08,
                      height: size * 0.08,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: size * 0.04,
                          height: size * 0.04,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size * 0.02),
                // Friendly boss mouth
                Container(
                  width: size * 0.12,
                  height: size * 0.03,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// URGENT TIMER BADGE (PULSES & SHAKES WHEN <= 5s)
// =========================================================
class UrgentTimerBadge extends StatefulWidget {
  final int seconds;

  const UrgentTimerBadge({super.key, required this.seconds});

  @override
  State<UrgentTimerBadge> createState() => _UrgentTimerBadgeState();
}

class _UrgentTimerBadgeState extends State<UrgentTimerBadge> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isUrgent = widget.seconds <= 5 && widget.seconds > 0;

    if (!isUrgent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.darkBg2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "⏱️ ${widget.seconds}s",
          style: const TextStyle(
            color: AppTheme.yellowAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.12);
        final shake = (_pulseController.value - 0.5) * 4.0;

        return Transform.translate(
          offset: Offset(shake, 0),
          child: Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF991B1B), Color(0xFFEF4444)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.yellowAccent, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.7),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                "⏱️ ${widget.seconds}s",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// =========================================================
// COUNTER-ATTACK BUBBLES ANIMATION (BOSS -> PLAYER)
// =========================================================
class CounterAttackBubblesOverlay extends StatefulWidget {
  const CounterAttackBubblesOverlay({super.key});

  @override
  State<CounterAttackBubblesOverlay> createState() => _CounterAttackBubblesOverlayState();
}

class _CounterAttackBubblesOverlayState extends State<CounterAttackBubblesOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;
        final xPos = 0.75 - (progress * 0.55);

        return Stack(
          children: [
            // Soft red flash on player area
            Positioned(
              left: 20,
              top: 100,
              bottom: 100,
              width: 140,
              child: Opacity(
                opacity: (progress > 0.5 ? (1.0 - progress) * 2 : progress * 0.8).clamp(0.0, 0.4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            // Bubble 1 (Main bio-plasma orb)
            Positioned(
              left: MediaQuery.of(context).size.width * xPos,
              top: 140 + (progress * 15),
              child: Opacity(
                opacity: (1.0 - (progress * 0.3)).clamp(0.0, 1.0),
                child: const Text("🫧", style: TextStyle(fontSize: 34)),
              ),
            ),
            // Bubble 2 (Cytoplasmic spore)
            Positioned(
              left: MediaQuery.of(context).size.width * (xPos + 0.05),
              top: 165 - (progress * 20),
              child: Opacity(
                opacity: (1.0 - progress).clamp(0.0, 1.0),
                child: const Text("🦠", style: TextStyle(fontSize: 26)),
              ),
            ),
            // Energy spark
            Positioned(
              left: MediaQuery.of(context).size.width * (xPos - 0.04),
              top: 150 + (progress * 10),
              child: Opacity(
                opacity: (1.0 - progress).clamp(0.0, 1.0),
                child: const Text("✨", style: TextStyle(fontSize: 22)),
              ),
            ),
          ],
        );
      },
    );
  }
}

// =========================================================
// INTERACTIVE CELL DIAGRAM WIDGET (LESSON EXPLORER)
// =========================================================
class InteractiveCellDiagram extends StatefulWidget {
  final QuizController? quizController;

  const InteractiveCellDiagram({super.key, this.quizController});

  @override
  State<InteractiveCellDiagram> createState() => _InteractiveCellDiagramState();
}

class _InteractiveCellDiagramState extends State<InteractiveCellDiagram> {
  String selectedOrganelle = 'nucleus';

  void _select(String organelle) {
    setState(() => selectedOrganelle = organelle);
    widget.quizController?.unlockAchievement("cellExplorer");
  }

  final Map<String, Map<String, dynamic>> organelleData = {
    'nucleus': {
      'name': 'Nucleus',
      'emoji': '🟣',
      'title': 'Control Center & DNA Vault',
      'function':
          'Contains the cell’s DNA in a eukaryotic cell and controls many cell activities, directing growth and reproduction.',
      'color': const Color(0xFFA855F7),
      'tip': 'Vital for Question 9 in the battle!',
    },
    'mitochondrion': {
      'name': 'Mitochondrion',
      'emoji': '🟠',
      'title': 'Energy Generator (Powerhouse)',
      'function':
          'Known as the energy generator of the cell, converting nutrients into usable ATP energy for life processes.',
      'color': const Color(0xFFF97316),
      'tip': 'Vital for Question 7 in the battle!',
    },
    'ribosome': {
      'name': 'Ribosome',
      'emoji': '🔵',
      'title': 'Protein Synthesis Factory',
      'function':
          'Responsible for protein synthesis, linking amino acids together into vital proteins and enzymes.',
      'color': const Color(0xFF38BDF8),
      'tip': 'Vital for Question 8 in the battle!',
    },
    'membrane': {
      'name': 'Cell Membrane',
      'emoji': '🟢',
      'title': 'The Selective Gatekeeper',
      'function':
          'Its main function is to control and regulate the movement of materials into and out of the cell.',
      'color': const Color(0xFF10B981),
      'tip': 'Vital for Question 6 in the battle!',
    },
  };

  @override
  Widget build(BuildContext context) {
    final active = organelleData[selectedOrganelle]!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkBg2,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: (active['color'] as Color).withValues(alpha: 0.5), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("🔬 ", style: TextStyle(fontSize: 22)),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Interactive Cell Diagram",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      "Tap an organelle to inspect its structure and role!",
                      style: TextStyle(color: AppTheme.cyanAccent, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual Cell Graphic with Interactive Hotspots
          Center(
            child: Container(
              width: 290,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(110),
                border: Border.all(
                  color: selectedOrganelle == 'membrane' ? const Color(0xFF10B981) : const Color(0xFF334155),
                  width: selectedOrganelle == 'membrane' ? 4 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (selectedOrganelle == 'membrane' ? const Color(0xFF10B981) : AppTheme.cyanAccent)
                        .withValues(alpha: 0.25),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer membrane tap area label
                  Positioned(
                    top: 10,
                    child: InkWell(
                      onTap: () => _select('membrane'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: selectedOrganelle == 'membrane'
                              ? const Color(0xFF10B981)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF10B981)),
                        ),
                        child: const Text("🟢 Cell Membrane", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  // Mitochondria hotspot
                  Positioned(
                    bottom: 35,
                    left: 22,
                    child: InkWell(
                      onTap: () => _select('mitochondrion'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: selectedOrganelle == 'mitochondrion'
                              ? const Color(0xFFF97316)
                              : const Color(0xFF7C2D12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFB923C), width: selectedOrganelle == 'mitochondrion' ? 2 : 1),
                          boxShadow: selectedOrganelle == 'mitochondrion'
                              ? [BoxShadow(color: const Color(0xFFF97316).withValues(alpha: 0.5), blurRadius: 8)]
                              : [],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("🟠", style: TextStyle(fontSize: 14)),
                            SizedBox(width: 4),
                            Text("Mitochondrion", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Ribosome hotspot
                  Positioned(
                    top: 45,
                    right: 20,
                    child: InkWell(
                      onTap: () => _select('ribosome'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: selectedOrganelle == 'ribosome'
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF0369A1).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF38BDF8), width: selectedOrganelle == 'ribosome' ? 2 : 1),
                          boxShadow: selectedOrganelle == 'ribosome'
                              ? [BoxShadow(color: const Color(0xFF38BDF8).withValues(alpha: 0.5), blurRadius: 8)]
                              : [],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("🔵", style: TextStyle(fontSize: 14)),
                            SizedBox(width: 4),
                            Text("Ribosomes", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Center Nucleus hotspot
                  InkWell(
                    onTap: () => _select('nucleus'),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFFA855F7), Color(0xFF6B21A8)],
                        ),
                        border: Border.all(
                          color: selectedOrganelle == 'nucleus' ? Colors.white : const Color(0xFFC084FC),
                          width: selectedOrganelle == 'nucleus' ? 3 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFA855F7).withValues(alpha: selectedOrganelle == 'nucleus' ? 0.7 : 0.3),
                            blurRadius: 14,
                            spreadRadius: selectedOrganelle == 'nucleus' ? 3 : 1,
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("🟣", style: TextStyle(fontSize: 22)),
                          Text("NUCLEUS", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                          Text("DNA", style: TextStyle(color: Color(0xFFE9D5FF), fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Organelle Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: organelleData.entries.map((entry) {
                final key = entry.key;
                final data = entry.value;
                final bool isSelected = selectedOrganelle == key;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(data['emoji'] as String),
                        const SizedBox(width: 6),
                        Text(data['name'] as String),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => _select(key),
                    selectedColor: (data['color'] as Color).withValues(alpha: 0.35),
                    backgroundColor: AppTheme.darkBg,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: isSelected ? (data['color'] as Color) : Colors.white10,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Detail Card for Selected Organelle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (active['color'] as Color).withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(active['emoji'] as String, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          active['name'] as String,
                          style: TextStyle(
                            color: active['color'] as Color,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (active['color'] as Color).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        active['title'] as String,
                        style: TextStyle(color: active['color'] as Color, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  active['function'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.45),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Text("💡 ", style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          active['tip'] as String,
                          style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                              const Text("🧪 ", style: TextStyle(fontSize: 18)),
                              const Text(
                                "SCIENCE QUEST",
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
                                    color: AppTheme.cyanAccent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        profile.name.isEmpty ? "Tap to Set Name" : profile.name,
                                        style: const TextStyle(
                                          color: AppTheme.cyanAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.edit, size: 12, color: AppTheme.cyanAccent),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF241D08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: const Color(0xFF725C16)),
                            ),
                            child: Row(
                              children: [
                                const Text("🪙 ", style: TextStyle(fontSize: 14)),
                                Text(
                                  "${profile.coins}",
                                  style: const TextStyle(
                                    color: AppTheme.yellowAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Hero Banner - Focused on Grade 7
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.3)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.blueAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.blueAccent.withValues(alpha: 0.4)),
                            ),
                            child: const Text(
                              "GRADE 7 • SCIENCE ADVENTURE",
                              style: TextStyle(
                                color: Color(0xFF93C5FD),
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "🔬 Young Scientist Quest",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Journey through the 3 terms of Grade 7. Master Cell Biology in Term 1 and conquer the Cell Guardian!",
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
                            child: const Text("🚀 START GRADE 7 MISSION"),
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
                          subtitle: "Grade 7 Three-Term Progression",
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
                                  content: Text("🔒 Complete Grade 7 Term 1 first to unlock your certificate."),
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
                          subtitle: "Term unlock & student results.",
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.darkBg.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.mutedText, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNameDialog(BuildContext context) {
    final controller = TextEditingController(text: quizController.profile.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkBg,
        title: const Text("Enter Student Name", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Your name...",
            hintStyle: TextStyle(color: AppTheme.mutedText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                quizController.profile.name = newName;
                StorageService.saveStudentProfile(quizController.profile);
                quizController.updateProfile(quizController.profile);
              }
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// GRADE 7 THREE-TERM PROGRESSION SCREEN
// =========================================================
class GradeSelectionScreen extends StatelessWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const GradeSelectionScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  String _formatDateTime(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return "$y-$m-$d $h:$min";
  }

  @override
  Widget build(BuildContext context) {
    final profile = quizController.profile;
    final config = quizController.unlockConfig;

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
                      "🧑‍🔬 ${profile.name.isEmpty ? 'Young Scientist' : profile.name}",
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.cyanAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.4)),
                            ),
                            child: const Text(
                              "GRADE 7",
                              style: TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.w900, fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Three-Term Progression",
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Progress through Grade 7 terms. Complete lessons and defeat the Cell Guardian in battle!",
                        style: TextStyle(color: AppTheme.mutedText),
                      ),
                      const SizedBox(height: 20),

                      // TERM 1 CARD (Cell Biology - Unlocked)
                      _buildTerm1Card(context, grade7Terms[1]!, profile),

                      const SizedBox(height: 14),

                      // TERM 2 CARD (Locked until date)
                      _buildTerm2Card(context, grade7Terms[2]!, config),

                      const SizedBox(height: 14),

                      // TERM 3 CARD (Date/Time based automated lock/unlock)
                      _buildTerm3Card(context, grade7Terms[3]!, config),

                      const SizedBox(height: 16),
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

  Widget _buildTerm1Card(BuildContext context, TermMission term, StudentProfile profile) {
    final completed = profile.completedGrades.contains(1);

    return InkWell(
      onTap: () {
        quizController.selectedGrade = term;
        onNavigate('guardian');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.darkBg2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Row(
          children: [
            const Text("🧬", style: TextStyle(fontSize: 48)),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "🟢 TERM 1 — Cell Biology",
                        style: TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      Text(
                        "🪙 +${term.reward}",
                        style: const TextStyle(color: AppTheme.yellowAccent, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Cell Biology",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    term.subtitle,
                    style: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (completed ? AppTheme.greenAccent : AppTheme.cyanAccent).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          completed ? "🏆 COMPLETED" : "⚔️ READY FOR BATTLE",
                          style: TextStyle(
                            color: completed ? AppTheme.greenAccent : AppTheme.cyanAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Status: OPEN",
                        style: TextStyle(color: AppTheme.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
    );
  }

  Widget _buildTerm2Card(BuildContext context, TermMission term, TermUnlockConfig config) {
    final bool isUnlocked = config.isTermUnlocked(2);

    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppTheme.darkBg,
              title: const Text("🔒 TERM 2 LOCKED", style: TextStyle(color: Colors.white)),
              content: Text(
                "Term 2 is scheduled to start on:\n${_formatDateTime(config.term2Start)} (${config.timezoneName})\n\nPlease master Term 1 Cell Biology while new content is being prepared!",
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Term 2 questions will be provided soon!")),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.65,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.darkBg2,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Text(isUnlocked ? "🔓" : "🔒", style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isUnlocked ? "🔓 TERM 2 — UNLOCKED" : "🔒 TERM 2 — LOCKED",
                          style: TextStyle(
                            color: isUnlocked ? AppTheme.cyanAccent : AppTheme.mutedText,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "🪙 +${term.reward}",
                          style: const TextStyle(color: AppTheme.yellowAccent, fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Grade 7 Term 2",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      isUnlocked ? "Content Coming Soon" : "Locked until ${_formatDateTime(config.term2Start)}",
                      style: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUnlocked ? "Status: OPEN" : "Status: Coming Soon",
                      style: TextStyle(
                        color: isUnlocked ? AppTheme.cyanAccent : AppTheme.mutedText,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
  }

  Widget _buildTerm3Card(BuildContext context, TermMission term, TermUnlockConfig config) {
    final bool isUnlocked = config.isTermUnlocked(3);

    return InkWell(
      onTap: () {
        if (!isUnlocked) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppTheme.darkBg,
              title: const Text("🔒 LEVEL 3 LOCKED", style: TextStyle(color: Colors.white)),
              content: Text(
                "Unlocks on: ${_formatDateTime(config.term3Start)}\nSchool Timezone: ${config.timezoneName}\n\nTerm 3 unlocks automatically once the exact system date and time is reached.",
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("🔓 LEVEL 3 UNLOCKED! Curriculum will be provided soon.")),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.65,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.darkBg2,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnlocked ? AppTheme.greenAccent.withValues(alpha: 0.5) : Colors.white10,
              width: isUnlocked ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(isUnlocked ? "🔓" : "🔒", style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isUnlocked ? "🔓 LEVEL 3 UNLOCKED" : "🔒 LEVEL 3 LOCKED",
                          style: TextStyle(
                            color: isUnlocked ? AppTheme.greenAccent : const Color(0xFFF87171),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "🪙 +${term.reward}",
                          style: const TextStyle(color: AppTheme.yellowAccent, fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Grade 7 Term 3",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      isUnlocked
                          ? "Unlocked based on scheduled start date/time"
                          : "Unlocks on: ${_formatDateTime(config.term3Start)}",
                      style: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUnlocked ? "Status: OPEN" : "Status: Coming Soon",
                      style: TextStyle(
                        color: isUnlocked ? AppTheme.greenAccent : AppTheme.mutedText,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
  }
}

// =========================================================
// GUARDIAN BRIEFING SCREEN - CELL GUARDIAN
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
    final grade = quizController.selectedGrade ?? grade7Terms[1]!;

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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.blueAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.blueAccent.withValues(alpha: 0.4)),
                      ),
                      child: const Text(
                        "GRADE 7 • TERM 1",
                        style: TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CellGuardianAvatar(size: 110),
                    const SizedBox(height: 16),
                    Text(
                      grade.guardianName,
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      grade.guardianTitle,
                      style: const TextStyle(color: AppTheme.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold),
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
                      child: const Text("📖 START LESSON"),
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
                      child: const Text("⚔️ ENTER BATTLE"),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => onNavigate('grades'),
                      child: const Text("← Grade 7 Terms", style: TextStyle(color: AppTheme.mutedText)),
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
// CELL BIOLOGY LESSON SCREEN (GRADE 7 CURRICULUM)
// =========================================================
class LessonScreen extends StatefulWidget {
  final QuizController quizController;
  final Function(String route, {dynamic arguments}) onNavigate;

  const LessonScreen({
    super.key,
    required this.quizController,
    required this.onNavigate,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  String _selectedCategory = "All";
  final Map<String, int> _selectedWarmUpAnswers = {};
  final Map<String, bool> _submittedWarmUps = {};
  final Map<String, bool> _showClues = {};

  final List<String> _categories = [
    "All",
    "Cell Basics",
    "Discovery & Theory",
    "Cell Types",
    "Microbes & Kingdoms",
    "Cell Anatomy",
    "Organelles",
    "Specialized Structures",
    "Comparison",
    "Cell Teamwork",
  ];

  @override
  Widget build(BuildContext context) {
    final grade = widget.quizController.selectedGrade ?? grade7Terms[1]!;
    final filteredCards = _selectedCategory == "All"
        ? grade.cards
        : grade.cards.where((c) => c.category == _selectedCategory).toList();

    return Scaffold(
      body: Container(
        decoration: AppTheme.mainScreenBackground(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.darkBg.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Status Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.cyanAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.3)),
                        ),
                        child: const Text(
                          "GRADE 7 • TERM 1",
                          style: TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Text(
                        "🧬 ${grade.topic}",
                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Friendly Lesson Guide Persona Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.blueAccent.withValues(alpha: 0.25),
                          AppTheme.purpleAccent.withValues(alpha: 0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.cyanAccent.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.cyanAccent),
                          ),
                          child: const Center(
                            child: Text("👩‍🔬", style: TextStyle(fontSize: 26)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mabuhay, Young Scientist! 👋",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "I am your Lesson Guide and Quiz Master. Study each card below, check out the analogies and Filipino tips ('Ibig sabihin...'), and try the quick Warm-Up checks so you can conquer the Cell Guardian with confidence!",
                                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.45),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _HeaderPill(icon: "📖", label: "13 Topics"),
                                  _HeaderPill(icon: "⚡", label: "4 Warm-Ups"),
                                  _HeaderPill(icon: "🔬", label: "Interactive Diagram"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Main Title
                  const Text(
                    "🧬 Grade 7: The Cell, the Basic Unit of Life",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(grade.description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 18),

                  // Interactive Cell Diagram (Explore organelles)
                  InteractiveCellDiagram(quizController: widget.quizController),
                  const SizedBox(height: 18),

                  // Learning Objectives Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBg2,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text("🎯 ", style: TextStyle(fontSize: 18)),
                            Text("Learning Objectives", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...grade.objectives.map((o) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("• ", style: TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold)),
                                  Expanded(child: Text(o, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Filter Tabs
                  const Text(
                    "📂 Filter by Topic Area",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: AppTheme.cyanAccent.withValues(alpha: 0.25),
                            backgroundColor: AppTheme.darkBg2,
                            labelStyle: TextStyle(
                              color: isSelected ? AppTheme.cyanAccent : Colors.white70,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            side: BorderSide(
                              color: isSelected ? AppTheme.cyanAccent : Colors.white10,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Core Lesson Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "📖 Learn Cards",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${filteredCards.length} of ${grade.cards.length} cards",
                        style: const TextStyle(color: AppTheme.mutedText, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // List of Cards + In-Line Warm-Ups
                  ...filteredCards.expand((card) {
                    final widgets = <Widget>[
                      _buildLessonCard(card),
                    ];

                    // Check if a warm-up belongs after this card's topic
                    final warmUp = grade.warmUps.where((w) => w.afterTopicNumber == card.topicNumber).firstOrNull;
                    if (warmUp != null) {
                      widgets.add(const SizedBox(height: 6));
                      widgets.add(_buildWarmUpCard(warmUp));
                      widgets.add(const SizedBox(height: 16));
                    }

                    return widgets;
                  }),

                  const SizedBox(height: 10),

                  // Lesson Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.blueAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.blueAccent.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text("📚 ", style: TextStyle(fontSize: 20)),
                            Text(
                              "Lesson Summary & Key Takeaway",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          grade.summary,
                          style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.quizController.startQuiz(grade);
                            widget.onNavigate('quiz');
                          },
                          icon: const Text("⚔️", style: TextStyle(fontSize: 18)),
                          label: const Text(
                            "START QUIZ / ENTER BATTLE",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.greenAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => widget.onNavigate('guardian'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          side: const BorderSide(color: Colors.white24),
                        ),
                        child: const Text("← Briefing"),
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

  Widget _buildLessonCard(LessonCard card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkBg2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon, Category Chip, Title, Subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.darkBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Center(
                  child: Text(card.icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.cyanAccent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            card.category.toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.cyanAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          "Topic ${card.topicNumber}",
                          style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(
                      card.subtitle,
                      style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Content
          Text(
            card.content,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),

          // Bullet Points
          if (card.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.darkBg.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: card.bulletPoints.map((bp) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "✓ ",
                          style: TextStyle(color: AppTheme.greenAccent, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            bp,
                            style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Everyday Comparison / Analogy Box
          if (card.analogy != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.purpleAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.purpleAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("🏡 ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Everyday Comparison: ",
                            style: TextStyle(
                              color: AppTheme.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: card.analogy!,
                            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Filipino / Taglish Tip Box
          if (card.filipinoNote != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.yellowAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.yellowAccent.withValues(alpha: 0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("🇵🇭 ", style: TextStyle(fontSize: 15)),
                  Expanded(
                    child: Text(
                      card.filipinoNote!,
                      style: const TextStyle(
                        color: Color(0xFFFDE68A),
                        fontSize: 13,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Remember This Banner
          if (card.rememberThis != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cyanAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("💡 ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Remember This: ",
                            style: TextStyle(
                              color: AppTheme.cyanAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: card.rememberThis!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWarmUpCard(WarmUpQuestion warmUp) {
    final selectedOption = _selectedWarmUpAnswers[warmUp.id];
    final isSubmitted = _submittedWarmUps[warmUp.id] ?? false;
    final isCorrect = selectedOption == warmUp.answer;
    final showClue = _showClues[warmUp.id] ?? false;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSubmitted
              ? (isCorrect ? AppTheme.greenAccent : AppTheme.redAccent.withValues(alpha: 0.8))
              : AppTheme.cyanAccent.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isSubmitted && isCorrect)
                ? AppTheme.greenAccent.withValues(alpha: 0.15)
                : AppTheme.cyanAccent.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.yellowAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.yellowAccent.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("⚡ ", style: TextStyle(fontSize: 12)),
                    Text(
                      "QUICK WARM-UP CHECK",
                      style: TextStyle(
                        color: AppTheme.yellowAccent,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "Easy Practice",
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question Text
          Text(
            warmUp.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // 4 Multiple Choice Options
          ...List.generate(warmUp.options.length, (idx) {
            final optionText = warmUp.options[idx];
            final isCurrentChoice = selectedOption == idx;
            final isTheCorrectAnswer = warmUp.answer == idx;

            Color tileColor = AppTheme.darkBg;
            Color borderColor = Colors.white12;
            Color textColor = Colors.white70;

            if (isSubmitted) {
              if (isTheCorrectAnswer) {
                tileColor = AppTheme.greenAccent.withValues(alpha: 0.2);
                borderColor = AppTheme.greenAccent;
                textColor = Colors.white;
              } else if (isCurrentChoice && !isCorrect) {
                tileColor = AppTheme.redAccent.withValues(alpha: 0.2);
                borderColor = AppTheme.redAccent;
                textColor = Colors.white;
              }
            } else if (isCurrentChoice) {
              tileColor = AppTheme.cyanAccent.withValues(alpha: 0.2);
              borderColor = AppTheme.cyanAccent;
              textColor = Colors.white;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: isSubmitted
                    ? null
                    : () {
                        setState(() {
                          _selectedWarmUpAnswers[warmUp.id] = idx;
                          _submittedWarmUps[warmUp.id] = true;
                        });
                        if (idx == warmUp.answer) {
                          widget.quizController.unlockAchievement("warmUpAce");
                        }
                      },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + idx),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          optionText,
                          style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (isSubmitted && isTheCorrectAnswer)
                        const Icon(Icons.check_circle, color: AppTheme.greenAccent, size: 20)
                      else if (isSubmitted && isCurrentChoice && !isCorrect)
                        const Icon(Icons.cancel, color: AppTheme.redAccent, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Instant Feedback Section
          if (isSubmitted) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppTheme.greenAccent.withValues(alpha: 0.12)
                    : AppTheme.redAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCorrect
                      ? AppTheme.greenAccent.withValues(alpha: 0.4)
                      : AppTheme.redAccent.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(isCorrect ? "🎉 " : "💡 ", style: const TextStyle(fontSize: 18)),
                      Expanded(
                        child: Text(
                          isCorrect ? "Great job! That's correct!" : "Almost there! Let's review:",
                          style: TextStyle(
                            color: isCorrect ? AppTheme.greenAccent : const Color(0xFFFCA5A5),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    warmUp.explanation,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),

                  // Kind clue for student when not correct
                  if (!isCorrect) ...[
                    const SizedBox(height: 8),
                    if (showClue)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.darkBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          warmUp.clue,
                          style: const TextStyle(color: AppTheme.yellowAccent, fontSize: 12),
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showClues[warmUp.id] = true;
                          });
                        },
                        icon: const Icon(Icons.help_outline, color: AppTheme.yellowAccent, size: 16),
                        label: const Text(
                          "Show Friendly Clue",
                          style: TextStyle(color: AppTheme.yellowAccent, fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 30),
                        ),
                      ),
                  ],

                  // Try Again button so student can correct on their own
                  if (!isCorrect) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _submittedWarmUps[warmUp.id] = false;
                            _selectedWarmUpAnswers.remove(warmUp.id);
                          });
                        },
                        icon: const Icon(Icons.refresh, size: 16, color: AppTheme.cyanAccent),
                        label: const Text(
                          "Try Again",
                          style: TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final String icon;
  final String label;

  const _HeaderPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}


// =========================================================
// QUIZ BATTLE SCREEN - 10-ITEM BATTLE AGAINST CELL GUARDIAN
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
                            _buildStatBadge("❤️ ${quizController.lives} Lives"),
                            _buildStatBadge("⭐ Score: ${quizController.score}"),
                            UrgentTimerBadge(seconds: quizController.timer),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Battle Arena: Young Scientist VS Cell Guardian
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
                                      const Text("🧑‍🔬", style: TextStyle(fontSize: 54)),
                                      Text(
                                        quizController.profile.name.isEmpty ? "YOU" : quizController.profile.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
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
                                  // Enemy: Cell Guardian
                                  Column(
                                    children: [
                                      CellGuardianAvatar(
                                        size: 64,
                                        isHit: quizController.isLaserActive && quizController.lastAnswerWasCorrect,
                                      ),
                                      const SizedBox(height: 4),
                                      const Text("Cell Guardian", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 110,
                                        child: LinearProgressIndicator(
                                          value: quizController.enemyMaxHP > 0 ? quizController.enemyHP / quizController.enemyMaxHP : 0,
                                          backgroundColor: Colors.white10,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            quizController.enemyHP > 3 ? AppTheme.redAccent : Colors.orangeAccent,
                                          ),
                                        ),
                                      ),
                                      Text("${quizController.enemyHP}/${quizController.enemyMaxHP} HP", style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.cyanAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "🦠 CELL GUARDIAN BOSS BATTLE",
                                  style: TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.w900, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Biology Streak Banner
                        if (quizController.currentStreak >= 2) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEA580C), Color(0xFFDC2626)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEA580C).withValues(alpha: 0.6),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                              border: Border.all(color: Colors.amberAccent, width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("🔥 ", style: TextStyle(fontSize: 18)),
                                Text(
                                  "${quizController.currentStreak}x Biology Streak! (+${quizController.currentStreak * 2} Coins)",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

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
                                      "Question ${quizController.questionIndex + 1} of ${quizController.quizQuestions.length}",
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
                                  style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 18),

                                // Options List (A, B, C, D)
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
                                              width: 32,
                                              height: 32,
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
                                          quizController.lastAnswerWasCorrect
                                              ? "⚔️ DIRECT HIT! Cell Guardian loses 1 HP!"
                                              : "💔 WRONG ANSWER! Cell Guardian took no damage!",
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
                          color: (quizController.isLaserWrong ? AppTheme.redAccent : AppTheme.cyanAccent).withValues(alpha: 0.18),
                        ),
                      ),
                    ),

                  // Cell Guardian Counter-Attack Bubbles Overlay
                  if (quizController.isCounterAttacking)
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: CounterAttackBubblesOverlay(),
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
    final bool victory = quizController.playerHP > 0 && quizController.correct >= 5;
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
                      victory ? "CELL GUARDIAN DEFEATED!" : "BATTLE ENDED",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      victory
                          ? "Congratulations, Young Scientist! You conquered Grade 7 Term 1 Cell Biology!"
                          : "You answered ${quizController.correct} of $total correctly. Review the lesson and try again!",
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
                        _buildStatBox("Correct", "${quizController.correct}/$total"),
                        _buildStatBox("Accuracy", "$accuracy%"),
                        _buildStatBox("Best Streak", "${quizController.bestStreak}x 🔥"),
                        _buildStatBox("Coins", "+${quizController.profile.lastReward}"),
                        _buildStatBox("Student", quizController.profile.name.isEmpty ? "Young Scientist" : quizController.profile.name),
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
            style: const TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// ACHIEVEMENTS SCREEN - GRADE 7 ACHIEVEMENTS
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
                  const Text("🏆 Grade 7 Achievements", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text("Unlocked: $unlockedCount / ${allAchievements.length}", style: const TextStyle(color: AppTheme.mutedText)),
                  const SizedBox(height: 12),
                  // Progress Bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: allAchievements.isEmpty ? 0.0 : unlockedCount / allAchievements.length,
                            minHeight: 10,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.cyanAccent),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${allAchievements.isEmpty ? 0 : ((unlockedCount / allAchievements.length) * 100).round()}%",
                        style: const TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
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
                            border: Border.all(
                              color: unlocked ? AppTheme.greenAccent.withValues(alpha: 0.6) : const Color(0xFF334155),
                              width: unlocked ? 1.5 : 1.0,
                            ),
                            boxShadow: unlocked
                                ? [
                                    BoxShadow(
                                      color: AppTheme.greenAccent.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.icon, style: const TextStyle(fontSize: 38)),
                              const SizedBox(height: 6),
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppTheme.mutedText, fontSize: 11),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: unlocked ? AppTheme.greenAccent.withValues(alpha: 0.15) : Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  unlocked ? "✓ UNLOCKED" : "🔒 LOCKED",
                                  style: TextStyle(
                                    color: unlocked ? AppTheme.greenAccent : AppTheme.mutedText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
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
    final grade = quizController.selectedGrade ?? grade7Terms[1]!;

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
                  const Text("Official Grade 7 Science Quest certificate.", style: TextStyle(color: AppTheme.mutedText)),
                  const SizedBox(height: 20),

                  AspectRatio(
                    aspectRatio: 16 / 11,
                    child: CustomPaint(
                      painter: CertificatePainter(
                        profile: quizController.profile,
                        gradeMission: grade,
                        score: quizController.score > 0 ? quizController.score : 100,
                        accuracy: 100,
                        date: "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
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
                      const Text("🥇 Grade 7 Leaderboard", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      const Text("Top student scores on this device.", style: TextStyle(color: AppTheme.mutedText)),
                      const SizedBox(height: 20),

                      if (rows.isEmpty)
                        const Text("No scores recorded yet. Complete Term 1 mission!", style: TextStyle(color: Colors.white70))
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
  final _passwordController = TextEditingController();
  String errorMsg = "";

  void _login() async {
    final pwd = _passwordController.text.trim();
    if (pwd == "admin" || pwd == "teacher" || pwd == "science") {
      await StorageService.setAdminLoggedIn(true);
      widget.onNavigate('admin_dashboard');
    } else {
      setState(() {
        errorMsg = "Incorrect passcode (Try: teacher)";
      });
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
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppTheme.darkBg.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("👨‍🏫", style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 12),
                    const Text("Teacher Admin", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text("Manage term unlocks and view student results.", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.mutedText)),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Passcode",
                        hintText: "Enter teacher passcode...",
                      ),
                      onSubmitted: (_) => _login(),
                    ),
                    if (errorMsg.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(errorMsg, style: const TextStyle(color: AppTheme.redAccent, fontSize: 12)),
                    ],
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      child: const Text("LOGIN TO DASHBOARD"),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => widget.onNavigate('main'),
                      child: const Text("← Return to Game", style: TextStyle(color: AppTheme.mutedText)),
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
// TEACHER ADMIN DASHBOARD SCREEN - TERM LOCK CONFIG
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
  TermUnlockConfig unlockConfig = TermUnlockConfig.defaultConfig();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final list = await StorageService.getQuizResults();
    final config = await StorageService.getTermUnlockConfig();
    if (mounted) {
      setState(() {
        allResults = list;
        unlockConfig = config;
      });
    }
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return "$y-$m-$d $h:$min";
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
                    _buildMetricCard("Completed", "${allResults.length}"),
                    _buildMetricCard("Average Score", "$avgScore"),
                    _buildMetricCard("Average Accuracy", "$avgAccuracy%"),
                  ],
                ),
                const SizedBox(height: 20),

                // Term Lock & Timezone Settings Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.darkBg.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lock_clock, color: AppTheme.cyanAccent),
                          SizedBox(width: 8),
                          Text("⚙️ Grade 7 Term Unlock System Configuration", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Configure official term start dates, times, and school timezone. Terms unlock automatically based on system date and time.",
                        style: TextStyle(color: AppTheme.mutedText, fontSize: 13),
                      ),
                      const SizedBox(height: 16),

                      _buildTermConfigRow("Term 1 (Cell Biology)", unlockConfig.term1Start, unlockConfig.isTermUnlocked(1)),
                      const Divider(color: Colors.white10),
                      _buildTermConfigRow("Term 2 (Upcoming)", unlockConfig.term2Start, unlockConfig.isTermUnlocked(2)),
                      const Divider(color: Colors.white10),
                      _buildTermConfigRow("Term 3 (Level 3)", unlockConfig.term3Start, unlockConfig.isTermUnlocked(3)),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text("🏫 School Timezone: ", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                          Text(unlockConfig.timezoneName, style: const TextStyle(color: AppTheme.cyanAccent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              // Test unlock Term 3 by setting its start date to past
                              setState(() {
                                unlockConfig.term3Start = DateTime.now().subtract(const Duration(hours: 1));
                              });
                              await StorageService.saveTermUnlockConfig(unlockConfig);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("🔓 Term 3 has been unlocked for testing!")),
                                );
                              }
                            },
                            icon: const Icon(Icons.lock_open, size: 16),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.greenAccent),
                            label: const Text("TEST: UNLOCK TERM 3 NOW"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              // Reset Term 3 to future date
                              setState(() {
                                unlockConfig = TermUnlockConfig.defaultConfig();
                              });
                              await StorageService.saveTermUnlockConfig(unlockConfig);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("🔒 Reset to official schedule (Term 3 locked until Feb 2027).")),
                                );
                              }
                            },
                            icon: const Icon(Icons.refresh, size: 16),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF334155)),
                            label: const Text("RESET OFFICIAL SCHEDULE"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Student Results Table
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
                            DataColumn(label: Text("Mission", style: TextStyle(color: AppTheme.cyanAccent))),
                            DataColumn(label: Text("Score", style: TextStyle(color: AppTheme.cyanAccent))),
                            DataColumn(label: Text("Accuracy", style: TextStyle(color: AppTheme.cyanAccent))),
                            DataColumn(label: Text("Date", style: TextStyle(color: AppTheme.cyanAccent))),
                          ],
                          rows: filtered.reversed.map((r) {
                            return DataRow(cells: [
                              DataCell(Text(r.studentName, style: const TextStyle(color: Colors.white))),
                              DataCell(Text(r.mission, style: const TextStyle(color: Colors.white70))),
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

  Widget _buildTermConfigRow(String name, DateTime start, bool isUnlocked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(_formatDateTime(start), style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (isUnlocked ? AppTheme.greenAccent : AppTheme.redAccent).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isUnlocked ? "UNLOCKED" : "LOCKED",
                  style: TextStyle(
                    color: isUnlocked ? AppTheme.greenAccent : AppTheme.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
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
