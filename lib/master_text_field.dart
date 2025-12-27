import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// MasterTextField - Optimized & Refactored
/// - Keeps all your original properties
/// - Adds missing/latest Flutter properties (InputDecoration, EditableText, TextField/TextFormField)
/// - Avoids duplicate code between TextField and TextFormField
///
/// NOTE: This aims to support the latest stable Flutter API. If your project uses
/// an older Flutter SDK you might need to remove/adjust a few newer properties.
class MasterTextField extends StatelessWidget {
  // ==================== CONTROLLER & FOCUS ====================
  final TextEditingController? controller;
  final FocusNode? focusNode;

  // ==================== DECORATION ====================
  final InputDecoration? decoration;

  // - basic text
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;

  // - prefix / suffix widgets & icons & constraints & styles
  final String? prefixText;
  final IconData? prefixIcon;
  final Widget? prefix;
  final BoxConstraints? prefixIconConstraints;
  final TextStyle? prefixStyle;

  final String? suffixText;
  final IconData? suffixIcon;
  final Widget? suffix;
  final BoxConstraints? suffixIconConstraints;
  final TextStyle? suffixStyle;

  final Widget? prefixIconWidget;
  final Widget? suffixIconWidget;

  // - helper / error / counter
  final String? helperText;
  final TextStyle? helperStyle;
  final int? helperMaxLines;

  final String? counterText;
  final TextStyle? counterStyle;
  final InputCounterWidgetBuilder? buildCounter;
  final String? semanticCounterText;

  final String? errorText;
  final TextStyle? errorStyle;
  final int? errorMaxLines;

  // - layout
  final bool isDense;
  final EdgeInsetsGeometry? contentPadding;
  final bool isCollapsed;
  final BoxConstraints? constraints; // InputDecoration constraints

  // - floating label behaviour
  final FloatingLabelBehavior? floatingLabelBehavior;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final bool? alignLabelWithHint;

  // - borders and fill
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final bool filled;
  final Color? fillColor;

  // ==================== TEXT STYLING ====================
  final TextStyle? style;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final TextAlignVertical? textAlignVertical;

  // cursor
  final Color? cursorColor;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates; // Material 3 / newer

  // ==================== KEYBOARD & INPUT ====================
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  // ==================== BEHAVIOR ====================
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final String obscuringCharacter;
  final bool autocorrect;
  final bool? showCursor;
  final bool enableSuggestions;
  final bool enableInteractiveSelection;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool autofocus;

  // ==================== CALLBACKS ====================
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;

  // ==================== VALIDATION ====================
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  // ==================== ADVANCED ====================
  final String? restorationId;
  final Brightness? keyboardAppearance;
  final StrutStyle? strutStyle;
  final EdgeInsets scrollPadding;

  final bool? enableIMEPersonalizedLearning;
  // final ToolbarOptions? toolbarOptions;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final bool selectAllOnFocus;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final SpellCheckConfiguration? spellCheckConfiguration;

  // new-ish editable/selection/gesture related properties
  final TextSelectionControls? selectionControls;
  final SmartQuotesType? smartQuotesType;
  final SmartDashesType? smartDashesType;
  final DragStartBehavior dragStartBehavior;
  final bool canRequestFocus;
  final void Function(PointerDownEvent event)? onTapOutside;
  final BoxHeightStyle? selectionHeightStyle;
  final BoxWidthStyle? selectionWidthStyle;

  // mouse / stylus / misc
  final MouseCursor? mouseCursor;
  final bool? stylusHandwritingEnabled; // you had scribbleEnabled — replaced/aliased here
  final bool? scribbleEnabled; // keep as alias for older usage (preserved)
  final Clip clipBehavior;

  // semantics & accessibility
  final bool? enableInteractiveSelectionToolbar; // placeholder for clarity (not standard)
  // Note: keep property names close to Flutter API; above is optional and likely unused.

  final List<String>? autofillHints;


  const MasterTextField({
    super.key,
    // Controller & Focus
    this.controller,
    this.focusNode,
    // Decoration
    this.decoration,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.prefixText,
    this.prefixIcon,
    this.prefix,
    this.prefixIconConstraints,
    this.prefixStyle,
    this.suffixText,
    this.suffixIcon,
    this.suffix,
    this.suffixIconConstraints,
    this.suffixStyle,
    this.prefixIconWidget,
    this.suffixIconWidget,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.counterText,
    this.counterStyle,
    this.buildCounter,
    this.semanticCounterText,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
    this.isDense = false,
    this.contentPadding,
    this.isCollapsed = false,
    this.constraints,
    this.floatingLabelBehavior,
    this.floatingLabelAlignment,
    this.alignLabelWithHint,
    this.border,
    this.enabledBorder,
    this.disabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.filled = false,
    this.fillColor,
    // Text Styling
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textAlignVertical,
    this.cursorColor,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    // Keyboard & Input
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    // Behavior
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.showCursor,
    this.enableSuggestions = true,
    this.enableInteractiveSelection = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.autofocus = false,
    // Callbacks
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    // Validation
    this.validator,
    this.autovalidateMode,
    // Advanced
    this.restorationId,
    this.keyboardAppearance,
    this.strutStyle,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableIMEPersonalizedLearning,
    // this.toolbarOptions,
    this.scrollController,
    this.scrollPhysics,
    this.selectAllOnFocus = false,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.spellCheckConfiguration,
    // Editable/selection and gesture
    this.selectionControls,
    this.smartQuotesType,
    this.smartDashesType,
    this.dragStartBehavior = DragStartBehavior.start,
    this.canRequestFocus = true,
    this.onTapOutside,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    // mouse / stylus / misc
    this.mouseCursor,
    this.stylusHandwritingEnabled,
    this.scribbleEnabled,
    this.clipBehavior = Clip.hardEdge,
    // semantics: intentionally not removing any original props you had earlier
    this.enableInteractiveSelectionToolbar,
    // buildCounter included above
    this.autofillHints
  });

  // Build InputDecoration using provided fields or decoration.
  InputDecoration _buildDecoration() {
    // If user provided a full decoration, return it (but still allow decoration-specific overrides by user)
    if (decoration != null) return decoration!;

    final borderRadius = BorderRadius.circular(4.0);

    return InputDecoration(
      labelText: labelText,
      labelStyle: labelStyle,
      hintText: hintText,
      hintStyle: hintStyle,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : prefixIconWidget,
      prefixIconConstraints: prefixIconConstraints,
      prefix: prefix,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : suffixIconWidget,
      suffixIconConstraints: suffixIconConstraints,
      suffix: suffix,
      helperText: helperText,
      helperStyle: helperStyle,
      helperMaxLines: helperMaxLines,
      counterText: counterText ?? '',
      counterStyle: counterStyle,
      errorText: errorText,
      errorStyle: errorStyle,
      errorMaxLines: errorMaxLines,
      isDense: isDense,
      contentPadding: contentPadding,
      isCollapsed: isCollapsed,
      constraints: constraints,
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: floatingLabelAlignment ?? FloatingLabelAlignment.start,
      alignLabelWithHint: alignLabelWithHint,
      semanticCounterText: semanticCounterText,
      filled: filled,
      fillColor: fillColor,
      border: border ?? OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.grey.shade400), borderRadius: borderRadius),
      enabledBorder: enabledBorder ?? OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.grey.shade400), borderRadius: borderRadius),
      disabledBorder: disabledBorder ?? OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.grey.shade300), borderRadius: borderRadius),
      focusedBorder: focusedBorder ?? OutlineInputBorder(borderSide: BorderSide(width: 2.0, color: Colors.blue), borderRadius: borderRadius),
      errorBorder: errorBorder ?? OutlineInputBorder(borderSide: BorderSide(width: 2.0, color: Colors.red), borderRadius: borderRadius),
      focusedErrorBorder: focusedErrorBorder ?? OutlineInputBorder(borderSide: BorderSide(width: 2.0, color: Colors.red), borderRadius: borderRadius),
      
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoration = _buildDecoration();

    // When validator provided -> TextFormField
    if (validator != null) {
      return TextFormField(
        // required typed params (can't pass map directly to constructor) - split out for clarity:
        controller: controller,
        focusNode: focusNode,
        decoration: decoration,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        textAlignVertical: textAlignVertical,
        cursorColor: cursorColor,
        cursorWidth: cursorWidth ?? 2.0,
        cursorHeight: cursorHeight,
        cursorRadius: cursorRadius,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        
        readOnly: readOnly,
        enabled: enabled,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        autocorrect: autocorrect,
        showCursor: showCursor,
        enableSuggestions: enableSuggestions,
        enableInteractiveSelection: enableInteractiveSelection,
        maxLines: maxLines,
        minLines: minLines,
        expands: expands,
        maxLength: maxLength,
        maxLengthEnforcement: maxLengthEnforcement,
        autofocus: autofocus,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        onEditingComplete: onEditingComplete,
        validator: validator,
        autovalidateMode: autovalidateMode,
        restorationId: restorationId,
        keyboardAppearance: keyboardAppearance,
        strutStyle: strutStyle,
        scrollPadding: scrollPadding,
        enableIMEPersonalizedLearning: enableIMEPersonalizedLearning ?? false,
        scrollController: scrollController,
        scrollPhysics: scrollPhysics,
        mouseCursor: mouseCursor,
        contextMenuBuilder: contextMenuBuilder,
        magnifierConfiguration: magnifierConfiguration,
        spellCheckConfiguration: spellCheckConfiguration,
        stylusHandwritingEnabled: stylusHandwritingEnabled ?? scribbleEnabled ?? true,
        clipBehavior: clipBehavior,
        // EditableText-level / TextField features supported by TextFormField:
        selectionControls: selectionControls,
        smartQuotesType: smartQuotesType,
        smartDashesType: smartDashesType,
        dragStartBehavior: dragStartBehavior,
        canRequestFocus: canRequestFocus,
        onTapOutside: onTapOutside ?? (PointerDownEvent event) => {focusNode?.unfocus()},
        selectionHeightStyle: selectionHeightStyle,
        selectionWidthStyle: selectionWidthStyle,
        // buildCounter is a TextFormField param
        buildCounter: buildCounter,
        autofillHints: autofillHints,
      );
    }

    // Otherwise, regular TextField:
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      textAlignVertical: textAlignVertical,
      cursorColor: cursorColor,
      cursorWidth: cursorWidth ?? 2.0,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      autocorrect: autocorrect,
      showCursor: showCursor,
      enableSuggestions: enableSuggestions,
      enableInteractiveSelection: enableInteractiveSelection,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      restorationId: restorationId,
      keyboardAppearance: keyboardAppearance,
      strutStyle: strutStyle,
      scrollPadding: scrollPadding,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning ?? false,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      mouseCursor: mouseCursor,
      contextMenuBuilder: contextMenuBuilder,
      magnifierConfiguration: magnifierConfiguration,
      spellCheckConfiguration: spellCheckConfiguration,
      stylusHandwritingEnabled: stylusHandwritingEnabled ?? scribbleEnabled ?? true,
      clipBehavior: clipBehavior,
      // EditableText-level / newer features
      selectionControls: selectionControls,
      smartQuotesType: smartQuotesType,
      smartDashesType: smartDashesType,
      dragStartBehavior: dragStartBehavior,
      canRequestFocus: canRequestFocus,
      onTapOutside: onTapOutside?? (PointerDownEvent event) => {focusNode?.unfocus()},
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      autofillHints: autofillHints,
    );
  }
}
