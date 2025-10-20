import 'package:ambulance_app/components/buttons/plain_button.dart';
import 'package:ambulance_app/components/text_fields/custom_text_field.dart';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/core/app_colors.dart';
import 'package:ambulance_app/models/body_injury.dart';
import 'package:ambulance_app/viewmodels/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dropdowns/custom_dropdown.dart';

class BodyMapDialog extends StatefulWidget {
  final String? title, bodySide, injuryId, region, gender;
  final VoidCallback? onCancel;

  const BodyMapDialog({super.key, this.title, this.bodySide, this.injuryId, this.region, this.gender, this.onCancel});

  @override
  State<StatefulWidget> createState() => _BodyMapState();
}

class _BodyMapState extends State<BodyMapDialog> {
  TextEditingController? injuryTypeController, notesController;
  String? selectedInjurySeverity;
  final List<String> injurySeverity = ['Minor', 'Moderate', 'Major'];
  late MainController controller;

  @override
  void initState() {
    injuryTypeController = TextEditingController();
    notesController = TextEditingController();
    selectedInjurySeverity = 'Minor';
    controller = Get.find<MainController>();
    super.initState();
  }

  void _handleCancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Get.back();
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
                    onPressed: _handleCancel,
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
                textInputAction: TextInputAction.newline,
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
                    onTap: _handleCancel,
                  ),
                  SizedBox(width: 7),
                  PlainButton(
                    height: 40,
                    text: 'Save',
                    onTap: () {
                      final bodyInjury = BodyInjury()
                        ..injuryType = injuryTypeController?.text
                        ..notes = notesController?.text
                        ..bodySide = widget.bodySide
                        ..gender = widget.gender
                        ..added = DateTime.now().toUtc().toIso8601String()
                        ..region = widget.region
                        ..severity = selectedInjurySeverity;
                      controller.addBodyInjuries(bodyInjury);
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
