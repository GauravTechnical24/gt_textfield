import 'package:flutter_test/flutter_test.dart';
import 'package:gt_textfield_example/main.dart';

void main() {
  testWidgets('TextFieldExampleScreen displays correctly', (
    WidgetTester tester,
  ) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('GT TextField Example'), findsOneWidget);

    // Verify section titles are present
    expect(find.text('MasterTextField'), findsOneWidget);
    expect(find.text('SuggestionTextField'), findsOneWidget);

    // Verify submit button is present
    expect(find.text('Submit'), findsOneWidget);
  });
}
