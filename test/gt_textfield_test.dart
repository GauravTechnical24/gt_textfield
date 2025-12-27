import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gt_textfield/gt_textfield.dart';

void main() {
  group('MasterTextField', () {
    testWidgets('renders correctly with label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MasterTextField(
              labelText: 'Test Label',
              hintText: 'Test Hint',
            ),
          ),
        ),
      );

      expect(find.byType(MasterTextField), findsOneWidget);
      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('uses TextFormField when validator provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MasterTextField(
              labelText: 'Email',
              validator: (value) => null,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('uses TextField when no validator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MasterTextField(labelText: 'Name')),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('EmojiBlockFormatter', () {
    test('blocks emoji characters', () {
      final formatter = EmojiBlockFormatter();
      const oldValue = TextEditingValue(text: 'Hello');
      const newValue = TextEditingValue(text: 'Hello😀');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'Hello');
    });

    test('allows regular text', () {
      final formatter = EmojiBlockFormatter();
      const oldValue = TextEditingValue(text: 'Hello');
      const newValue = TextEditingValue(text: 'Hello World');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'Hello World');
    });
  });

  group('SuggestionFieldConfig', () {
    test('default values are set correctly', () {
      const config = SuggestionFieldConfig();

      expect(config.storageType, HistoryStorageType.persistent);
      expect(config.maxHistoryItems, 50);
      expect(config.showRemoveButton, isTrue);
    });

    test('custom values are applied', () {
      const config = SuggestionFieldConfig(
        storageType: HistoryStorageType.temporary,
        maxHistoryItems: 5,
        showRemoveButton: false,
      );

      expect(config.storageType, HistoryStorageType.temporary);
      expect(config.maxHistoryItems, 5);
      expect(config.showRemoveButton, isFalse);
    });
  });

  group('HistoryStorageType', () {
    test('enum values exist', () {
      expect(HistoryStorageType.values.length, 2);
      expect(
        HistoryStorageType.values.contains(HistoryStorageType.persistent),
        isTrue,
      );
      expect(
        HistoryStorageType.values.contains(HistoryStorageType.temporary),
        isTrue,
      );
    });
  });
}
