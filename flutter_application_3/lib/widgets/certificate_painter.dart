import 'package:flutter/material.dart';
import '../models/models.dart';

class CertificatePainter extends CustomPainter {
  final StudentProfile profile;
  final GradeMission gradeMission;
  final int score;
  final int accuracy;
  final String date;

  CertificatePainter({
    required this.profile,
    required this.gradeMission,
    required this.score,
    required this.accuracy,
    required this.date,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double W = size.width;
    final double H = size.height;

    // 1. Background Gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8FAFC), Color(0xFFE0F2FE)],
        ).createShader(Rect.fromLTWH(0, 0, W, H));
    canvas.drawRect(Rect.fromLTWH(0, 0, W, H), bgPaint);

    // 2. Outer Navy Border
    final outerBorderPaint = Paint()
      ..color = const Color(0xFF1D4ED8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawRect(Rect.fromLTWH(18, 18, W - 36, H - 36), outerBorderPaint);

    // 3. Inner Gold Border
    final innerBorderPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRect(Rect.fromLTWH(36, 36, W - 72, H - 72), innerBorderPaint);

    // Text Painter Helper
    void drawText(
      String text,
      double y, {
      required double fontSize,
      required Color color,
      FontWeight fontWeight = FontWeight.normal,
      String fontFamily = 'sans-serif',
    }) {
      final textSpan = TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout(minWidth: W, maxWidth: W);
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // 4. Header & Titles
    drawText("SCIENCE QUEST", H * 0.16, fontSize: W * 0.055, color: const Color(0xFF1E3A8A), fontWeight: FontWeight.bold);
    drawText("CERTIFICATE OF ACHIEVEMENT", H * 0.23, fontSize: W * 0.024, color: const Color(0xFF475569), fontWeight: FontWeight.w600);

    // 5. Trophy Emoji Icon
    drawText("🏆", H * 0.32, fontSize: W * 0.07, color: Colors.amber);

    // 6. Presentation String
    drawText("This certificate is proudly presented to", H * 0.40, fontSize: W * 0.022, color: const Color(0xFF475569));

    // 7. Student Name
    drawText(profile.name.toUpperCase(), H * 0.48, fontSize: W * 0.045, color: const Color(0xFF0F172A), fontWeight: FontWeight.bold);

    // Underline
    final linePaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(W * 0.22, H * 0.52), Offset(W * 0.78, H * 0.52), linePaint);

    // 8. Mission details
    drawText("Grade 7 ${gradeMission.title} — ${gradeMission.topic}", H * 0.58, fontSize: W * 0.028, color: const Color(0xFF1E3A8A), fontWeight: FontWeight.bold);
    drawText("Score: $score", H * 0.65, fontSize: W * 0.022, color: const Color(0xFF334155));
    drawText("Accuracy: $accuracy%", H * 0.70, fontSize: W * 0.022, color: const Color(0xFF334155));
    drawText("Reward: +${gradeMission.reward} Coins", H * 0.75, fontSize: W * 0.022, color: const Color(0xFF334155));
    drawText("Date: $date", H * 0.80, fontSize: W * 0.020, color: const Color(0xFF334155));

    // 9. Guardian Signature
    drawText("Guardian: ${gradeMission.guardian}", H * 0.86, fontSize: W * 0.020, color: const Color(0xFF475569), fontWeight: FontWeight.bold);

    // 10. Footer Motto
    drawText("Keep exploring. Keep learning. Keep discovering!", H * 0.92, fontSize: W * 0.022, color: const Color(0xFF1D4ED8), fontWeight: FontWeight.bold);

    // 11. Certificate ID
    drawText("Certificate ID: SQ-G7T${gradeMission.termNumber}-${profile.name.hashCode.abs()}", H * 0.96, fontSize: W * 0.015, color: const Color(0xFF64748B));
  }

  @override
  bool shouldRepaint(covariant CertificatePainter oldDelegate) {
    return oldDelegate.profile != profile ||
        oldDelegate.gradeMission != gradeMission ||
        oldDelegate.score != score ||
        oldDelegate.accuracy != accuracy;
  }
}
