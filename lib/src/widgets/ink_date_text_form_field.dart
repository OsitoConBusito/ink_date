import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';

class InkDateTextFormField extends StatefulWidget {
  const InkDateTextFormField({
    Key? key,
    this.height = 70,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.none,
    required this.labelText,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    required this.textEditingController,
    this.textInputAction = TextInputAction.done,
    this.validator,
  }) : super(key: key);

  final double height;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String labelText;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final TextEditingController textEditingController;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;

  @override
  State<InkDateTextFormField> createState() => _InkDateTextFormFieldState();
}

class _InkDateTextFormFieldState extends State<InkDateTextFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        controller: widget.textEditingController,
        decoration: _inputDecoration(),
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        obscureText: widget.isPassword && !_isPasswordVisible,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          50.0,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: Spacing.large,
        horizontal: Spacing.large,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(
          color: AppColors.darkGreen,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
      errorStyle: const TextStyle(height: 0.0),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(
          color: AppColors.darkGreen,
          width: 3.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 3.0,
        ),
      ),
      hintText: widget.hintText,
      hintStyle: const TextStyle(
        color: AppColors.darkGreen,
        fontSize: 20,
      ),
      labelText: widget.labelText,
      labelStyle: const TextStyle(
        color: AppColors.darkGreen,
        fontSize: 20,
      ),
      prefixIcon: widget.icon != null
          ? Align(
              widthFactor: 3.0,
              child: Icon(
                widget.icon,
                color: AppColors.darkGreen,
              ),
            )
          : null,
      suffix: widget.isPassword
          ? Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: IconButton(
                color: AppColors.darkGreen,
                constraints: const BoxConstraints(),
                icon: _isPasswordVisible
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            )
          : null,
    );
  }
}
