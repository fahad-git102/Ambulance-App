import 'package:ambulance_app/components/text_widgets/small_light_text.dart';
import 'package:flutter/cupertino.dart';

import '../../core/app_colors.dart';
import '../../core/app_contants.dart';
import '../buttons/plain_button.dart';
import '../text_widgets/custom_text.dart';

class BodyInjuryWidget extends StatelessWidget {
  final String? title, notes, added, severity, region, injuryType, gender;
  final VoidCallback? onRemoveTap, onEditTap, onDuplicateTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: appBoxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomBoldText(
                  title: title,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 10,),
              PlainButton(
                outLined: true,
                fontSize: 11,
                height: 30,
                horizontalPadding: 10,
                backgroundColor: AppColors.lightGray,
                text: 'Edit',
                onTap: onEditTap,
              ),
              SizedBox(width: 5),
              PlainButton(
                outLined: true,
                fontSize: 11,
                height: 30,
                horizontalPadding: 10,
                backgroundColor: AppColors.lightGray,
                text: 'Duplicate',
                onTap: onDuplicateTap,
              ),
              SizedBox(width: 5),
              PlainButton(
                outLined: true,
                fontSize: 11,
                height: 30,
                horizontalPadding: 10,
                backgroundColor: AppColors.lightGray,
                text: 'Remove',
                onTap: onRemoveTap,
              ),
            ],
          ),
          SizedBox(height: 5,),
          SmallLightText(
            title: '$gender - $injuryType ($severity) -- $notes',
          ),
          SizedBox(height: 5,),
          SmallLightText(
            textColor: AppColors.lightGray,
            title: 'Added: $added',
          )
        ],
      ),
    );
  }

  BodyInjuryWidget({super.key, this.title, this.notes, this.added, this.severity, this.onRemoveTap, this.onEditTap, this.onDuplicateTap, this.region, this.injuryType, this.gender});
}
