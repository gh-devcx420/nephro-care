import 'package:flutter/material.dart';

class NCTextfield extends StatefulWidget {
  final TextEditingController textFieldController;
  final String hintText;
  final Widget activeFieldIcon;
  final Widget inactiveFieldIcon;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;

  const NCTextfield({
    super.key,
    required this.textFieldController,
    required this.hintText,
    required this.activeFieldIcon,
    required this.inactiveFieldIcon,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
  });

  @override
  _NCTextfieldState createState() => _NCTextfieldState();
}

class _NCTextfieldState extends State<NCTextfield> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Add listener to rebuild when text changes
    widget.textFieldController.addListener(_onTextChanged);
    // Debug print to check initial text
    print(
        'NCTextfield initState: Controller text = "${widget.textFieldController.text}"');
  }

  void _onTextChanged() {
    // Trigger rebuild when text changes
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.textFieldController.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the TextField has text
    final isActive = widget.textFieldController.text.isNotEmpty;
    // Debug print to check state during build
    print(
        'NCTextfield build: Controller text = "${widget.textFieldController.text}", isActive = $isActive');

    return TextField(
      controller: widget.textFieldController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon:
            isActive ? widget.activeFieldIcon : widget.inactiveFieldIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      textCapitalization: widget.textCapitalization,
      onChanged: widget.onChanged,
    );
  }
}
