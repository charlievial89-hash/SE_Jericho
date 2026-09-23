import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_3/main.dart';
import 'package:flutter_application_3/models/models.dart';

void main() {
  testWidgets('Science Quest app smoke test', (WidgetTester tester) async {
    final profile = StudentProfile(name: "Test Scientist");
    await tester.pumpWidget(ScienceQuestApp(initialProfile: profile));

    expect(find.text('SCIENCE QUEST'), findsWidgets);
  });
}
