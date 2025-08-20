import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CustomBoldText extends StatelessWidget {
  const CustomBoldText(
      {super.key,
        this.title = "",
        this.textColor,
        this.textAlign,
        this.overflow,
        this.textDecoration,
        this.fontWeight,
        this.fontSize,
        this.maxLines});
  final Color? textColor;
  final String? title;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDecoration? textDecoration;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      overflow: overflow,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
          fontSize: fontSize??14,
          decoration: textDecoration,
          fontWeight: fontWeight??FontWeight.w600,
          color: textColor ?? AppColors.textBlack),
      textAlign: textAlign,);
  }
}