import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/core/app_contants.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class PlainButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? height, width;
  final double? fontSize;
  final Color? backgroundColor;
  final String? text;
  final Color? textColor;
  final bool? noShadow;
  final bool? outLined;
  final bool? active;
  final double? horizontalPadding;

  const PlainButton({
    super.key,
    required this.onTap,
    this.height,
    this.active = true,
    this.outLined = false,
    this.backgroundColor,
    this.text,
    this.textColor, this.width, this.fontSize, this.noShadow, this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active == true ? onTap : () {},
      child: Container(
        height: height ?? 48,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding??15),
        decoration: BoxDecoration(
          color: active == false
              ? AppColors.lightGray
              : outLined == true
              ? AppColors.white
              : backgroundColor ?? AppColors.textBlack,
          // color: backgroundColor??AppColors.buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: outLined == true
                ? backgroundColor ?? Theme.of(context).primaryColor
                : Colors.transparent,
          ),
          boxShadow: noShadow==false?appBoxShadow:null,
        ),
        child: Center(
          child: CustomBoldText(
            fontSize: fontSize??16,
            fontWeight: FontWeight.w500,
            title: text ?? 'Done',
            textColor: outLined == true
                ? AppColors.textBlack
                : textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
