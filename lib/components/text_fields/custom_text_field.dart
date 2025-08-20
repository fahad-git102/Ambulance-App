import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../text_widgets/custom_text.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final bool? obscureText;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool? enabled;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double? cornerRadius;
  final String? hintText;
  final int? maxLines, minLines;
  final String? errorText;
  final VoidCallback? onTap;
  final bool? readOnly;

  const CustomTextField({
    super.key,
    this.label,
    this.minLines,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.obscureText,
    this.inputType,
    this.controller,
    this.validator,
    this.hintText,
    this.cornerRadius,
    this.maxLines,
    this.enabled = true,
    this.errorText,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null && label?.isNotEmpty == true
            ? CustomBoldText(
                title: label ?? 'E-mail',
                textColor: AppColors.textBlack,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              )
            : Container(),
        label != null && label?.isNotEmpty == true
            ? SizedBox(height: 5)
            : Container(),
        TextFormField(
          obscureText: obscureText ?? false,
          controller: controller,
          onTap: onTap,
          validator: validator,
          minLines: minLines,
          maxLines: obscureText == true ? 1 : maxLines,
          readOnly: readOnly == true || suffixIcon != null,
          enabled: enabled,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            hintText: hintText,
            errorText: errorText,
            hintStyle: TextStyle(color: AppColors.darkGray),
            fillColor: enabled == false
                ? AppColors.lightestGray
                : AppColors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 15.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cornerRadius ?? 8),
              borderSide: BorderSide(color: AppColors.lightGray, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cornerRadius ?? 8),
              borderSide: BorderSide(color: AppColors.lightGray, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cornerRadius ?? 8),
              borderSide: BorderSide(color: AppColors.lightGray, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cornerRadius ?? 8),
              borderSide: BorderSide(color: AppColors.lightGray, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cornerRadius ?? 8),
              borderSide: BorderSide(color: AppColors.lightGray, width: 1),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
          keyboardType: inputType ?? TextInputType.text,
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
