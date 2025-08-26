import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  Future<XFile?> pickFromCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return await _picker.pickImage(source: ImageSource.camera);
    } else {
      Get.snackbar("Permission Denied", "Camera permission is required.");
      return null;
    }
  }
  Future<XFile?> pickFromGallery() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      return await _picker.pickImage(source: ImageSource.gallery);
    } else {
      Get.snackbar("Permission Denied", "Gallery access is required.");
      return null;
    }
  }
}
