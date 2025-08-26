import 'package:ambulance_app/components/buttons/plain_button.dart';
import 'package:ambulance_app/components/text_fields/custom_text_field.dart';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/core/base_helper.dart';
import 'package:ambulance_app/models/image_model.dart';
import 'package:flutter/cupertino.dart';

import '../../core/app_colors.dart';
import '../../core/app_contants.dart';

class PhotoWidget extends StatelessWidget {
  final ImageModel? imageModel;
  final VoidCallback onRemove;

  const PhotoWidget({super.key, this.imageModel, required this.onRemove});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: appBoxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image.file(imageModel!.file, height: 150, width: double.infinity, fit: BoxFit.cover,),
          ),
          SizedBox(height: 6,),
          CustomTextField(
            label: 'Caption',
            onChanged: (val){
              imageModel?.caption = val;
            },
          ),
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomBoldText(
                fontWeight: FontWeight.w400,
                title: BaseHelper.formatDateTime(imageModel!.pickedAt),
              ),
              PlainButton(onTap: onRemove, text: 'Remove', height: 30, outLined: true, backgroundColor: AppColors.lightGray, fontSize: 12,)
            ],
          ),
        ],
      ),
    );
  }
}
