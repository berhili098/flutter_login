import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onVisibilityToggle;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool showValidationIcon;
  final bool isValid;
  final Widget? suffixIcon;

  const RegistrationFormField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscureText = false,
    this.onVisibilityToggle,
    this.validator,
    this.onChanged,
    this.showValidationIcon = false,
    this.isValid = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<RegistrationFormField> createState() => _RegistrationFormFieldState();
}

class _RegistrationFormFieldState extends State<RegistrationFormField> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        onPressed: widget.onVisibilityToggle,
        icon: CustomIconWidget(
          iconName: widget.obscureText ? 'visibility' : 'visibility_off',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      );
    }

    if (widget.showValidationIcon && widget.controller.text.isNotEmpty) {
      return CustomIconWidget(
        iconName: widget.isValid ? 'check_circle' : 'error',
        color: widget.isValid
            ? AppTheme.successLight
            : AppTheme.lightTheme.colorScheme.error,
        size: 20,
      );
    }

    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
            color: _isFocused
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: _buildSuffixIcon(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
          ),
        ),
      ],
    );
  }
}
