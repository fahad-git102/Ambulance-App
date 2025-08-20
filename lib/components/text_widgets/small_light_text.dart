import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class SmallLightText extends StatelessWidget {
  const SmallLightText(
      {super.key,
        this.title = "",
        this.textColor,
        this.textAlign,
        this.overflow,
        this.maxLines});
  final Color? textColor;
  final String? title;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      overflow: overflow,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textColor ?? AppColors.textBlack),
      textAlign: textAlign,);
  }
}