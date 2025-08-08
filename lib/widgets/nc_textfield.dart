import 'package:flutter/material.dart';
import 'package:nephro_care/constants/constants.dart';

class NCTextfield extends StatefulWidget {
  const NCTextfield({
    super.key,
    required this.textFieldController,
    this.focusNode,
    required this.hintText,
    required this.activeFieldIcon,
    required this.inactiveFieldIcon,
    this.textCapitalization = TextCapitalization.words,
    this.onChanged,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.prefixIconColor,
    this.fillColor,
    this.hintTextColor,
    this.textColor,
    this.cursorColor,
    this.selectionHandleColor,
    this.onTap,
    this.keyboardType,
    this.onSuffixIconTap,
    this.maxLength,
    this.readOnly = false,
    this.semanticsLabel,
    this.textInputAction,
    this.onSubmitted,
    this.suffixText,
  });

  final TextEditingController textFieldController;
  final FocusNode? focusNode;
  final String hintText;
  final Widget activeFieldIcon;
  final Widget inactiveFieldIcon;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Function(String)? onChanged;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? prefixIconColor;
  final Color? fillColor;
  final Color? hintTextColor;
  final Color? textColor;
  final String? suffixText;
  final Color? cursorColor;
  final Color? selectionHandleColor;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixIconTap;
  final bool readOnly;
  final String? semanticsLabel;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  @override
  State<NCTextfield> createState() => _NCTextfieldState();
}

class _NCTextfieldState extends State<NCTextfield> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {});
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
    final isActive = widget.textFieldController.text.isNotEmpty;

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
          onTap: widget.onTap,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          controller: widget.textFieldController,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          style: themeContext.textTheme.titleMedium!.copyWith(
            color: widget.textColor ?? themeContext.colorScheme.primary,
          ),
          cursorColor: widget.cursorColor ?? themeContext.colorScheme.primary,
          focusNode: _focusNode,
          maxLength: widget.maxLength ?? TextField.noMaxLength,
          readOnly: widget.readOnly,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            counter: null,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 10.0,
            ),
            hintText: widget.hintText,
            hintStyle: themeContext.textTheme.titleMedium!.copyWith(
              color: widget.hintTextColor ?? themeContext.colorScheme.primary,
            ),
            suffixText: widget.textFieldController.text.isNotEmpty
                ? widget.suffixText
                : '',
            suffixStyle: themeContext.textTheme.titleMedium!.copyWith(
              color: widget.textColor ?? themeContext.colorScheme.primary,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide(
                color: widget.enabledBorderColor ??
                    themeContext.colorScheme.primary,
                width: kBorderThickness,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ??
                    themeContext.colorScheme.primary,
                width: kBorderThickness,
              ),
            ),
            prefixIconColor:
                widget.prefixIconColor ?? themeContext.colorScheme.primary,
            suffixIcon: widget.textFieldController.text.isNotEmpty
                ? InkWell(
                    onTap: widget.onSuffixIconTap,
                    child: Icon(
                      Icons.replay_sharp,
                      color: widget.prefixIconColor ??
                          themeContext.colorScheme.primary,
                    ),
                  )
                : null,
            filled: true,
            fillColor: widget.fillColor ?? themeContext.colorScheme.surfaceDim,
            prefixIcon:
                isActive ? widget.activeFieldIcon : widget.inactiveFieldIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
