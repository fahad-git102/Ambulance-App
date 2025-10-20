import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ambulance_app/components/buttons/plain_button.dart';
import 'package:ambulance_app/components/common_widgets/back_body_female.dart';
import 'package:ambulance_app/components/common_widgets/body_injury_widget.dart';
import 'package:ambulance_app/components/common_widgets/front_body_female.dart';
import 'package:ambulance_app/components/common_widgets/front_body_male.dart';
import 'package:ambulance_app/components/common_widgets/photo_widget.dart';
import 'package:ambulance_app/components/dialogs/body_map_dialog.dart';
import 'package:ambulance_app/components/dropdowns/custom_dropdown.dart';
import 'package:ambulance_app/components/text_fields/custom_text_field.dart';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/components/text_widgets/small_light_text.dart';
import 'package:ambulance_app/core/app_colors.dart';
import 'package:ambulance_app/core/app_contants.dart';
import 'package:ambulance_app/core/base_helper.dart';
import 'package:ambulance_app/core/new_pdf_generator.dart';
import 'package:ambulance_app/viewmodels/main_controller.dart';
import 'package:ambulance_app/views/pin_update_screen.dart';
import 'package:ambulance_app/views/resports_list_screen.dart';
import 'package:ambulance_app/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:interactable_svg/interactable_svg/interactable_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../components/bottomsheets/image_picker_bottomsheet.dart';
import '../components/common_widgets/back_body_male.dart';
import '../components/dialogs/edit_body_map_dialog.dart';
import '../core/body_pdf_helper.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final DateTime initialDate = DateTime.now();
  final GlobalKey<SfSignaturePadState> _responderKey = GlobalKey();
  final GlobalKey<SfSignaturePadState> _patientKey = GlobalKey();
  final GlobalKey<SfSignaturePadState> _guardianKey = GlobalKey();
  Set<String> selectedFrontMaleBodyParts = <String>{};
  Set<String> selectedBackMaleBodyParts = <String>{};
  Set<String> selectedFrontFemaleBodyParts = <String>{};
  Set<String> selectedBackFemaleBodyParts = <String>{};
  final GlobalKey _frontMaleBodyKey = GlobalKey();
  final GlobalKey _backMaleBodyKey = GlobalKey();
  final GlobalKey _frontFemaleBodyKey = GlobalKey();
  final GlobalKey _backFemaleBodyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.lightestGray,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/ambulance_logo.png', height: 70, width: 70),
            SizedBox(width: 10),
            CustomBoldText(
              title: 'School E Pcr',
              textColor: AppColors.textBlack,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.textBlack),
            onSelected: (value) {
              if (value == 'report') {
                // navigate to report form
              } else if (value == 'past') {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => ReportsListScreen(),
                  ),
                );
              } else if (value == 'pin') {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => PinUpdateScreen(),
                  ),
                );
              } else if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'report', child: Text('Report Form')),
              PopupMenuItem(value: 'past', child: Text('Past Reports')),
              PopupMenuItem(value: 'pin', child: Text('Update Pin')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: appBoxShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBoldText(title: 'Subject', fontSize: 19),
                      const SizedBox(height: 10),
                      Obx(() {
                        if (!controller.subjectType.toList().contains(
                              controller.selectedSubjectType.value,
                            ) &&
                            controller.subjectType.toList().isNotEmpty) {
                          controller.selectedSubjectType.value = controller
                              .subjectType
                              .toList()
                              .first;
                        }
                        return CustomDropdown(
                          label: 'Type',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setSubjectType(val);
                            }
                          },
                          currentValue: controller.selectedSubjectType.value,
                          items: controller.subjectType.toList(),
                        );
                      }),
                      const SizedBox(height: 7),
                      Obx(() {
                        return CustomDropdown(
                          label: 'Gender',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setSubjectGender(val);
                            }
                          },
                          currentValue: controller.selectedSubjectGender.value,
                          items: controller.subjectGender,
                        );
                      }),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'Student ID *',
                        controller: controller.studentIDController,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'First Name *',
                        controller: controller.firstNameController,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'Last Name *',
                        controller: controller.lastNameController,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'DOB',
                        readOnly: true,
                        controller: controller.dobController,
                        suffixIcon: Icon(Icons.calendar_today, size: 18),
                        onTap: () {
                          controller.pickDate(
                            initialDate,
                            controller.dobController,
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: appBoxShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBoldText(title: 'Incident', fontSize: 19),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'Date & Time (occurred) *',
                        readOnly: true,
                        controller: controller.occurredDateController,
                        suffixIcon: Icon(Icons.calendar_today, size: 18),
                        onTap: () {
                          controller.pickDateTime(
                            initialDate,
                            controller.occurredDateController,
                          );
                        },
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'Site',
                        controller: controller.siteController,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'Location *',
                        controller: controller.locationController,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'Activity',
                        controller: controller.activityController,
                      ),
                      const SizedBox(height: 7),
                      Obx(() {
                        if (!controller.injurySeverity.toList().contains(
                              controller.selectedInjurySeverity.value,
                            ) &&
                            controller.injurySeverity.toList().isNotEmpty) {
                          controller.selectedInjurySeverity.value = controller
                              .injurySeverity
                              .toList()
                              .first;
                        }
                        return CustomDropdown(
                          label: 'Severity',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setInjurySeverity(val);
                            }
                          },
                          currentValue: controller.selectedInjurySeverity.value,
                          items: controller.injurySeverity.toList(),
                        );
                      }),
                      Obx(() {
                        return controller.selectedInjurySeverity.value ==
                                "Other"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 3.0,
                                  bottom: 4,
                                ),
                                child: CustomTextField(
                                  label: 'Specify Other Severity',
                                  hintText: 'e.g. Critical, Fatal',
                                  onChanged: (val) {
                                    controller.otherSeverityText.value = val;
                                  },
                                ),
                              )
                            : Container();
                      }),
                      const SizedBox(height: 7),
                      Obx(() {
                        if (!controller.commonInjuryType.toList().contains(
                              controller.selectedCommonInjuryType.value,
                            ) &&
                            controller.commonInjuryType.toList().isNotEmpty) {
                          controller.selectedCommonInjuryType.value = controller
                              .commonInjuryType
                              .toList()
                              .first;
                        }
                        return CustomDropdown(
                          label: 'Common Injury Type',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setCommonInjuryType(val);
                            }
                          },
                          currentValue:
                              controller.selectedCommonInjuryType.value,
                          items: controller.commonInjuryType.toList(),
                        );
                      }),
                      Obx(() {
                        return controller.selectedCommonInjuryType.value ==
                                "Other"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 3.0,
                                  bottom: 4,
                                ),
                                child: CustomTextField(
                                  label: 'Specify Other Injury',
                                  hintText: 'e.g. Finger Jam, Ear laceration',
                                  onChanged: (val) {
                                    controller.otherInjuryText.value = val;
                                  },
                                ),
                              )
                            : Container();
                      }),
                      const SizedBox(height: 7),
                      Obx(() {
                        if (!controller.commonIllnessType.toList().contains(
                              controller.selectedCommonIllnessType.value,
                            ) &&
                            controller.commonIllnessType.toList().isNotEmpty) {
                          controller.selectedCommonIllnessType.value =
                              controller.commonIllnessType.toList().first;
                        }
                        return CustomDropdown(
                          label: 'Common Illness Type',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setCommonIllnessType(val);
                            }
                          },
                          currentValue:
                              controller.selectedCommonIllnessType.value,
                          items: controller.commonIllnessType.toList(),
                        );
                      }),
                      Obx(() {
                        return controller.selectedCommonIllnessType.value ==
                                "Other"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 3.0,
                                  bottom: 4,
                                ),
                                child: CustomTextField(
                                  label: 'Specify Other Illness',
                                  hintText: 'e.g. Migraine, Stomach bug',
                                  onChanged: (val) {
                                    controller.otherIllnessText.value = val;
                                  },
                                ),
                              )
                            : Container();
                      }),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'Chief Complaint *',
                        controller: controller.chiefComplaintController,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'Mechanism / Illness',
                        controller: controller.mechanismController,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(
                        label: 'Notes',
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        controller: controller.notesController,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomBoldText(title: 'Vitals', fontSize: 19),
                          PlainButton(
                            text: 'Add Vital Sets',
                            onTap: () {
                              controller.addVitalSet();
                            },
                            height: 40,
                            noShadow: true,
                            outLined: true,
                            fontSize: 13,
                            backgroundColor: AppColors.lightGray,
                            textColor: AppColors.textBlack,
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Obx(() {
                        return Column(
                          children: List.generate(controller.vitalSets.length, (
                            index,
                          ) {
                            final vital = controller.vitalSets[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 13),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: appBoxShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CustomTextField(
                                          label: 'Time',
                                          readOnly: true,
                                          controller: vital.time,
                                          suffixIcon: Icon(
                                            Icons.calendar_today,
                                            size: 18,
                                          ),
                                          onTap: () {
                                            controller.pickDateTime(
                                              initialDate,
                                              vital.time,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        flex: 1,
                                        child: CustomTextField(
                                          label: 'HR',
                                          controller: vital.hr,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          label: 'RR',
                                          controller: vital.rr,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: CustomTextField(
                                          label: 'BP Sys',
                                          controller: vital.bpSys,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          label: 'BP Dia',
                                          controller: vital.bpDia,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: CustomTextField(
                                          label: 'SpO₂ %',
                                          controller: vital.spo2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          label: 'Temp °C',
                                          controller: vital.temp,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Obx(() => Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("°C", style: TextStyle(fontSize: 18)),
                                          SizedBox(
                                            width: 43,  // adjust width
                                            height: 18, // adjust height
                                            child: Transform.scale(
                                              scale: 0.7, // shrink switch inside the box
                                              child: Switch(
                                                value: !controller.isCelsius.value,
                                                onChanged: (value) => controller.toggleUnit(),
                                              ),
                                            ),
                                          ),
                                          Text("°F", style: TextStyle(fontSize: 18)),
                                        ],
                                      )),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: CustomTextField(
                                          label: 'BGL mg/dL',
                                          controller: vital.bgl,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  CustomTextField(
                                    label: 'GCS',
                                    controller: vital.gcs,
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: appBoxShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBoldText(
                        title: 'Immediate Treatments',
                        fontSize: 19,
                      ),
                      SizedBox(height: 18),
                      Obx(() {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 9,
                                mainAxisSpacing: 9,
                                childAspectRatio: 2.5,
                              ),
                          itemCount: controller.immediateTreatments.length,
                          itemBuilder: (context, index) {
                            final item = controller.immediateTreatments[index];

                            return Obx(() {
                              final isChecked = controller.isSelected(index);
                              return Container(
                                decoration: BoxDecoration(
                                  color: isChecked
                                      ? Colors.green.withAlpha(30)
                                      : Colors.white,
                                  border: Border.all(
                                    color: isChecked
                                        ? Colors.green
                                        : AppColors.lightGray,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (_) =>
                                          controller.toggleSelection(index),
                                    ),
                                    SmallLightText(title: item),
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      }),
                      Obx(() {
                        bool isOtherSelected = controller
                            .selectedImmediateTreatments
                            .contains(7);
                        return isOtherSelected
                            ? Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: CustomTextField(
                                  label: 'Specify Other Treatment',
                                  hintText: 'e.g. Oxygen, Medication, etc.',
                                  onChanged: (val) {
                                    controller.otherTreatmentText.value = val;
                                  },
                                ),
                              )
                            : Container();
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: appBoxShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomBoldText(title: 'Photos', fontSize: 19),
                          Obx(() {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: controller.guardianConsentOnFile.value,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (_) =>
                                      controller.toggleGuardianConsentOnFile(),
                                ),
                                CustomBoldText(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  title: 'Guardian/subject consent on file',
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 10),
                      Obx(() {
                        return controller.pickedPhotos.isEmpty
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.only(bottom: 18),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return PhotoWidget(
                                      imageModel:
                                          controller.pickedPhotos[index],
                                      onRemove: () {
                                        controller.removeImage(index);
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 8);
                                  },
                                  itemCount: controller.pickedPhotos.length,
                                ),
                              );
                      }),
                      PlainButton(
                        text: 'Add Photo',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            backgroundColor: AppColors.white,
                            builder: (context) => ImagePickerBottomSheet(),
                          );
                        },
                        height: 40,
                        noShadow: true,
                        width: 120,
                        outLined: true,
                        fontSize: 13,
                        backgroundColor: AppColors.lightGray,
                        textColor: AppColors.textBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // FrontBodyMale(),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: appBoxShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBoldText(title: 'Body Map (male)', fontSize: 19),
                      SmallLightText(
                        title:
                            'Click a hotspot to add; edit or duplicate marks from the list.',
                        textColor: AppColors.darkGray,
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            return InkWell(
                              onTap: () {
                                controller.toggleIsMale(true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.isMale.value
                                      ? AppColors.textBlack
                                      : AppColors.white,
                                  border: Border.all(
                                    color: AppColors.lightGray,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SmallLightText(
                                  title: 'Male',
                                  textColor: controller.isMale.value == false
                                      ? AppColors.textBlack
                                      : AppColors.white,
                                ),
                              ),
                            );
                          }),
                          SizedBox(width: 10),
                          Obx(() {
                            return InkWell(
                              onTap: () {
                                controller.toggleIsMale(false);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.isMale.value == false
                                      ? AppColors.textBlack
                                      : AppColors.white,
                                  border: Border.all(
                                    color: AppColors.lightGray,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SmallLightText(
                                  title: 'Female',
                                  textColor: controller.isMale.value == false
                                      ? AppColors.white
                                      : AppColors.textBlack,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            return InkWell(
                              onTap: () {
                                controller.toggleIsFront(true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.isFront.value
                                      ? AppColors.textBlack
                                      : AppColors.white,
                                  border: Border.all(
                                    color: AppColors.lightGray,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SmallLightText(
                                  title: 'Front',
                                  textColor: controller.isFront.value == true
                                      ? AppColors.white
                                      : AppColors.textBlack,
                                ),
                              ),
                            );
                          }),
                          SizedBox(width: 10),
                          Obx(() {
                            return InkWell(
                              onTap: () {
                                controller.toggleIsFront(false);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.isFront.value == false
                                      ? AppColors.textBlack
                                      : AppColors.white,
                                  border: Border.all(
                                    color: AppColors.lightGray,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SmallLightText(
                                  title: 'Back',
                                  textColor: controller.isFront.value == false
                                      ? AppColors.white
                                      : AppColors.textBlack,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 15),
                      Obx(() {
                        // Compute selected parts from injury list
                        final selectedFrontMale = controller.bodyInjuryList
                            .where((i) => i.gender == 'Male' && i.bodySide == 'Front')
                            .map((i) => i.region ?? '')
                            .toSet();

                        if (controller.tempSelectedPart.value != null) {
                          selectedFrontMale.add(controller.tempSelectedPart.value!);
                        }

                        final selectedBackMale = controller.bodyInjuryList
                            .where((i) => i.gender == 'Male' && i.bodySide == 'Back')
                            .map((i) => i.region ?? '')
                            .toSet();

                        if (controller.tempSelectedPart.value != null) {
                          selectedBackMale.add(controller.tempSelectedPart.value!);
                        }

                        final selectedFrontFemale = controller.bodyInjuryList
                            .where((i) => i.gender == 'Female' && i.bodySide == 'Front')
                            .map((i) => i.region ?? '')
                            .toSet();

                        if (controller.tempSelectedPart.value != null) {
                          selectedFrontFemale.add(controller.tempSelectedPart.value!);
                        }

                        final selectedBackFemale = controller.bodyInjuryList
                            .where((i) => i.gender == 'Female' && i.bodySide == 'Back')
                            .map((i) => i.region ?? '')
                            .toSet();

                        if (controller.tempSelectedPart.value != null) {
                          selectedBackFemale.add(controller.tempSelectedPart.value!);
                        }

                        return Stack(
                          children: [
                            Offstage(
                              offstage: !(controller.isMale.value == true && controller.isFront.value == true),
                              child: RepaintBoundary(
                                key: _frontMaleBodyKey,
                                child: FrontBodyMale(
                                  selectedBodyParts: selectedFrontMale,
                                  onBodyPartSelected: (part) {
                                    controller.tempSelectedPart.value = part;
                                    Get.dialog(
                                      BodyMapDialog(
                                        gender: 'Male',
                                        title: "Add Injury — Front · $part",
                                        bodySide: 'Front',
                                        region: part,
                                        onCancel: () {
                                          controller.clearTempSelection();
                                        },
                                      ),
                                    ).then((_) {
                                      controller.clearTempSelection();
                                    });
                                  },
                                  onSelectedPartsChanged: (selectedParts) {
                                    selectedFrontMaleBodyParts = selectedParts;
                                  },
                                ),
                              ),
                            ),

                            // Back Male
                            Offstage(
                              offstage: !(controller.isMale.value == true && controller.isFront.value == false),
                              child: RepaintBoundary(
                                key: _backMaleBodyKey,
                                child: BackBodyMale(
                                  selectedBodyParts: selectedBackMale,
                                  onBodyPartSelected: (part) {
                                    controller.tempSelectedPart.value = part;
                                    Get.dialog(
                                      BodyMapDialog(
                                        gender: 'Male',
                                        title: "Add Injury — Back · $part",
                                        bodySide: 'Back',
                                        region: part,
                                        onCancel: () {
                                          controller.clearTempSelection();
                                        },
                                      ),
                                    ).then((_) {
                                      controller.clearTempSelection();
                                    });
                                  },
                                  onSelectedPartsChanged: (selectedParts) {
                                    selectedBackMaleBodyParts = selectedParts;
                                  },
                                ),
                              ),
                            ),

                            // Front Female
                            Offstage(
                              offstage: !(controller.isMale.value == false && controller.isFront.value == true),
                              child: RepaintBoundary(
                                key: _frontFemaleBodyKey,
                                child: FrontBodyFemale(
                                  selectedBodyParts: selectedFrontFemale,
                                  onBodyPartSelected: (part) {
                                    controller.tempSelectedPart.value = part;
                                    Get.dialog(
                                      BodyMapDialog(
                                        gender: 'Female',
                                        title: "Add Injury — Front · $part",
                                        bodySide: 'Front',
                                        region: part,
                                        onCancel: () {
                                          controller.clearTempSelection();
                                        },
                                      ),
                                    ).then((_) {
                                      controller.clearTempSelection();
                                    });
                                  },
                                  onSelectedPartsChanged: (selectedParts) {
                                    selectedFrontFemaleBodyParts = selectedParts;
                                  },
                                ),
                              ),
                            ),

                            // Back Female
                            Offstage(
                              offstage: !(controller.isMale.value == false && controller.isFront.value == false),
                              child: RepaintBoundary(
                                key: _backFemaleBodyKey,
                                child: BackBodyFemale(
                                  selectedBodyParts: selectedBackFemale,
                                  onBodyPartSelected: (part) {
                                    controller.tempSelectedPart.value = part;
                                    Get.dialog(
                                      BodyMapDialog(
                                        gender: 'Female',
                                        title: "Add Injury — Back · $part",
                                        bodySide: 'Back',
                                        region: part,
                                        onCancel: () {
                                          controller.clearTempSelection();
                                        },
                                      ),
                                    ).then((_) {
                                      controller.clearTempSelection();
                                    });
                                  },
                                  onSelectedPartsChanged: (selectedParts) {
                                    selectedBackFemaleBodyParts = selectedParts;
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 20),
                      Obx(() {
                        return controller.bodyInjuryList.isEmpty == true
                            ? Container()
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Obx(() {
                                    return BodyInjuryWidget(
                                      gender:
                                          controller
                                              .bodyInjuryList[index]
                                              .gender ??
                                          'Male',
                                      injuryType: controller
                                          .bodyInjuryList[index]
                                          .injuryType,
                                      added: controller
                                          .bodyInjuryList[index]
                                          .added,
                                      severity: controller
                                          .bodyInjuryList[index]
                                          .severity,
                                      notes: controller
                                          .bodyInjuryList[index]
                                          .notes,
                                      region: controller
                                          .bodyInjuryList[index]
                                          .region,
                                      title:
                                          '${controller.bodyInjuryList[index].bodySide} -- ${controller.bodyInjuryList[index].region}',
                                      onRemoveTap: () {
                                        controller.removeBodyInjuries(
                                          controller.bodyInjuryList[index].id,
                                        );

                                      },
                                      onDuplicateTap: () {
                                        controller.addBodyInjuries(
                                          controller.bodyInjuryList[index],
                                        );
                                      },
                                      onEditTap: () {
                                        Get.dialog(
                                          EditBodyMapDialog(
                                            injuryId: controller
                                                .bodyInjuryList[index]
                                                .id,
                                            title:
                                                "Edit Injury — ${controller.bodyInjuryList[index].bodySide} · ${controller.bodyInjuryList[index].region}",
                                            bodySide:
                                                controller.isFront.value == true
                                                ? 'Front'
                                                : 'Back',
                                            region: controller
                                                .bodyInjuryList[index]
                                                .region,
                                            injuryType: controller
                                                .bodyInjuryList[index]
                                                .injuryType,
                                            severity: controller
                                                .bodyInjuryList[index]
                                                .severity,
                                            notes: controller
                                                .bodyInjuryList[index]
                                                .notes,
                                          ),
                                        );
                                      },
                                    );
                                  });
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 10);
                                },
                                itemCount: controller.bodyInjuryList.length,
                              );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: appBoxShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBoldText(title: 'Signatures', fontSize: 19),
                      SizedBox(height: 10),
                      _buildSignatureWidget(_responderKey, 'Responder'),
                      SizedBox(height: 14),
                      _buildSignatureWidget(_patientKey, 'Patient'),
                      SizedBox(height: 14),
                      _buildSignatureWidget(_guardianKey, 'Guardian'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: appBoxShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBoldText(
                        title: 'Disposition & Notifications',
                        fontSize: 19,
                      ),
                      SizedBox(height: 10),
                      Obx(() {
                        if (!controller.dispositionsList.toList().contains(
                              controller.selectedDisposition.value,
                            ) &&
                            controller.dispositionsList.toList().isNotEmpty) {
                          controller.selectedDisposition.value = controller
                              .dispositionsList
                              .toList()
                              .first;
                        }
                        return CustomDropdown(
                          label: 'Disposition',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setDisposition(val);
                            }
                          },
                          currentValue: controller.selectedDisposition.value,
                          items: controller.dispositionsList.toList(),
                        );
                      }),
                      Obx(() {
                        return controller.selectedDisposition.value == "Other"
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 3.0,
                                  bottom: 4,
                                ),
                                child: CustomTextField(
                                  label: 'Specify Other Disposition',
                                  hintText:
                                      'e.g. Follow-up required, Referred to clinic/ER',
                                  onChanged: (val) {
                                    controller.otherDispositionText.value = val;
                                  },
                                ),
                              )
                            : Container();
                      }),
                      SizedBox(height: 14),
                      Obx(() {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: controller.guardianNotify.value,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (_) =>
                                  controller.toggleGuardianNotify(),
                            ),
                            CustomBoldText(
                              fontWeight: FontWeight.w400,
                              title: 'Notify Guardian',
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 10),
                      Obx(() {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: controller.adminNotify.value,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (_) => controller.toggleAdminNotify(),
                            ),
                            CustomBoldText(
                              fontWeight: FontWeight.w400,
                              title: 'Notify Admin',
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                PlainButton(
                  text: 'Export PDF',
                  onTap: () async {
                    EasyLoading.show();
                    final originalIsMale = controller.isMale.value;
                    final originalIsFront = controller.isFront.value;
                    final responderSig = await BaseHelper().getSignatureBytes(
                      _responderKey,
                    );
                    final patientSig = await BaseHelper().getSignatureBytes(
                      _patientKey,
                    );
                    final guardianSig = await BaseHelper().getSignatureBytes(
                      _guardianKey,
                    );
                    final vitalsList = controller.vitalSets
                        .map((v) => v.toMap())
                        .toList();
                    final bodyMapDescriptions = controller.bodyInjuryList.map((
                      injury,
                    ) {
                      return {
                        "bodySide": injury.bodySide ?? '',
                        "region": injury.region ?? '',
                        "gender": injury.gender ?? '',
                        "injuryType": injury.injuryType ?? '',
                        "severity": injury.severity ?? '',
                        "notes": injury.notes ?? '',
                      };
                    }).toList();

                    final photosList = await Future.wait(
                      controller.pickedPhotos.map(
                        (img) async => {
                          "pickedAt": img.pickedAt.toIso8601String(),
                          "file": await img.file.readAsBytes(),
                          "caption": img.caption ?? "",
                        },
                      ),
                    );

                    Uint8List? logoBytes;
                    if (controller.logoImage.value != null &&
                        await controller.logoImage.value!.exists()) {
                      try {
                        logoBytes = await controller.logoImage.value!
                            .readAsBytes();
                      } catch (e) {
                        logoBytes = null;
                      }
                    }

                    List<String> treatmentsStrList = [];
                    for (
                      int i = 0;
                      i < controller.selectedImmediateTreatments.length;
                      i++
                    ) {
                      String treatment = controller.immediateTreatments
                          .toList()[controller.selectedImmediateTreatments[i]];
                      if (treatment == "Other" &&
                          controller.otherTreatmentText.value.isNotEmpty) {
                        treatmentsStrList.add(
                          controller.otherTreatmentText.value,
                        );
                      } else {
                        treatmentsStrList.add(treatment);
                      }
                    }

                    final List<Map<String, dynamic>> bodyWidgetDescriptions =
                        [];

                    final selectedFrontMale = controller.bodyInjuryList
                        .where((i) => i.gender == 'Male' && i.bodySide == 'Front')
                        .map((i) => i.region ?? '')
                        .toSet();

                    final selectedBackMale = controller.bodyInjuryList
                        .where((i) => i.gender == 'Male' && i.bodySide == 'Back')
                        .map((i) => i.region ?? '')
                        .toSet();

                    final selectedFrontFemale = controller.bodyInjuryList
                        .where((i) => i.gender == 'Female' && i.bodySide == 'Front')
                        .map((i) => i.region ?? '')
                        .toSet();

                    final selectedBackFemale = controller.bodyInjuryList
                        .where((i) => i.gender == 'Female' && i.bodySide == 'Back')
                        .map((i) => i.region ?? '')
                        .toSet();

                    if (selectedFrontMale.isNotEmpty) {
                      controller.toggleIsMale(true);
                      controller.toggleIsFront(true);
                      await Future.delayed(Duration(milliseconds: 500)); // Wait for render
                      final imageBytes = await BodyWidgetPdfHelper.captureWidgetAsImage(
                        _frontMaleBodyKey,
                      );
                      if (imageBytes != null) {
                        bodyWidgetDescriptions.add({
                          'type': 'front_male',
                          'title': 'Male Front View - Selected Injuries',
                          'selectedParts': selectedFrontMale.toList(),
                          'imageBytes': imageBytes,
                        });
                      }
                    }

                    // Capture Back Male
                    if (selectedBackMale.isNotEmpty) {
                      controller.toggleIsMale(true);
                      controller.toggleIsFront(false);
                      await Future.delayed(Duration(milliseconds: 500)); // Wait for render
                      final imageBytes = await BodyWidgetPdfHelper.captureWidgetAsImage(
                        _backMaleBodyKey,
                      );
                      if (imageBytes != null) {
                        bodyWidgetDescriptions.add({
                          'type': 'back_male',
                          'title': 'Male Back View - Selected Injuries',
                          'selectedParts': selectedBackMale.toList(),
                          'imageBytes': imageBytes,
                        });
                      }
                    }

                    // Capture Front Female
                    if (selectedFrontFemale.isNotEmpty) {
                      controller.toggleIsMale(false);
                      controller.toggleIsFront(true);
                      await Future.delayed(Duration(milliseconds: 500)); // Wait for render
                      final imageBytes = await BodyWidgetPdfHelper.captureWidgetAsImage(
                        _frontFemaleBodyKey,
                      );
                      if (imageBytes != null) {
                        bodyWidgetDescriptions.add({
                          'type': 'front_female',
                          'title': 'Female Front View - Selected Injuries',
                          'selectedParts': selectedFrontFemale.toList(),
                          'imageBytes': imageBytes,
                        });
                      }
                    }

                    // Capture Back Female
                    if (selectedBackFemale.isNotEmpty) {
                      controller.toggleIsMale(false);
                      controller.toggleIsFront(false);
                      await Future.delayed(Duration(milliseconds: 500)); // Wait for render
                      final imageBytes = await BodyWidgetPdfHelper.captureWidgetAsImage(
                        _backFemaleBodyKey,
                      );
                      if (imageBytes != null) {
                        bodyWidgetDescriptions.add({
                          'type': 'back_female',
                          'title': 'Female Back View - Selected Injuries',
                          'selectedParts': selectedBackFemale.toList(),
                          'imageBytes': imageBytes,
                        });
                      }
                    }

                    // Restore original view
                    controller.toggleIsMale(originalIsMale);
                    controller.toggleIsFront(originalIsFront);

                    final Map<String, dynamic> mapData = {
                      "logoImage": logoBytes,
                      "incident_id": await generateSiteId(controller.siteController?.text??'site'),
                      "incidentDate": controller.occurredDateController?.text,
                      "name":
                          "${controller.firstNameController?.text} ${controller.lastNameController?.text}",
                      "studentId": "${controller.studentIDController?.text}",
                      "gender": "${controller.selectedSubjectGender}",
                      "dob": "${controller.dobController?.text}",
                      "unit": controller.isCelsius.value == true ? '°C':'°F',

                      "site": "${controller.siteController?.text}",
                      "location": "${controller.locationController?.text}",
                      "activity": "${controller.activityController?.text}",
                      "severity": controller.finalSeverity,
                      "mechanism": "${controller.mechanismController?.text}",
                      "injuryType": controller.finalInjuryType,
                      "illnessType": controller.finalIllnessType,

                      "bodyWidgetImages": bodyWidgetDescriptions,

                      "chiefComplaint":
                          "${controller.chiefComplaintController?.text}",
                      "notes": "${controller.notesController?.text}",

                      "treatments": treatmentsStrList.join(', '),
                      "vitals": vitalsList,

                      "bodyMap": bodyMapDescriptions,

                      "photos": photosList,

                      "signResponder": responderSig,
                      "signPatient": patientSig,
                      "signGuardian": guardianSig,

                      "disposition": controller.finalDisposition,
                    };

                    final pdfBytes = await generateNewIncidentReportPdf(
                      mapData,
                    );
                    final dir = await getApplicationDocumentsDirectory();
                    final fileName =
                        "incident_report_${DateTime.now().millisecondsSinceEpoch}.pdf";
                    final file = File("${dir.path}/$fileName");
                    await file.writeAsBytes(pdfBytes);
                    final reportMeta = {
                      "filePath": file.path,
                      "createdAt": DateTime.now().toIso8601String(),
                      "name": mapData["name"],
                      "incidentDate": mapData["incidentDate"],
                      "notes": mapData["notes"],
                      "mapData": mapData,
                    };

                    await saveReportMetadata(reportMeta);
                    EasyLoading.dismiss();
                    await Printing.layoutPdf(
                      name: fileName,
                      onLayout: (format) async => pdfBytes,
                    );
                    controller.resetAllData();
                    _responderKey.currentState?.clear();
                    _patientKey.currentState?.clear();
                    _guardianKey.currentState?.clear();
                    Get.offAll(MainScreen());
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveReportMetadata(Map<String, dynamic> reportMeta) async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList("reports") ?? [];
    reportsJson.add(jsonEncode(reportMeta));

    await prefs.setStringList("reports", reportsJson);
  }

  _buildSignatureWidget(GlobalKey<SfSignaturePadState>? key, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomBoldText(title: label, fontSize: 13, fontWeight: FontWeight.w400),
        SizedBox(height: 3),
        Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.darkGray, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                SfSignaturePad(
                  key: key,
                  backgroundColor: AppColors.lightestGray,
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: PlainButton(
                    outLined: true,
                    fontSize: 12,
                    backgroundColor: AppColors.lightGray,
                    horizontalPadding: 7,
                    height: 28,
                    text: 'Clear',
                    onTap: () {
                      key?.currentState!.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<String> generateSiteId(String site) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final year = now.year;
    final counterKey = 'site_counter_${site}_$year';
    int counter = prefs.getInt(counterKey) ?? 0;
    counter++;
    await prefs.setInt(counterKey, counter);
    final paddedNumber = counter.toString().padLeft(6, '0');
    return '$site-$year-$paddedNumber';
  }
}
