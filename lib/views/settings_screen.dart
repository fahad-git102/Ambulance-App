import 'dart:io';

import 'package:ambulance_app/components/bottomsheets/logo_bottomsheet.dart';
import 'package:ambulance_app/components/dialogs/add_dropdown_popup.dart';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/components/text_widgets/small_light_text.dart';
import 'package:ambulance_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/dropdown_manager.dart';
import '../viewmodels/main_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> dropdownValues = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = Get.find<MainController>();
      await controller.loadLogoImage();
      print("Logo image after loading: ${controller.logoImage.value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Scaffold(
      appBar: AppBar(title: CustomBoldText(
        title: 'Settings',
      ),),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBoldText(
                    title: 'App Logo',
                    fontSize: 19,
                  ),
                  IconButton(
                    onPressed: () {
                      _showImagePickerBottomSheet();
                    },
                    icon: Icon(Icons.add_a_photo),
                  )
                ],
              ),
              SizedBox(height: 4),
              Obx(() {
                // Add debug print
                print("Building logo widget. Logo image: ${controller.logoImage.value}");

                return controller.logoImage.value != null
                    ? Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.darkGray),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            controller.logoImage.value!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              print("Error loading image: $error");
                              return Container(
                                height: 100,
                                width: 100,
                                color: Colors.red.withOpacity(0.3),
                                child: Center(
                                  child: Text(
                                    "Error loading image",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            controller.removeLogoImage();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _showImagePickerBottomSheet();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.textBlack,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.darkGray,
                        style: BorderStyle.solid
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 32, color: AppColors.darkGray),
                        SizedBox(height: 4),
                        SmallLightText(
                          title: 'No logo selected',
                          textColor: AppColors.darkGray,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 20,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBoldText(
                    title: 'Type',
                    fontSize: 19,
                  ),
                  IconButton(onPressed: (){
                    _openSettingsPopup(DropdownKeys.subjectType);
                  }, icon: Icon(Icons.add))
                ],
              ),
              SizedBox(height: 4,),
              Obx((){
                return ListView.builder(itemBuilder: (context, index)
                {
                  return Container(
                    color: AppColors.lightGray,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallLightText(
                            title: controller.subjectType[index],
                          ),
                          IconButton(onPressed: () async {
                            await DropdownManager.removeValue(DropdownKeys.subjectType, controller.subjectType[index]);

                            final control = Get.find<MainController>();
                            await control.loadDropdownValues();

                          }, icon: Icon(Icons.remove))
                        ],
                      ),
                    ),
                  );
                }, itemCount: controller.subjectType.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,);
              }),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBoldText(
                    title: 'Severity',
                    fontSize: 19,
                  ),
                  IconButton(onPressed: (){
                    _openSettingsPopup(DropdownKeys.injurySeverity);
                  }, icon: Icon(Icons.add))
                ],
              ),
              SizedBox(height: 4,),
              Obx((){
                return ListView.builder(itemBuilder: (context, index)
                {
                  return Container(
                    color: AppColors.lightGray,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallLightText(
                            title: controller.injurySeverity[index],
                          ),
                          IconButton(onPressed: () async {
                            await DropdownManager.removeValue(DropdownKeys.injurySeverity, controller.injurySeverity[index]);

                            final control = Get.find<MainController>();
                            await control.loadDropdownValues();

                          }, icon: Icon(Icons.remove))
                        ],
                      ),
                    ),
                  );
                }, itemCount: controller.injurySeverity.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,);
              }),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBoldText(
                    title: 'Common Injury Type',
                    fontSize: 19,
                  ),
                  IconButton(onPressed: (){
                    _openSettingsPopup(DropdownKeys.commonInjuryType);
                  }, icon: Icon(Icons.add))
                ],
              ),
              SizedBox(height: 4,),
              Obx((){return ListView.builder(itemBuilder: (context, index)
              {
                return Container(
                  color: AppColors.lightGray,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallLightText(
                          title: controller.commonInjuryType[index],
                        ),
                        IconButton(onPressed: () async {
                          await DropdownManager.removeValue(DropdownKeys.commonInjuryType, controller.commonInjuryType[index]);

                          final control = Get.find<MainController>();
                          await control.loadDropdownValues();

                        }, icon: Icon(Icons.remove))
                      ],
                    ),
                  ),
                );
              }, itemCount: controller.commonInjuryType.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,);}),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBoldText(
                    title: 'Common Illness Type',
                    fontSize: 19,
                  ),
                  IconButton(onPressed: (){
                    _openSettingsPopup(DropdownKeys.commonIllnessType);
                  }, icon: Icon(Icons.add))
                ],
              ),
              SizedBox(height: 4,),
              Obx((){return ListView.builder(itemBuilder: (context, index)
              {
                return Container(
                  color: AppColors.lightGray,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallLightText(
                          title: controller.commonIllnessType[index],
                        ),
                        IconButton(onPressed: () async {
                          await DropdownManager.removeValue(DropdownKeys.commonIllnessType, controller.commonIllnessType[index]);

                          final control = Get.find<MainController>();
                          await control.loadDropdownValues();

                        }, icon: Icon(Icons.remove))
                      ],
                    ),
                  ),
                );
              }, itemCount: controller.commonIllnessType.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,);}),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBoldText(
                    title: 'Disposition & Notifications',
                    fontSize: 19,
                  ),
                  IconButton(onPressed: (){
                    _openSettingsPopup(DropdownKeys.dispositionsList);
                  }, icon: Icon(Icons.add))
                ],
              ),
              SizedBox(height: 4,),
              Obx((){
                return ListView.builder(itemBuilder: (context, index)
                {
                  return Container(
                    color: AppColors.lightGray,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallLightText(
                            title: controller.dispositionsList[index],
                          ),
                          IconButton(onPressed: () async {
                            await DropdownManager.removeValue(DropdownKeys.dispositionsList, controller.dispositionsList[index]);

                            final control = Get.find<MainController>();
                            await control.loadDropdownValues();

                          }, icon: Icon(Icons.remove))
                        ],
                      ),
                    ),
                  );
                }, itemCount: controller.dispositionsList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,);
              }),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBoldText(
                    title: 'Immediate Treatments',
                    fontSize: 19,
                  ),
                  IconButton(onPressed: (){
                    _openSettingsPopup(DropdownKeys.immediateTreatments);
                  }, icon: Icon(Icons.add))
                ],
              ),
              SizedBox(height: 4,),
              Obx((){
                return ListView.builder(itemBuilder: (context, index)
                {
                  return Container(
                    color: AppColors.lightGray,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallLightText(
                            title: controller.immediateTreatments[index],
                          ),
                          IconButton(onPressed: () async {
                            await DropdownManager.removeValue(DropdownKeys.immediateTreatments, controller.immediateTreatments[index]);

                            final control = Get.find<MainController>();
                            await control.loadDropdownValues();

                          }, icon: Icon(Icons.remove))
                        ],
                      ),
                    ),
                  );
                }, itemCount: controller.immediateTreatments.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,);
              }),
              SizedBox(height: 30,)
            ],
          ),
        ),
      )),
    );
  }
  void _openSettingsPopup(String key) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AddDropDownValuePopup(dropdownKey: key,);
      },
    );
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.white,
      builder: (context) => LogoPickerBottomSheet(
        onImageSelected: (File imageFile) async {
          final controller = Get.find<MainController>();
          await controller.saveLogoImage(imageFile);
          Get.back();
        },
      ),
    );
  }


}
