import 'dart:convert';
import 'dart:io';
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
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../components/bottomsheets/image_picker_bottomsheet.dart';
import '../components/common_widgets/back_body_male.dart';
import '../components/dialogs/edit_body_map_dialog.dart';
import '../core/body_pdf_helper.dart';
import '../models/body_injury.dart';
import '../models/image_model.dart';
import '../models/vitals_sets.dart';

class EditPastReportScreen extends StatefulWidget {
  final Map<String, dynamic> reportData;
  final int reportIndex;

  const EditPastReportScreen({
    super.key,
    required this.reportData,
    required this.reportIndex,
  });

  @override
  State<EditPastReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditPastReportScreen> {
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

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        final controller = Get.find<MainController>();
        _initializeControllerData(controller);
        _initialized = true;
      }
    });
  }

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
              title: 'Edit Report',
              textColor: AppColors.textBlack,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
        centerTitle: true,
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
                            controller.subjectType
                                .toList()
                                .isNotEmpty) {
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
                            controller.injurySeverity
                                .toList()
                                .isNotEmpty) {
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
                            controller.commonInjuryType
                                .toList()
                                .isNotEmpty) {
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
                            controller.commonIllnessType
                                .toList()
                                .isNotEmpty) {
                          controller.selectedCommonIllnessType.value =
                              controller.commonIllnessType
                                  .toList()
                                  .first;
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
                          children: List.generate(
                              controller.vitalSets.length, (index,) {
                            final vital = controller.vitalSets[index];
                            print(vital.time.text);
                            print(vital.bgl.text);
                            print(vital.temp.text);
                            print(vital.spo2.text);
                            print(vital.bpDia.text);
                            print(vital.bpSys.text);
                            print(vital.gcs.text);
                            print(vital.hr.text);
                            print(vital.rr.text);
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
                      CustomBoldText(title: 'Body Map', fontSize: 19),
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
                        return controller.isMale.value == true
                            ? controller.isFront.value == true
                            ? RepaintBoundary(
                          key: _frontMaleBodyKey,
                          child: FrontBodyMale(
                            selectedBodyParts:
                            selectedFrontMaleBodyParts,
                            onBodyPartSelected: (part) {
                              Get.dialog(
                                BodyMapDialog(
                                  gender: 'Male',
                                  title:
                                  "Add Injury — Front · $part",
                                  bodySide: 'Front',
                                  region: part,
                                ),
                              );
                            },
                            onSelectedPartsChanged:
                                (selectedParts) {
                              selectedFrontMaleBodyParts =
                                  selectedParts;
                            },
                          ),
                        )
                            : RepaintBoundary(
                          key: _backMaleBodyKey,
                          child: BackBodyMale(
                            selectedBodyParts:
                            selectedBackMaleBodyParts,
                            onBodyPartSelected: (part) {
                              Get.dialog(
                                BodyMapDialog(
                                  gender: 'Male',
                                  title:
                                  "Add Injury — Back · $part",
                                  bodySide: 'Back',
                                  region: part,
                                ),
                              );
                            },
                            onSelectedPartsChanged:
                                (selectedParts) {
                              selectedBackMaleBodyParts =
                                  selectedParts;
                            },
                          ),
                        )
                            : controller.isFront.value == true
                            ? RepaintBoundary(
                          key: _frontFemaleBodyKey,
                          child: FrontBodyFemale(
                            selectedBodyParts:
                            selectedFrontFemaleBodyParts,
                            onBodyPartSelected: (part) {
                              Get.dialog(
                                BodyMapDialog(
                                  gender: 'Female',
                                  title: "Add Injury — Front · $part",
                                  bodySide: 'Front',
                                  region: part,
                                ),
                              );
                            },
                            onSelectedPartsChanged: (selectedParts) {
                              selectedFrontFemaleBodyParts =
                                  selectedParts;
                            },
                          ),
                        )
                            : RepaintBoundary(
                          key: _backFemaleBodyKey,
                          child: BackBodyFemale(
                            selectedBodyParts:
                            selectedBackFemaleBodyParts,
                            onBodyPartSelected: (part) {
                              Get.dialog(
                                BodyMapDialog(
                                  gender: 'Female',
                                  title: "Add Injury — Back · $part",
                                  bodySide: 'Back',
                                  region: part,
                                ),
                              );
                            },
                            onSelectedPartsChanged: (selectedParts) {
                              selectedBackFemaleBodyParts = selectedParts;
                            },
                          ),
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
                                '${controller.bodyInjuryList[index]
                                    .bodySide} -- ${controller
                                    .bodyInjuryList[index].region}',
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
                                      "Edit Injury — ${controller
                                          .bodyInjuryList[index]
                                          .bodySide} · ${controller
                                          .bodyInjuryList[index].region}",
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
                // Container(
                //   padding: const EdgeInsets.all(14),
                //   decoration: BoxDecoration(
                //     color: AppColors.white,
                //     borderRadius: BorderRadius.circular(8),
                //     boxShadow: appBoxShadow,
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       CustomBoldText(title: 'Signatures', fontSize: 19),
                //       SizedBox(height: 10),
                //       _buildSignatureWidget(_responderKey, 'Responder'),
                //       SizedBox(height: 14),
                //       _buildSignatureWidget(_patientKey, 'Patient'),
                //       SizedBox(height: 14),
                //       _buildSignatureWidget(_guardianKey, 'Guardian'),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 10),
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
                            controller.dispositionsList
                                .toList()
                                .isNotEmpty) {
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
                  text: 'Update Report',
                  onTap: () async {
                    await _updateReport(controller, context);
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

  void _initializeControllerData(MainController controller) {
    final mapData = widget.reportData["mapData"] as Map<String, dynamic>? ?? {};

    // Parse and set name fields
    String fullName = mapData["name"] ?? "";
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts.isNotEmpty ? nameParts.first : "";
    String lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(" ")
        : "";

    // Initialize text controllers
    controller.studentIDController?.text = mapData["studentId"] ?? "";
    controller.firstNameController?.text = firstName;
    controller.isCelsius.value = mapData['unit']!=null?mapData['unit'] == '°C' ? true : false:false;
    controller.lastNameController?.text = lastName;
    controller.dobController?.text = mapData["dob"] ?? "";
    controller.occurredDateController?.text = mapData["incidentDate"] ?? "";
    controller.siteController?.text = mapData["site"] ?? "";
    controller.locationController?.text = mapData["location"] ?? "";
    controller.activityController?.text = mapData["activity"] ?? "";
    controller.chiefComplaintController?.text = mapData["chiefComplaint"] ?? "";
    controller.mechanismController?.text = mapData["mechanism"] ?? "";
    controller.notesController?.text = mapData["notes"] ?? "";

    // Initialize dropdown selections
    String gender = mapData["gender"] ?? "";
    if (controller.subjectGender.contains(gender)) {
      controller.selectedSubjectGender.value = gender;
    }

    String severity = mapData["severity"] ?? "";
    if (controller.injurySeverity.contains(severity)) {
      controller.selectedInjurySeverity.value = severity;
    } else if (severity.isNotEmpty) {
      controller.selectedInjurySeverity.value = "Other";
      controller.otherSeverityText.value = severity;
    }

    String injuryType = mapData["injuryType"] ?? "";
    if (controller.commonInjuryType.contains(injuryType)) {
      controller.selectedCommonInjuryType.value = injuryType;
    } else if (injuryType.isNotEmpty) {
      controller.selectedCommonInjuryType.value = "Other";
      controller.otherInjuryText.value = injuryType;
    }

    String illnessType = mapData["illnessType"] ?? "";
    if (controller.commonIllnessType.contains(illnessType)) {
      controller.selectedCommonIllnessType.value = illnessType;
    } else if (illnessType.isNotEmpty) {
      controller.selectedCommonIllnessType.value = "Other";
      controller.otherIllnessText.value = illnessType;
    }

    String disposition = mapData["disposition"] ?? "";
    if (controller.dispositionsList.contains(disposition)) {
      controller.selectedDisposition.value = disposition;
    } else if (disposition.isNotEmpty) {
      controller.selectedDisposition.value = "Other";
      controller.otherDispositionText.value = disposition;
    }

    // Initialize treatments
    String treatments = mapData["treatments"] ?? "";
    List<String> treatmentsList = treatments.split(", ").where((t) =>
    t.isNotEmpty).toList();
    controller.selectedImmediateTreatments.clear();

    for (String treatment in treatmentsList) {
      int index = controller.immediateTreatments.indexOf(treatment);
      if (index != -1) {
        controller.selectedImmediateTreatments.add(index);
      } else {
        // Handle "Other" treatments
        int otherIndex = controller.immediateTreatments.indexOf("Other");
        if (otherIndex != -1 &&
            !controller.selectedImmediateTreatments.contains(otherIndex)) {
          controller.selectedImmediateTreatments.add(otherIndex);
          controller.otherTreatmentText.value = treatment;
        }
      }
    }

    // Initialize vitals
    List<dynamic> vitals = mapData["vitals"] ?? [];
    controller.vitalSets.clear();

    if (vitals.isEmpty) {
      controller.addVitalSet();
    } else {
      for (var vital in vitals) {
        VitalSet vitalSet = VitalSet();
        vitalSet.time.text = vital["time"] ?? "";
        vitalSet.hr.text = vital["hr"] ?? "";
        vitalSet.rr.text = vital["rr"] ?? "";
        vitalSet.bpSys.text = vital["bp_systolic"] ?? "";
        vitalSet.bpDia.text = vital["bp_diastolic"] ?? "";
        vitalSet.spo2.text = vital["spo2"] ?? "";
        vitalSet.temp.text = vital["temp_c"] ?? "";
        vitalSet.bgl.text = vital["bgl_mgdl"] ?? "";
        vitalSet.gcs.text = vital["gcs"] ?? "";
        controller.vitalSets.add(vitalSet);
      }
    }

    // Initialize body injuries
    List<dynamic> bodyMap = mapData["bodyMap"] ?? [];
    controller.bodyInjuryList.clear();

    for (var injury in bodyMap) {
      BodyInjury bodyInjury = BodyInjury(
        id: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        bodySide: injury["bodySide"] ?? "",
        region: injury["region"] ?? "",
        gender: injury["gender"] ?? "",
        injuryType: injury["injuryType"] ?? "",
        severity: injury["severity"] ?? "",
        notes: injury["notes"] ?? "",
        added: injury["added"] ?? "",
      );
      controller.bodyInjuryList.add(bodyInjury);
    }

    // Initialize photos
    List<dynamic> photos = mapData["photos"] ?? [];
    controller.pickedPhotos.clear();

    for (var photo in photos) {
      if (photo["file"] != null) {
        try {
          // Create temporary file from bytes
          List<int> imageBytes = List<int>.from(photo["file"]);
          String tempPath = "${Directory.systemTemp.path}/${DateTime
              .now()
              .millisecondsSinceEpoch}.jpg";
          File tempFile = File(tempPath);
          tempFile.writeAsBytesSync(imageBytes);

          ImageModel imageModel = ImageModel(
            file: tempFile,
            pickedAt: DateTime.parse(photo["pickedAt"]),
            caption: photo["caption"] ?? "",
          );
          controller.pickedPhotos.add(imageModel);
        } catch (e) {
          print("Error loading image: $e");
        }
      }
    }

    // Initialize body part selections based on body injuries
    selectedFrontMaleBodyParts.clear();
    selectedBackMaleBodyParts.clear();
    selectedFrontFemaleBodyParts.clear();
    selectedBackFemaleBodyParts.clear();

    for (var injury in controller.bodyInjuryList) {
      String region = injury.region ?? "";
      String bodySide = injury.bodySide ?? "";
      String gender = injury.gender ?? "";

      if (gender.toLowerCase() == "male") {
        if (bodySide.toLowerCase() == "front") {
          selectedFrontMaleBodyParts.add(region);
        } else {
          selectedBackMaleBodyParts.add(region);
        }
      } else {
        if (bodySide.toLowerCase() == "front") {
          selectedFrontFemaleBodyParts.add(region);
        } else {
          selectedBackFemaleBodyParts.add(region);
        }
      }
    }
  }

  Future<void> _updateReport(MainController controller,
      BuildContext context) async {
    EasyLoading.show();

    // try {
    //
    // } catch (e) {
    //   EasyLoading.dismiss();
    //   Get.snackbar('Error', 'Failed to update report: $e');
    //   print("Error updating report: $e");
    // }
    // final responderSig = await BaseHelper().getSignatureBytes(_responderKey);
    // final patientSig = await BaseHelper().getSignatureBytes(_patientKey);
    // final guardianSig = await BaseHelper().getSignatureBytes(_guardianKey);

    // Prepare vitals data
    final vitalsList = controller.vitalSets.map((v) => v.toMap()).toList();

    // Prepare body map descriptions
    final bodyMapDescriptions = controller.bodyInjuryList.map((injury) {
      return {
        "bodySide": injury.bodySide ?? '',
        "region": injury.region ?? '',
        "gender": injury.gender ?? '',
        "injuryType": injury.injuryType ?? '',
        "severity": injury.severity ?? '',
        "notes": injury.notes ?? '',
      };
    }).toList();

    // Prepare photos data
    final photosList = await Future.wait(
      controller.pickedPhotos.map(
            (img) async =>
        {
          "pickedAt": img.pickedAt.toIso8601String(),
          "file": await img.file.readAsBytes(),
          "caption": img.caption ?? "",
        },
      ),
    );

    // Get logo bytes
    Uint8List? logoBytes;
    if (controller.logoImage.value != null &&
        await controller.logoImage.value!.exists()) {
      try {
        logoBytes = await controller.logoImage.value!.readAsBytes();
      } catch (e) {
        logoBytes = null;
      }
    }

    // Prepare treatments list
    List<String> treatmentsStrList = [];
    for (int i = 0; i < controller.selectedImmediateTreatments.length; i++) {
      String treatment = controller.immediateTreatments.toList()[controller
          .selectedImmediateTreatments[i]];
      if (treatment == "Other" &&
          controller.otherTreatmentText.value.isNotEmpty) {
        treatmentsStrList.add(controller.otherTreatmentText.value);
      } else {
        treatmentsStrList.add(treatment);
      }
    }

    // Prepare body widget descriptions
    final List<Map<String, dynamic>> bodyWidgetDescriptions = [];

    if (selectedFrontMaleBodyParts.isNotEmpty) {
      final imageBytes = await BodyWidgetPdfHelper.captureWidgetAsImage(
          _frontMaleBodyKey);
      if (imageBytes != null) {
        bodyWidgetDescriptions.add({
          'type': 'front_male',
          'title': 'Male Front View - Selected Injuries',
          'selectedParts': selectedFrontMaleBodyParts.toList(),
          'imageBytes': imageBytes,
        });
      }
    }

    if (selectedBackMaleBodyParts.isNotEmpty) {
      final imageBytes = await BodyWidgetPdfHelper.captureWidgetAsImage(
          _backMaleBodyKey);
      if (imageBytes != null) {
        bodyWidgetDescriptions.add({
          'type': 'back_male',
          'title': 'Male Back View - Selected Injuries',
          'selectedParts': selectedBackMaleBodyParts.toList(),
          'imageBytes': imageBytes,
        });
      }
    }

    if (selectedFrontFemaleBodyParts.isNotEmpty) {
      final imageBytes = await BodyWidgetPdfHelper.captureWidgetAsImage(
          _frontFemaleBodyKey);
      if (imageBytes != null) {
        bodyWidgetDescriptions.add({
          'type': 'front_female',
          'title': 'Female Front View - Selected Injuries',
          'selectedParts': selectedFrontFemaleBodyParts.toList(),
          'imageBytes': imageBytes,
        });
      }
    }

    if (selectedBackFemaleBodyParts.isNotEmpty) {
      final imageBytes = await BodyWidgetPdfHelper.captureWidgetAsImage(
          _backFemaleBodyKey);
      if (imageBytes != null) {
        bodyWidgetDescriptions.add({
          'type': 'back_female',
          'title': 'Female Back View - Selected Injuries',
          'selectedParts': selectedBackFemaleBodyParts.toList(),
          'imageBytes': imageBytes,
        });
      }
    }

    final Map<String, dynamic> updatedMapData = {
      "logoImage": logoBytes,
      "incidentDate": controller.occurredDateController?.text ?? "",
      "name": "${controller.firstNameController?.text ?? ""} ${controller
          .lastNameController?.text ?? ""}".trim(),
      "studentId": controller.studentIDController?.text ?? "",
      "gender": controller.selectedSubjectGender.value,
      "dob": controller.dobController?.text ?? "",
      "unit": controller.isCelsius.value == true ? '°C':'°F',
      "site": controller.siteController?.text ?? "",
      "location": controller.locationController?.text ?? "",
      "activity": controller.activityController?.text ?? "",
      "severity": controller.finalSeverity,
      "mechanism": controller.mechanismController?.text ?? "",
      "injuryType": controller.finalInjuryType,
      "illnessType": controller.finalIllnessType,
      "bodyWidgetImages": bodyWidgetDescriptions,
      "chiefComplaint": controller.chiefComplaintController?.text ?? "",
      "notes": controller.notesController?.text ?? "",
      "treatments": treatmentsStrList.join(', '),
      "vitals": vitalsList,
      "bodyMap": bodyMapDescriptions,
      "photos": photosList,
      // "signResponder": responderSig,
      // "signPatient": patientSig,
      // "signGuardian": guardianSig,
      "disposition": controller.finalDisposition,
    };

    // Generate updated PDF
    final pdfBytes = await generateNewIncidentReportPdf(updatedMapData);

    // Update the existing file or create new one
    File pdfFile;
    if (widget.reportData["filePath"] != null &&
        File(widget.reportData["filePath"]).existsSync()) {
      pdfFile = File(widget.reportData["filePath"]);
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = "incident_report_${DateTime
          .now()
          .millisecondsSinceEpoch}.pdf";
      pdfFile = File("${dir.path}/$fileName");
    }

    await pdfFile.writeAsBytes(pdfBytes);

    // Update report metadata
    final updatedReportMeta = {
      "filePath": pdfFile.path,
      "createdAt": widget.reportData["createdAt"] ??
          DateTime.now().toIso8601String(),
      "updatedAt": DateTime.now().toIso8601String(),
      "name": updatedMapData["name"],
      "incidentDate": updatedMapData["incidentDate"],
      "notes": updatedMapData["notes"],
      "mapData": updatedMapData,
    };

    await _updateReportInStorage(updatedReportMeta, widget.reportIndex);

    EasyLoading.dismiss();

    // Show PDF preview
    await Printing.layoutPdf(
      name: "updated_incident_report.pdf",
      onLayout: (format) async => pdfBytes,
    );

    // Navigate back
    Get.snackbar('Success', 'Report updated successfully');
    Get.back();
  }

  Future<void> _updateReportInStorage(Map<String, dynamic> updatedReportMeta,
      int index) async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList("reports") ?? [];

    if (index >= 0 && index < reportsJson.length) {
      reportsJson[index] = jsonEncode(updatedReportMeta);
      await prefs.setStringList("reports", reportsJson);
    }
  }

  // Widget _buildSignatureWidget(GlobalKey<SfSignaturePadState>? key,
  //     String label) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomBoldText(title: label, fontSize: 13, fontWeight: FontWeight.w400),
  //       SizedBox(height: 3),
  //       Container(
  //         height: 170,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(color: AppColors.darkGray, width: 1),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: Stack(
  //             children: [
  //               SfSignaturePad(
  //                 key: key,
  //                 backgroundColor: AppColors.lightestGray,
  //               ),
  //               Positioned(
  //                 bottom: 10,
  //                 right: 10,
  //                 child: PlainButton(
  //                   outLined: true,
  //                   fontSize: 12,
  //                   backgroundColor: AppColors.lightGray,
  //                   horizontalPadding: 7,
  //                   height: 28,
  //                   text: 'Clear',
  //                   onTap: () {
  //                     key?.currentState!.clear();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}