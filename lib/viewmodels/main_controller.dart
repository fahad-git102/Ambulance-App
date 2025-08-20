import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../core/base_helper.dart';

class MainController extends GetxController {
  TextEditingController? dobController;
  TextEditingController? occurredDateController;
  TextEditingController? vitalsTimeController;

  // final items = List.generate(12, (index) => "Item ${index + 1}");

  var selectedItems = <int>[].obs;

  void toggleSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
  }

  bool isSelected(int index) => selectedItems.contains(index);

  @override
  void onInit() {
    dobController = TextEditingController();
    vitalsTimeController = TextEditingController();
    occurredDateController = TextEditingController();
    super.onInit();
  }

  pickDate(DateTime initialDate, TextEditingController? controller) async {
    try {
      final date = await BaseHelper.datePicker(Get.context, initialDate: initialDate);
      if (date == null) return;
      controller?.text = DateFormat('MMM dd, yyyy').format(date);
      print("DOB picked: ${controller?.text}");
    } catch (e) {
      print("Error picking date: $e");
    }
  }

  @override
  void dispose() {
    dobController?.dispose();
    vitalsTimeController?.dispose();
    occurredDateController?.dispose();
    super.dispose();
  }
}
