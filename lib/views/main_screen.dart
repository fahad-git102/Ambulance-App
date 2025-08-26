import 'package:ambulance_app/components/buttons/plain_button.dart';
import 'package:ambulance_app/components/common_widgets/body_injury_widget.dart';
import 'package:ambulance_app/components/common_widgets/photo_widget.dart';
import 'package:ambulance_app/components/dialogs/body_map_dialog.dart';
import 'package:ambulance_app/components/dropdowns/custom_dropdown.dart';
import 'package:ambulance_app/components/text_fields/custom_text_field.dart';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/components/text_widgets/small_light_text.dart';
import 'package:ambulance_app/core/app_colors.dart';
import 'package:ambulance_app/core/app_contants.dart';
import 'package:ambulance_app/viewmodels/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interactable_svg/interactable_svg/interactable_svg.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../components/bottomsheets/image_picker_bottomsheet.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final DateTime initialDate = DateTime.now();
  final GlobalKey<SfSignaturePadState> _responderKey = GlobalKey();
  final GlobalKey<SfSignaturePadState> _patientKey = GlobalKey();
  final GlobalKey<SfSignaturePadState> _guardianKey = GlobalKey();

  final List<String> dispositionsList = [
    'Returned to class',
    'Sent home',
    'Released to guardian',
    'EMS activated',
    'Refused care',
  ];

  final List<String> immediateTreatments = [
    'Ice',
    'Wound Care',
    'Bandage',
    'Splint',
    'Inhaler',
    'Epi',
    'Cpr',
    'Other',
  ];

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
                        return CustomDropdown(
                          label: 'Type',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setSubjectType(val);
                            }
                          },
                          currentValue: controller.selectedSubjectType.value,
                          items: controller.subjectType,
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
                          controller.pickDate(
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
                        return CustomDropdown(
                          label: 'Severity',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setInjurySeverity(val);
                            }
                          },
                          currentValue: controller.selectedInjurySeverity.value,
                          items: controller.injurySeverity,
                        );
                      }),
                      const SizedBox(height: 7),
                      Obx(() {
                        return CustomDropdown(
                          label: 'Common Injury Type',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setCommonInjuryType(val);
                            }
                          },
                          currentValue:
                              controller.selectedCommonInjuryType.value,
                          items: controller.commonInjuryType,
                        );
                      }),
                      const SizedBox(height: 7),
                      Obx(() {
                        return CustomDropdown(
                          label: 'Common Illness Type',
                          onChanged: (val) {
                            if (val != null) {
                              controller.setCommonIllnessType(val);
                            }
                          },
                          currentValue:
                              controller.selectedCommonIllnessType.value,
                          items: controller.commonIllnessType,
                        );
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
                                            controller.pickDate(
                                              initialDate,
                                              controller.vitalsTimeController,
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
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          label: 'Temp °C',
                                          controller: vital.temp,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: CustomTextField(
                                          label: 'BGL mg/dL',
                                          controller: vital.bgl,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 9,
                          mainAxisSpacing: 9,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: immediateTreatments.length,
                        itemBuilder: (context, index) {
                          final item = immediateTreatments[index];

                          return Obx(() {
                            final isChecked = controller.isSelected(index);

                            return GestureDetector(
                              onTap: () => controller.toggleSelection(index),
                              child: Container(
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
                              ),
                            );
                          });
                        },
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
                                controller.toggleIsFront(true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.isFront.value
                                      ? AppColors.white
                                      : AppColors.lightestGray,
                                  border: Border.all(
                                    color: AppColors.lightGray,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SmallLightText(title: 'Front'),
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
                                      ? AppColors.white
                                      : AppColors.lightestGray,
                                  border: Border.all(
                                    color: AppColors.lightGray,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SmallLightText(title: 'Back'),
                              ),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 15),
                      InteractiveViewer(
                        scaleEnabled: true,
                        panEnabled: true,
                        constrained: true,
                        child: InteractableSvg(
                          svgAddress: "assets/body_front.svg",
                          onChanged: (region) {
                            Get.dialog(
                              BodyMapDialog(
                                title:
                                    "Add Injury — ${controller.isFront.value == true ? 'Front' : 'Back'} · ${region!.name}",
                                bodySide: controller.isFront.value == true
                                    ? 'Front'
                                    : 'Back',
                              ),
                            );
                          },
                          toggleEnable: true,
                          isMultiSelectable: false,
                          dotColor: Colors.black,
                          selectedColor: Colors.green.withAlpha(40),
                          strokeColor: Colors.blue,
                          unSelectableId: "bg",
                          centerDotEnable: true,
                          centerTextEnable: true,
                          strokeWidth: 2.0,
                          centerTextStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(() {
                        return controller.bodyInjuryList.isEmpty == true
                            ? Container()
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return BodyInjuryWidget(
                                    added: controller.bodyInjuryList[index].added,
                                    severity: controller.bodyInjuryList[index].severity,
                                    notes: controller.bodyInjuryList[index].notes,
                                    title:
                                        '${controller.bodyInjuryList[index].bodySide} -- ${controller.bodyInjuryList[index].injuryType}',
                                    onRemoveTap: (){
                                      controller.removeBodyInjuries(controller.bodyInjuryList[index].id);
                                    },
                                    onDuplicateTap: (){
                                      controller.addBodyInjuries(controller.bodyInjuryList[index]);
                                    },
                                  );
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
                      CustomDropdown(
                        label: 'Disposition',
                        onChanged: (val) {},
                        currentValue: dispositionsList[0],
                        items: dispositionsList,
                      ),
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
                  onTap: () {
                    print(controller.pickedPhotos.length);
                    print(controller.selectedImmediateTreatments.length);
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

  _buildSignatureWidget(Key? key, String label) {
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
            child: SfSignaturePad(
              key: key,
              backgroundColor: AppColors.lightestGray,
            ),
          ),
        ),
      ],
    );
  }
}
