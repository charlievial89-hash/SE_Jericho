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

    // 1. Background Gradient (Parchment & Light Scientific Blue)
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFCFDFF), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
      ).createShader(Rect.fromLTWH(0, 0, W, H));
    canvas.drawRect(Rect.fromLTWH(0, 0, W, H), bgPaint);

    // Subtle inner glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.9,
        colors: [
          Colors.white.withValues(alpha: 0.8),
          const Color(0xFFE0F2FE).withValues(alpha: 0.25),
        ],
      ).createShader(Rect.fromLTWH(0, 0, W, H));
    canvas.drawRect(Rect.fromLTWH(0, 0, W, H), glowPaint);

    // Border Proportions
    final double outerInset = (W * 0.022).clamp(8.0, 18.0);
    final double outerBorderWidth = (W * 0.012).clamp(4.0, 10.0);
    final double innerInset = outerInset + (W * 0.022).clamp(10.0, 18.0);
    final double innerBorderWidth = (W * 0.003).clamp(1.5, 3.0);

    // 2. Outer Navy Border
    final outerBorderPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerBorderWidth;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(outerInset, outerInset, W - 2 * outerInset, H - 2 * outerInset),
        const Radius.circular(6),
      ),
      outerBorderPaint,
    );

    // 3. Inner Gold Border
    final innerBorderPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerBorderWidth;
    canvas.drawRect(
      Rect.fromLTWH(innerInset, innerInset, W - 2 * innerInset, H - 2 * innerInset),
      innerBorderPaint,
    );

    // Decorative corner brackets
    final cornerPaint = Paint()
      ..color = const Color(0xFFB45309)
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerBorderWidth * 1.5;
    final double cLen = (W * 0.035).clamp(14.0, 28.0);
    // Top-Left
    canvas.drawLine(Offset(innerInset + 4, innerInset + 4), Offset(innerInset + 4 + cLen, innerInset + 4), cornerPaint);
    canvas.drawLine(Offset(innerInset + 4, innerInset + 4), Offset(innerInset + 4, innerInset + 4 + cLen), cornerPaint);
    // Top-Right
    canvas.drawLine(Offset(W - innerInset - 4, innerInset + 4), Offset(W - innerInset - 4 - cLen, innerInset + 4), cornerPaint);
    canvas.drawLine(Offset(W - innerInset - 4, innerInset + 4), Offset(W - innerInset - 4, innerInset + 4 + cLen), cornerPaint);
    // Bottom-Left
    canvas.drawLine(Offset(innerInset + 4, H - innerInset - 4), Offset(innerInset + 4 + cLen, H - innerInset - 4), cornerPaint);
    canvas.drawLine(Offset(innerInset + 4, H - innerInset - 4), Offset(innerInset + 4, H - innerInset - 4 - cLen), cornerPaint);
    // Bottom-Right
    canvas.drawLine(Offset(W - innerInset - 4, H - innerInset - 4), Offset(W - innerInset - 4 - cLen, H - innerInset - 4), cornerPaint);
    canvas.drawLine(Offset(W - innerInset - 4, H - innerInset - 4), Offset(W - innerInset - 4, H - innerInset - 4 - cLen), cornerPaint);

    // Safe bounds
    final double safeLeft = innerInset + 16;
    final double safeRight = W - innerInset - 16;
    final double safeW = safeRight - safeLeft;

    // Helper to draw centered text with safe width
    void drawCenteredText(
      String text,
      double centerY, {
      required double fontSize,
      required Color color,
      FontWeight fontWeight = FontWeight.normal,
      String fontFamily = 'sans-serif',
      double letterSpacing = 0.0,
      int maxLines = 1,
    }) {
      final textSpan = TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: maxLines,
        ellipsis: '...',
      );
      tp.layout(maxWidth: safeW);
      tp.paint(canvas, Offset((W - tp.width) / 2, centerY - (tp.height / 2)));
    }

    // 4. Header Badge: SCIENCE QUEST ACADEMY
    drawCenteredText(
      "✦ SCIENCE QUEST ACADEMY ✦",
      H * 0.12,
      fontSize: (W * 0.024).clamp(10.0, 16.0),
      color: const Color(0xFF1E3A8A),
      fontWeight: FontWeight.w800,
      letterSpacing: 2.0,
    );

    // 5. Main Title: CERTIFICATE OF ACHIEVEMENT
    drawCenteredText(
      "CERTIFICATE OF ACHIEVEMENT",
      H * 0.19,
      fontSize: (W * 0.045).clamp(16.0, 32.0),
      color: const Color(0xFF0F172A),
      fontWeight: FontWeight.w900,
      letterSpacing: 1.5,
    );

    // Decorative divider below title
    final dividerPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..strokeWidth = 1.5;
    final double divW = W * 0.35;
    canvas.drawLine(Offset((W - divW) / 2, H * 0.245), Offset((W + divW) / 2, H * 0.245), dividerPaint);
    drawCenteredText("🏆", H * 0.245, fontSize: (W * 0.026).clamp(12.0, 20.0), color: Colors.amber);

    // 6. Presentation Line
    drawCenteredText(
      "THIS CERTIFICATE IS PROUDLY PRESENTED TO",
      H * 0.31,
      fontSize: (W * 0.019).clamp(9.0, 13.0),
      color: const Color(0xFF475569),
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    );

    // 7. Student Name (Large & Prominent)
    final studentName = profile.name.trim().isEmpty ? "YOUNG SCIENTIST" : profile.name.trim().toUpperCase();
    final double nameFontSize = (W * 0.046).clamp(18.0, 34.0);
    drawCenteredText(
      studentName,
      H * 0.40,
      fontSize: nameFontSize,
      color: const Color(0xFF1E3A8A),
      fontWeight: FontWeight.w900,
      letterSpacing: 1.2,
    );

    // Elegant underline with central diamond
    final nameLinePaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.5;
    final double lineHalfW = (W * 0.28).clamp(100.0, 220.0);
    canvas.drawLine(Offset(W / 2 - lineHalfW, H * 0.455), Offset(W / 2 + lineHalfW, H * 0.455), nameLinePaint);
    drawCenteredText("✦", H * 0.455, fontSize: (W * 0.020).clamp(10.0, 14.0), color: const Color(0xFFD97706));

    // 8. Mission & Topic
    drawCenteredText(
      "For outstanding mastery in Grade 7 Term ${gradeMission.termNumber}: ${gradeMission.title}",
      H * 0.52,
      fontSize: (W * 0.022).clamp(10.0, 15.0),
      color: const Color(0xFF0F172A),
      fontWeight: FontWeight.bold,
    );
    drawCenteredText(
      "Successfully defeating the Cell Guardian and conquering cell biology challenges.",
      H * 0.575,
      fontSize: (W * 0.018).clamp(8.5, 12.5),
      color: const Color(0xFF475569),
    );

    // 9. Stats Row (Balanced Horizontal 3-Badge Layout)
    final double badgeY = H * 0.67;
    final double badgeW = (W * 0.23).clamp(80.0, 170.0);
    final double badgeH = (H * 0.08).clamp(28.0, 44.0);
    final double badgeSpacing = (W * 0.02).clamp(8.0, 16.0);
    final double totalBadgesW = 3 * badgeW + 2 * badgeSpacing;
    final double startBadgeX = (W - totalBadgesW) / 2;

    void drawBadge(double x, String label, String val, Color valColor) {
      final badgeRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, badgeY - badgeH / 2, badgeW, badgeH),
        const Radius.circular(8),
      );
      final badgeBgPaint = Paint()..color = const Color(0xFFF1F5F9);
      final badgeBorderPaint = Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRRect(badgeRect, badgeBgPaint);
      canvas.drawRRect(badgeRect, badgeBorderPaint);

      // Label & Value
      final labelSpan = TextSpan(
        text: label.toUpperCase(),
        style: TextStyle(
          color: const Color(0xFF64748B),
          fontSize: (badgeH * 0.24).clamp(7.0, 10.0),
          fontWeight: FontWeight.w700,
        ),
      );
      final labelTp = TextPainter(text: labelSpan, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      labelTp.layout(maxWidth: badgeW - 8);
      labelTp.paint(canvas, Offset(x + (badgeW - labelTp.width) / 2, badgeY - badgeH / 2 + 4));

      final valSpan = TextSpan(
        text: val,
        style: TextStyle(
          color: valColor,
          fontSize: (badgeH * 0.38).clamp(11.0, 16.0),
          fontWeight: FontWeight.w900,
        ),
      );
      final valTp = TextPainter(text: valSpan, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      valTp.layout(maxWidth: badgeW - 8);
      valTp.paint(canvas, Offset(x + (badgeW - valTp.width) / 2, badgeY - badgeH / 2 + badgeH - valTp.height - 4));
    }

    drawBadge(startBadgeX, "Final Score", "$score PTS", const Color(0xFF1E3A8A));
    drawBadge(startBadgeX + badgeW + badgeSpacing, "Accuracy", "$accuracy%", const Color(0xFF0D9488));
    drawBadge(startBadgeX + 2 * (badgeW + badgeSpacing), "Best Streak", "${profile.level}x ⭐", const Color(0xFFD97706));

    // 10. Bottom Row: Date & ID (Left), Golden Seal (Center), Guardian Signature (Right)
    final double bottomRowY = H * 0.81;

    // LEFT COLUMN: Date & Certificate ID
    final leftX = safeLeft + 12;
    final dateSpan = TextSpan(
      children: [
        TextSpan(
          text: "Date Issued: $date\n",
          style: TextStyle(
            color: const Color(0xFF334155),
            fontSize: (W * 0.018).clamp(8.5, 12.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: "ID: SQ-G7T${gradeMission.termNumber}-${profile.name.hashCode.abs().toString().padLeft(6, '0')}",
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: (W * 0.015).clamp(7.5, 10.5),
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
    final dateTp = TextPainter(text: dateSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    dateTp.layout(maxWidth: W * 0.3);
    dateTp.paint(canvas, Offset(leftX, bottomRowY - dateTp.height / 2));

    // CENTER: Official Gold Seal
    final sealRadius = (W * 0.038).clamp(18.0, 30.0);
    final sealPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFDE68A), Color(0xFFF59E0B), Color(0xFFB45309)],
      ).createShader(Rect.fromCircle(center: Offset(W / 2, bottomRowY), radius: sealRadius));
    canvas.drawCircle(Offset(W / 2, bottomRowY), sealRadius, sealPaint);

    final sealBorderPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(W / 2, bottomRowY), sealRadius, sealBorderPaint);
    drawCenteredText("🏅", bottomRowY, fontSize: (sealRadius * 1.05).clamp(16.0, 28.0), color: Colors.amber);

    // RIGHT COLUMN: Guardian Signature
    final rightEndX = safeRight - 12;
    final double sigLineW = (W * 0.22).clamp(90.0, 160.0);
    final sigPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(rightEndX - sigLineW, bottomRowY), Offset(rightEndX, bottomRowY), sigPaint);

    final guardianSpan = TextSpan(
      children: [
        TextSpan(
          text: "${gradeMission.guardian}\n",
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: (W * 0.019).clamp(9.0, 13.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: "Cell Guardian & Science Master",
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: (W * 0.014).clamp(7.5, 10.0),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
    final guardianTp = TextPainter(text: guardianSpan, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    guardianTp.layout(maxWidth: sigLineW);
    guardianTp.paint(canvas, Offset(rightEndX - sigLineW + (sigLineW - guardianTp.width) / 2, bottomRowY + 4));

    // 11. Bottom Motto (Safely inside inner gold border)
    drawCenteredText(
      "✦ Keep exploring • Keep learning • Keep discovering ✦",
      H * 0.925,
      fontSize: (W * 0.018).clamp(8.5, 12.5),
      color: const Color(0xFF1E3A8A),
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant CertificatePainter oldDelegate) {
    return oldDelegate.profile != profile ||
        oldDelegate.gradeMission != gradeMission ||
        oldDelegate.score != score ||
        oldDelegate.accuracy != accuracy ||
        oldDelegate.date != date;
  }
}
