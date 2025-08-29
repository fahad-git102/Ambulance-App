import 'package:ambulance_app/components/buttons/plain_button.dart';
import 'package:ambulance_app/components/text_fields/custom_text_field.dart';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/core/app_colors.dart';
import 'package:ambulance_app/models/body_injury.dart';
import 'package:ambulance_app/viewmodels/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dropdowns/custom_dropdown.dart';

class EditBodyMapDialog extends StatefulWidget {
  final String? title, bodySide, injuryId, region, injuryType, severity, notes;

  const EditBodyMapDialog({super.key, this.title, this.bodySide, this.injuryId, this.region, this.injuryType, this.severity, this.notes});

  @override
  State<StatefulWidget> createState() => _BodyMapState();
}

class _BodyMapState extends State<EditBodyMapDialog> {
  TextEditingController? injuryTypeController, notesController;
  String? selectedInjurySeverity;
  final List<String> injurySeverity = ['Minor', 'Moderate', 'Major'];
  late MainController controller;

  @override
  void initState() {
    injuryTypeController = TextEditingController(text: widget.injuryType);
    notesController = TextEditingController(text: widget.notes);
    selectedInjurySeverity = widget.severity;
    controller = Get.find<MainController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomBoldText(
                      title: widget.title,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: injuryTypeController,
                label: 'Injury type',
                hintText: 'e.g., Laceration, Sprain, Contusion',
              ),
              SizedBox(height: 10),
              CustomDropdown(
                label: 'Severity',
                onChanged: (val) {
                  if (val != null) {
                    setInjurySeverity(val);
                  }
                },
                currentValue: selectedInjurySeverity,
                items: injurySeverity,
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: notesController,
                label: 'Notes',
                maxLines: 3,
              ),
              SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PlainButton(
                    outLined: true,
                    height: 40,
                    backgroundColor: AppColors.lightGray,
                    text: 'Cancel',
                    onTap: () {
                      Get.back();
                    },
                  ),
                  SizedBox(width: 7),
                  PlainButton(
                    height: 40,
                    text: 'Save',
                    onTap: () {
                      controller.editBodyInjury(widget.injuryId, injuryTypeController?.text, selectedInjurySeverity, notesController?.text);
                      Get.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setInjurySeverity(String value) {
    setState(() {
      selectedInjurySeverity = value;
    });
  }
}
