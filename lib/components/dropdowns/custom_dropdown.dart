import 'package:ambulance_app/components/text_widgets/small_light_text.dart';
import 'package:ambulance_app/core/app_colors.dart';
import 'package:flutter/material.dart';

import '../text_widgets/custom_text.dart';

class CustomDropdown extends StatelessWidget{
  const CustomDropdown({super.key, this.currentValue, required this.items, this.onChanged, this.label});

  final String? currentValue;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomBoldText(
          title: label??'E-mail',
          textColor: AppColors.textBlack,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 5,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGray, width: 1)
          ),
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: SmallLightText(
                  title: value,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

}