/// GT TextField - A comprehensive Flutter text field package.
///
/// This package provides:
/// - `MasterTextField` - Advanced TextField/TextFormField wrapper with all properties
/// - `SuggestionTextField` - Autocomplete text field with search history
/// - `EmojiBlockFormatter` - Input formatter to block emoji input
/// - Persistent and temporary history storage options
library;

// Main Text Field Widgets
export 'master_text_field.dart' show MasterTextField;
export 'suggession_text_field.dart'
    show SuggestionTextField, SuggestionFieldConfig, HistoryStorageType;

// Input Formatters
export 'emoji_block_formatter.dart' show EmojiBlockFormatter;
