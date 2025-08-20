import 'package:ambulance_app/viewmodels/main_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(MainController());
  }

}