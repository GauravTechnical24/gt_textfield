import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'master_text_field.dart';

/// Storage type for search history
enum HistoryStorageType {
  /// Store in SharedPreferences (persistent)
  persistent,

  /// Store in memory only (temporary, cleared on app restart)
  temporary,
}

/// Configuration class for SuggestionTextField
class SuggestionFieldConfig {
  /// Maximum number of search history items to store
  final int maxHistoryItems;

  /// Whether to show the remove button for each suggestion
  final bool showRemoveButton;

  /// Whether suggestions are enabled
  final bool enableSuggestions;

  /// Animation duration for suggestion box
  final Duration animationDuration;

  /// Maximum height for suggestions list
  final double maxSuggestionsHeight;

  /// Margin between text field and suggestions box
  final double suggestionBoxMargin;

  /// Whether to filter suggestions as user types
  final bool filterOnTyping;

  /// Minimum characters to show suggestions
  final int minCharsForSuggestions;

  /// Storage type for history
  final HistoryStorageType storageType;

  /// Horizontal margin for suggestions box from screen edges
  final double horizontalMargin;

  const SuggestionFieldConfig({
    this.maxHistoryItems = 50,
    this.showRemoveButton = true,
    this.enableSuggestions = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.maxSuggestionsHeight = 200,
    this.suggestionBoxMargin = 8.0,
    this.filterOnTyping = true,
    this.minCharsForSuggestions = 1,
    this.storageType = HistoryStorageType.persistent,
    this.horizontalMargin = 16.0,
  });
}

/// Callback types
typedef OnSuggestionSelected = void Function(String suggestion);
typedef OnSubmit = void Function(String text);

/// Global storage manager for search histories (Singleton pattern)
class _SuggestionHistoryManager {
  static final _SuggestionHistoryManager _instance =
      _SuggestionHistoryManager._internal();
  factory _SuggestionHistoryManager() => _instance;
  _SuggestionHistoryManager._internal();

  // In-memory storage for temporary histories
  final Map<String, List<String>> _temporaryHistories = {};
  
  // Cache for persistent storage to reduce SharedPreferences calls
  final Map<String, List<String>> _persistentCache = {};

  /// Get history for a field
  Future<List<String>> getHistory(
    String fieldName,
    HistoryStorageType storageType,
  ) async {
    if (storageType == HistoryStorageType.temporary) {
      return _temporaryHistories[fieldName] ?? [];
    }
    
    // Check cache first
    if (_persistentCache.containsKey(fieldName)) {
      return _persistentCache[fieldName]!;
    }
    
    // Load from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('suggestion_history_$fieldName');
    
    if (jsonString == null) {
      _persistentCache[fieldName] = [];
      return [];
    }

    try {
      final List<dynamic> decoded = json.decode(jsonString);
      final history = decoded.map((e) => e.toString()).toList();
      _persistentCache[fieldName] = history;
      return history;
    } catch (e) {
      _persistentCache[fieldName] = [];
      return [];
    }
  }

  /// Save history for a field
  Future<void> saveHistory(
    String fieldName,
    List<String> history,
    HistoryStorageType storageType,
  ) async {
    if (storageType == HistoryStorageType.temporary) {
      _temporaryHistories[fieldName] = history;
      return;
    }
    
    // Update cache
    _persistentCache[fieldName] = history;
    
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'suggestion_history_$fieldName',
      json.encode(history),
    );
  }

  /// Clear history for a field
  Future<void> clearHistory(
    String fieldName,
    HistoryStorageType storageType,
  ) async {
    if (storageType == HistoryStorageType.temporary) {
      _temporaryHistories.remove(fieldName);
      return;
    }
    
    _persistentCache.remove(fieldName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('suggestion_history_$fieldName');
  }

  /// Clear all histories
  Future<void> clearAllHistories(HistoryStorageType storageType) async {
    if (storageType == HistoryStorageType.temporary) {
      _temporaryHistories.clear();
      return;
    }
    
    _persistentCache.clear();
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where(
      (key) => key.startsWith('suggestion_history_'),
    );
    
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}

/// SuggestionTextField - A text field with search history and auto-suggestions
class SuggestionTextField extends StatefulWidget {
  // ==================== SUGGESTION SPECIFIC ====================
  /// Unique field name for storing history (REQUIRED)
  final String fieldName;

  /// Configuration for suggestion behavior
  final SuggestionFieldConfig config;

  /// Callback when a suggestion is selected
  final OnSuggestionSelected? onSuggestionSelected;

  /// Callback when text is submitted
  final OnSubmit? onSubmit;

  /// Custom suggestion item builder
  final Widget Function(
    BuildContext context,
    String suggestion,
    VoidCallback onTap,
    VoidCallback? onRemove,
  )? suggestionBuilder;

  /// Style for suggestion box
  final BoxDecoration? suggestionBoxDecoration;

  /// Style for suggestion items
  final TextStyle? suggestionTextStyle;

  // ==================== MASTER TEXT FIELD PROPERTIES ====================
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  // Pass-through properties
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;

  const SuggestionTextField({
    super.key,
    required this.fieldName,
    this.config = const SuggestionFieldConfig(),
    this.onSuggestionSelected,
    this.onSubmit,
    this.suggestionBuilder,
    this.suggestionBoxDecoration,
    this.suggestionTextStyle,
    this.controller,
    this.focusNode,
    this.decoration,
    this.labelText,
    this.hintText,
    this.style,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.validator,
    this.autovalidateMode,
    this.labelStyle,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.filled = false,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
  });

  @override
  State<SuggestionTextField> createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final _historyManager = _SuggestionHistoryManager();
  List<String> _searchHistory = [];
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  OverlayEntry? _overlayEntry;
  bool _isLoading = true;
  final GlobalKey _fieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );

    // Optimized animations using Curves.easeOutCubic
    _slideAnimation = Tween<double>(
      begin: -0.3,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    _loadHistory();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _historyManager.getHistory(
        widget.fieldName,
        widget.config.storageType,
      );
      
      if (mounted) {
        setState(() {
          _searchHistory = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchHistory = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveHistory() async {
    try {
      await _historyManager.saveHistory(
        widget.fieldName,
        _searchHistory,
        widget.config.storageType,
      );
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  void _onTextChanged() {
    if (!widget.config.enableSuggestions || !widget.enabled || !mounted) {
      return;
    }

    final text = _controller.text.trim();

    if (text.length >= widget.config.minCharsForSuggestions &&
        widget.config.filterOnTyping) {
      _filterSuggestions(text);
    } else {
      _hideSuggestions();
    }

    widget.onChanged?.call(_controller.text);
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && mounted) {
      _hideSuggestions();
    }
  }

  void _filterSuggestions(String query) {
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _filteredSuggestions = [];
          _showSuggestions = false;
        });
      }
      _hideSuggestions();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filtered = _searchHistory
        .where((item) =>
            item.toLowerCase().contains(lowercaseQuery) &&
            item.toLowerCase() != lowercaseQuery)
        .toList();

    if (mounted) {
      setState(() {
        _filteredSuggestions = filtered;
        _showSuggestions = filtered.isNotEmpty;
      });
    }

    if (_showSuggestions) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  Future<void> _addToHistory(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    if (mounted) {
      setState(() {
        _searchHistory.remove(trimmedText);
        _searchHistory.insert(0, trimmedText);

        if (_searchHistory.length > widget.config.maxHistoryItems) {
          _searchHistory = _searchHistory.sublist(
            0,
            widget.config.maxHistoryItems,
          );
        }
      });
    }

    await _saveHistory();
  }

  Future<void> _removeFromHistory(String text) async {
    if (mounted) {
      setState(() {
        _searchHistory.remove(text);
        _filteredSuggestions.remove(text);
      });
    }

    await _saveHistory();

    if (_filteredSuggestions.isEmpty) {
      _hideSuggestions();
    } else {
      _updateOverlay();
    }
  }

  void _onSuggestionTap(String suggestion) {
    _controller.text = suggestion;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    _hideSuggestions();
    widget.onSuggestionSelected?.call(suggestion);
  }

  void _onFieldSubmitted(String text) {
    _addToHistory(text);
    _hideSuggestions();
    widget.onSubmit?.call(text);
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _hideSuggestions() {
    _focusNode.unfocus();
    if (mounted) {
      setState(() {
        _showSuggestions = false;
      });
    }
    _hideOverlay();
  }

  void _hideOverlay() {
    if (_overlayEntry == null) return;
    _animationController.reverse().then((_) => _removeOverlay());
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        // Get field position and size using GlobalKey
        final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
        
        if (renderBox == null || !renderBox.hasSize) {
          return const SizedBox.shrink();
        }

        final fieldSize = renderBox.size;
        final fieldOffset = renderBox.localToGlobal(Offset.zero);
        final mediaQuery = MediaQuery.of(context);

        // Calculate available width with horizontal margins
        final availableWidth =
            mediaQuery.size.width - (widget.config.horizontalMargin * 2);

        // Calculate content-based height
        const itemHeight = 48.0;
        final contentHeight = (_filteredSuggestions.length * itemHeight)
            .clamp(0.0, widget.config.maxSuggestionsHeight);

        // Check if scrolling is needed
        final needsScrolling =
            (_filteredSuggestions.length * itemHeight) >
            widget.config.maxSuggestionsHeight;

        return Stack(
          children: [
            // Tap detector to close overlay when tapping outside
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hideSuggestions,
                child: Container(color: Colors.transparent),
              ),
            ),
            // Suggestion box
            Positioned(
              left: widget.config.horizontalMargin,
              top: fieldOffset.dy +
                  fieldSize.height +
                  widget.config.suggestionBoxMargin,
              width: availableWidth,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                shadowColor: Colors.black.withValues(alpha:  0.2),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value * contentHeight),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    height: contentHeight,
                    decoration: widget.suggestionBoxDecoration ??
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                    child: _filteredSuggestions.isEmpty
                        ? const SizedBox.shrink()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: _buildSuggestionsList(needsScrolling),
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuggestionsList(bool needsScrolling) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: !needsScrolling,
      physics: needsScrolling
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: _filteredSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _filteredSuggestions[index];

        if (widget.suggestionBuilder != null) {
          return widget.suggestionBuilder!(
            context,
            suggestion,
            () => _onSuggestionTap(suggestion),
            widget.config.showRemoveButton
                ? () => _removeFromHistory(suggestion)
                : null,
          );
        }

        return _buildDefaultSuggestionItem(suggestion);
      },
    );
  }

  Widget _buildDefaultSuggestionItem(String suggestion) {
    return InkWell(
      onTap: () => _onSuggestionTap(suggestion),
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(Icons.history, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  suggestion,
                  style: widget.suggestionTextStyle ??
                      const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.config.showRemoveButton) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _removeFromHistory(suggestion),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use PopScope instead of deprecated WillPopScope
    return PopScope(
      canPop: _overlayEntry == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _overlayEntry != null) {
          _hideSuggestions();
        }
      },
      child: _isLoading
          ? MasterTextField(
              enabled: false,
              labelText: widget.labelText,
              hintText: widget.hintText,
              decoration: widget.decoration,
            )
          : MasterTextField(
              key: _fieldKey, // CRITICAL: Key for getting position
              controller: _controller,
              focusNode: _focusNode,
              decoration: widget.decoration,
              labelText: widget.labelText,
              hintText: widget.hintText,
              style: widget.style,
              textAlign: widget.textAlign,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction ?? TextInputAction.search,
              readOnly: widget.readOnly,
              enabled: widget.enabled,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              onSubmitted: _onFieldSubmitted,
              onTap: widget.onTap,
              onEditingComplete: widget.onEditingComplete,
              validator: widget.validator,
              autovalidateMode: widget.autovalidateMode,
              labelStyle: widget.labelStyle,
              hintStyle: widget.hintStyle,
              prefixIconWidget: widget.prefixIcon,
              suffixIconWidget: widget.suffixIcon,
              fillColor: widget.fillColor,
              filled: widget.filled,
              contentPadding: widget.contentPadding,
              border: widget.border,
              enabledBorder: widget.enabledBorder,
              focusedBorder: widget.focusedBorder,
              onTapOutside: (event) {
               
              },
            ),
    );
  }
}

/// Helper methods to manage suggestion history globally
class SuggestionHistoryHelper {
  static final _manager = _SuggestionHistoryManager();

  /// Clear history for a specific field
  static Future<void> clearFieldHistory(
    String fieldName, {
    HistoryStorageType storageType = HistoryStorageType.persistent,
  }) async {
    await _manager.clearHistory(fieldName, storageType);
  }

  /// Clear all histories
  static Future<void> clearAllHistories({
    HistoryStorageType storageType = HistoryStorageType.persistent,
  }) async {
    await _manager.clearAllHistories(storageType);
  }

  /// Get history for a specific field
  static Future<List<String>> getFieldHistory(
    String fieldName, {
    HistoryStorageType storageType = HistoryStorageType.persistent,
  }) async {
    return await _manager.getHistory(fieldName, storageType);
  }
}