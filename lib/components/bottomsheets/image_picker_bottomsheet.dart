import 'dart:io';

import 'package:ambulance_app/viewmodels/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_colors.dart';
import '../../core/image_picker_service.dart';
import '../text_widgets/custom_text.dart';
import '../text_widgets/small_light_text.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  ImagePickerBottomSheet({super.key});
  final controller = Get.find<MainController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            width: 40,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          CustomBoldText(
            title: 'Pick image',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOption(
                icon: Icons.camera_alt_rounded,
                label: "Camera",
                onTap: controller.pickImageFromCamera,
              ),
              _buildOption(
                icon: Icons.photo_library_rounded,
                label: "Gallery",
                onTap: controller.pickImageFromGallery,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  static Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.mainColor.withAlpha(30),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 32, color: AppColors.mainColor),
          ),
          const SizedBox(height: 8),
          SmallLightText(
            title: label,
          )
        ],
      ),
    );
  }
}
