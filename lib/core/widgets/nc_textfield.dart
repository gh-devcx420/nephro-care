import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';

class NCTextfield extends StatefulWidget {
  // Identification & Core Control
  final TextEditingController
      textFieldController; // Controller managing the text field's state
  final FocusNode? focusNode; // Focus management for the text field

  // Content & Accessibility
  final String hintText; // Hint text shown when the field is empty
  final String?
      semanticsLabel; // Accessibility label for assistive technologies
  final Widget
      activeFieldPrefixIcon; // Prefix icon displayed when the field is focused/active
  final Widget
      inactiveFieldPrefixIcon; // Prefix icon displayed when the field is unfocused/inactive
  final IconData?
      suffixIcon; // Suffix icon displayed to clear the field text when not empty.

  // Input Behavior & Configuration
  final bool? readOnly; // If true, disables text input
  final TextInputType? keyboardType; // Type of keyboard to display
  final TextCapitalization? textCapitalization; // Text capitalization behavior
  final TextInputAction? textInputAction; // Keyboard action button type
  final int? maxLength; // Maximum number of characters allowed

  // Styling
  final Color?
      prefixIconColor; // Color applied to the prefix icon, typically used for theming or state indication
  final Color?
      enabledBorderColor; // Outline or underline border color when the text field is enabled but not focused
  final Color?
      focusedBorderColor; // Outline or underline border color when the text field is actively focused
  final Color?
      fillColor; // Background fill color inside the text field container
  final Color? hintTextColor; // Color applied to the hint/placeholder text
  final Color? textColor; // Color applied to the user-entered text content
  final Color? cursorColor; // Color of the blinking cursor in the text field
  final Color?
      selectionHandleColor; // Color of the draggable selection handles for text selection
  final Color? suffixIconColor; // Color applied to the suffix icon

  // Event Callbacks
  final VoidCallback? onTap; // Callback triggered on field tap
  final Function(String)? onChanged; // Callback triggered on text change
  final void Function(String)?
      onSubmitted; // Callback triggered on submit action
  final VoidCallback? onSuffixIconTap; // Callback triggered on suffix icon tap
  static bool isFirstFocus = true;

  const NCTextfield({
    super.key,

    // Identification & Core Control
    required this.textFieldController,
    this.focusNode,

    // Content & Accessibility
    required this.hintText,
    this.semanticsLabel,
    required this.activeFieldPrefixIcon,
    required this.inactiveFieldPrefixIcon,
    this.suffixIcon,

    // Input Behavior & Configuration
    this.readOnly,
    this.keyboardType,
    this.textCapitalization,
    this.textInputAction,
    this.maxLength,

    // Styling
    this.prefixIconColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.hintTextColor,
    this.textColor,
    this.cursorColor,
    this.selectionHandleColor,
    this.suffixIconColor,

    // Event Callbacks
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onSuffixIconTap,
  });

  @override
  State<NCTextfield> createState() => _NCTextfieldState();
}

class _NCTextfieldState extends State<NCTextfield> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Collapse selection to hide handles on focus
        if (widget.textFieldController.text.isNotEmpty) {
          widget.textFieldController.selection = TextSelection.collapsed(
            offset: widget.textFieldController.text.length,
          );
        }

        if (NCTextfield.isFirstFocus == false) {
          HapticFeedback.lightImpact();
        }
      }
    });
    widget.textFieldController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.textFieldController.removeListener(_onTextChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);
    final hasText = widget.textFieldController.text.isNotEmpty;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor:
              widget.selectionHandleColor ?? themeContext.colorScheme.primary,
        ),
      ),
      child: Semantics(
        label: widget.semanticsLabel,
        child: TextField(
          controller: widget.textFieldController,
          focusNode: _focusNode,
          readOnly: widget.readOnly ?? false,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.words,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength ?? TextField.noMaxLength,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: themeContext.textTheme.titleMedium!.copyWith(
            color: widget.textColor ?? themeContext.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          cursorColor: widget.cursorColor ?? themeContext.colorScheme.onSurface,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: themeContext.textTheme.titleMedium!.copyWith(
              color: widget.hintTextColor ?? themeContext.colorScheme.outline,
              fontWeight: FontWeight.w400,
            ),
            counter: null,
            counterText: '',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide(
                color: widget.enabledBorderColor ??
                    themeContext.colorScheme.onSurface,
                width: kBorderThickness,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ??
                    themeContext.colorScheme.onSurface,
                width: kBorderThickness,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: widget.fillColor ??
                themeContext.colorScheme.surfaceContainerHighest,
            prefixIcon: hasText
                ? widget.activeFieldPrefixIcon
                : widget.inactiveFieldPrefixIcon,
            prefixIconColor:
                widget.prefixIconColor ?? themeContext.colorScheme.onSurface,
            suffixIcon: widget.textFieldController.text.isNotEmpty
                ? InkWell(
                    onTap: widget.onSuffixIconTap,
                    child: Icon(
                      widget.suffixIcon ?? Icons.replay_sharp,
                      color: widget.suffixIconColor ??
                          themeContext.colorScheme.onSurface,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
