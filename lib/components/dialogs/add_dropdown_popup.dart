import 'package:ambulance_app/components/buttons/plain_button.dart';
import 'package:ambulance_app/components/text_fields/custom_text_field.dart';
import 'package:ambulance_app/components/text_widgets/custom_text.dart';
import 'package:ambulance_app/core/dropdown_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../viewmodels/main_controller.dart';

class AddDropDownValuePopup extends StatelessWidget {
  final String dropdownKey;
  final TextEditingController textController = TextEditingController();

  AddDropDownValuePopup({super.key, required this.dropdownKey});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomBoldText(
        fontSize: 19,
        title: 'Manage Dropdown ($dropdownKey)',
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              hintText: 'New Value',
              controller: textController,
            ),
            const SizedBox(height: 20),
            PlainButton(
              onTap: () async {
                if (textController.text.isNotEmpty) {
                  await DropdownManager.addValue(dropdownKey, textController.text);

                  final controller = Get.find<MainController>();
                  await controller.loadDropdownValues();

                  // close popup
                  Navigator.pop(context);

                  // show success
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Value added successfully!")),
                  );
                }
              },
              text: 'Save',
            ),
          ],
        ),
      ),
    );
  }
}
