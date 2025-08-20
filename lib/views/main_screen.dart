import 'package:ambulance_app/components/buttons/plain_button.dart';
import 'package:ambulance_app/components/dropdowns/custom_dropdown.dart';
import 'package:ambulance_app/components/text_fields/custom_text_field.dart';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/components/text_widgets/small_light_text.dart';
import 'package:ambulance_app/core/app_colors.dart';
import 'package:ambulance_app/core/app_contants.dart';
import 'package:ambulance_app/viewmodels/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  DateTime initialDate = DateTime.now();
  List<String> subjectType = ['Student', 'Staff', 'Visitor'];
  List<String> subjectGender = ['Male', 'Female', 'Unspecified'];
  List<String> injurySeverity = ['Minor', 'Moderate', 'Major'];
  List<String> commonInjuryType = [
    'Sprain/Strain',
    'Contusion/Bruise',
    'Laceration',
    'Abrasion',
    'Avulsion',
    'Fracture (suspected)',
    'Dislocation (suspected)',
    'Concussion (suspected)',
    'Dental Injury',
    'Burn',
    'Other',
  ];
  List<String> commonIllnessType = [
    'Asthma',
    'Anaphylaxis/Allergic Rxn',
    'Seizure',
    'Heat Illness/Exhaustion',
    'Dehydration',
    'Hypoglycemia/Hyperglycemia',
    'GI Illness/Nausea',
    'Syncope/Lightheaded',
    'Fever',
    'Other',
  ];
  List<String> immediateTreatments = [
    'Ice', 'Wound Care', 'Bandage', 'Splint', 'Inhaler', 'Epi', 'Cpr', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: CustomBoldText(
          title: 'Ambulance',
          fontSize: 25,
          textColor: AppColors.white,
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
                      CustomDropdown(
                        label: 'Type',
                        onChanged: (val) {},
                        currentValue: subjectType[0],
                        items: subjectType,
                      ),
                      const SizedBox(height: 7),
                      CustomDropdown(
                        label: 'Gender',
                        onChanged: (val) {},
                        currentValue: subjectGender[0],
                        items: subjectGender,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(label: 'Student ID *'),
                      const SizedBox(height: 7),
                      CustomTextField(label: 'First Name *'),
                      const SizedBox(height: 7),
                      CustomTextField(label: 'Last Name *'),
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
                      CustomTextField(label: 'Site'),
                      const SizedBox(height: 7),
                      CustomTextField(label: 'Location *'),
                      const SizedBox(height: 7),
                      CustomTextField(label: 'Activity'),
                      const SizedBox(height: 7),
                      CustomDropdown(
                        label: 'Severity',
                        onChanged: (val) {},
                        currentValue: injurySeverity[0],
                        items: injurySeverity,
                      ),
                      const SizedBox(height: 7),
                      CustomDropdown(
                        label: 'Common Injury Type',
                        onChanged: (val) {},
                        currentValue: commonInjuryType[0],
                        items: commonInjuryType,
                      ),
                      const SizedBox(height: 7),
                      CustomDropdown(
                        label: 'Common Illness Type',
                        onChanged: (val) {},
                        currentValue: commonIllnessType[0],
                        items: commonIllnessType,
                      ),
                      const SizedBox(height: 7),
                      CustomTextField(label: 'Chief Complaint *'),
                      const SizedBox(height: 7),
                      CustomTextField(label: 'Mechanism / Illness'),
                      const SizedBox(height: 7),
                      CustomTextField(label: 'Notes', maxLines: 4),
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
                            onTap: () {},
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
                      Container(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomTextField(
                                    label: 'Time',
                                    readOnly: true,
                                    controller: controller.vitalsTimeController,
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
                                  child: CustomTextField(label: 'HR'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: CustomTextField(label: 'RR')),
                                SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextField(label: 'BP Sys'),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CustomTextField(label: 'BP Dia'),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextField(label: 'SpO₂ %'),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CustomTextField(label: 'Temp °C'),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextField(label: 'BGL mg/dL'),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
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
                            CustomBoldText(title: 'Immediate Treatments', fontSize: 19),
                            SizedBox(height: 18,),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 9,
                                mainAxisSpacing: 9,
                                childAspectRatio: 2.5
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
                                        color: isChecked ? Colors.green.withAlpha(30) : Colors.white,
                                        border: Border.all(
                                          color: isChecked ? Colors.green : AppColors.lightGray,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: isChecked,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            onChanged: (_) => controller.toggleSelection(index),
                                          ),
                                          SmallLightText(
                                            title: item,
                                          )
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
