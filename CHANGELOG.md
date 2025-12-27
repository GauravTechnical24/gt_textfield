# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-12-27

### Added
- `MasterTextField` - Advanced TextField/TextFormField wrapper
  - All decoration properties (label, hint, prefix, suffix, borders)
  - All behavior properties (obscureText, maxLines, inputFormatters)
  - All styling properties (textStyle, cursorStyle, alignment)
  - Auto-switches to TextFormField when validator is provided
  - Support for latest Flutter API properties
- `SuggestionTextField` - Autocomplete with search history
  - Persistent storage via SharedPreferences
  - Temporary (memory-only) storage option
  - Static suggestions support
  - Custom suggestion item builder
  - Configurable history limits
  - Delete individual history items
  - Case-insensitive filtering
- `SuggestionFieldConfig` - Configuration for suggestion field
  - Storage type (persistent/temporary)
  - Maximum history items
  - Suggestion display options
  - Style customization
- `EmojiBlockFormatter` - TextInputFormatter to block emoji input
- `HistoryStorageType` enum - Storage options for search history
