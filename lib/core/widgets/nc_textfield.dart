import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';

class NCTextfield extends StatefulWidget {
  static bool isFirstFocus = true;

  final TextEditingController textFieldController;
  final FocusNode? focusNode;

  final String hintText;
  final String? semanticsLabel;
  final Widget activeFieldPrefixIcon;
  final Widget inactiveFieldPrefixIcon;
  final IconData? suffixIcon;

  final bool? readOnly;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final int? maxLength;

  final Color? prefixIconColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final Color? hintTextColor;
  final Color? textColor;
  final Color? cursorColor;
  final Color? selectionHandleColor;
  final Color? suffixIconColor;

  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onSuffixIconTap;

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
    _initializeFocusNode();
    _setupListeners();
  }

  @override
  void dispose() {
    _cleanupListeners();
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
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
              borderSide: BorderSide(
                color: widget.enabledBorderColor ??
                    themeContext.colorScheme.onSurface,
                width: UIConstants.borderThickness,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ??
                    themeContext.colorScheme.onSurface,
                width: UIConstants.borderThickness,
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

  void _initializeFocusNode() {
    _focusNode = widget.focusNode ?? FocusNode();
  }

  void _setupListeners() {
    _focusNode.addListener(_onFocusChanged);
    widget.textFieldController.addListener(_onTextChanged);
  }

  void _cleanupListeners() {
    widget.textFieldController.removeListener(_onTextChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _handleFocusGained();
    }
  }

  void _handleFocusGained() {
    if (widget.textFieldController.text.isNotEmpty) {
      widget.textFieldController.selection = TextSelection.collapsed(
        offset: widget.textFieldController.text.length,
      );
    }

    if (NCTextfield.isFirstFocus == false) {
      HapticFeedback.lightImpact();
    }
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}
