# GT TextField

[![pub package](https://img.shields.io/pub/v/gt_textfield.svg)](https://pub.dev/packages/gt_textfield)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter text field package with MasterTextField (advanced TextField/TextFormField wrapper) and SuggestionTextField with autocomplete and search history.

## Features

- 📝 **MasterTextField** - All TextField/TextFormField properties in one widget
- 🔍 **SuggestionTextField** - Autocomplete with search history
- 💾 **Persistent History** - Save search history via SharedPreferences
- 🚫 **EmojiBlockFormatter** - Block emoji input in text fields
- ⚙️ **Highly Configurable** - Every property exposed for customization
- ✅ **Validation Support** - Auto-switches to TextFormField when validator provided

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  gt_textfield: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Quick Start

### MasterTextField

```dart
import 'package:gt_textfield/gt_textfield.dart';

MasterTextField(
  labelText: 'Email',
  hintText: 'Enter your email',
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    return null;
  },
)
```

### MasterTextField with Custom Styling

```dart
MasterTextField(
  controller: _controller,
  labelText: 'Username',
  hintText: 'Enter username',
  filled: true,
  fillColor: Colors.grey[100],
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  prefixIcon: Icons.person,
  suffixIconWidget: IconButton(
    icon: Icon(Icons.clear),
    onPressed: () => _controller.clear(),
  ),
)
```

### SuggestionTextField with History

```dart
SuggestionTextField(
  fieldName: 'search_field', // Unique ID for history storage
  config: SuggestionFieldConfig(
    storageType: HistoryStorageType.persistent,
    maxHistoryItems: 10,
    showHistoryIcon: true,
  ),
  labelText: 'Search',
  hintText: 'Search products...',
  onSubmit: (text) => performSearch(text),
  onSuggestionSelected: (suggestion) => performSearch(suggestion),
)
```

### SuggestionTextField with Custom Suggestions

```dart
SuggestionTextField(
  fieldName: 'city_field',
  staticSuggestions: ['New York', 'Los Angeles', 'Chicago', 'Houston'],
  config: SuggestionFieldConfig(
    showDeleteButton: true,
    suggestionStyle: TextStyle(fontSize: 16),
  ),
)
```

### Block Emoji Input

```dart
MasterTextField(
  labelText: 'Name',
  inputFormatters: [EmojiBlockFormatter()],
)
```

## MasterTextField Properties

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `TextEditingController?` | Text controller |
| `focusNode` | `FocusNode?` | Focus node |
| `labelText` | `String?` | Label text |
| `hintText` | `String?` | Hint text |
| `prefixIcon` | `IconData?` | Prefix icon |
| `suffixIcon` | `IconData?` | Suffix icon |
| `validator` | `FormFieldValidator?` | Validation function |
| `keyboardType` | `TextInputType?` | Keyboard type |
| `obscureText` | `bool` | Password field |
| `maxLines` | `int?` | Maximum lines |
| `inputFormatters` | `List<TextInputFormatter>?` | Input formatters |

## SuggestionFieldConfig Options

```dart
SuggestionFieldConfig(
  storageType: HistoryStorageType.persistent,
  maxHistoryItems: 10,
  minCharsForSuggestion: 1,
  showHistoryIcon: true,
  showDeleteButton: true,
  maxSuggestionsVisible: 5,
  suggestionStyle: TextStyle(fontSize: 14),
  historyIconColor: Colors.grey,
)
```

## License

MIT License - see [LICENSE](LICENSE) for details.
