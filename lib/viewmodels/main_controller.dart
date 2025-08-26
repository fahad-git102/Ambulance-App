import 'dart:io';

import 'package:ambulance_app/models/body_injury.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../core/base_helper.dart';
import '../models/image_model.dart';
import '../models/vitals_sets.dart';

class MainController extends GetxController {
  TextEditingController? dobController;
  TextEditingController? occurredDateController;
  TextEditingController? vitalsTimeController;
  RxBool guardianConsentOnFile = false.obs;
  var selectedImmediateTreatments = <int>[].obs;
  RxBool isFront = true.obs;
  RxBool guardianNotify = false.obs;
  RxBool adminNotify = false.obs;

  var pickedPhotos = <ImageModel>[].obs;
  final ImagePicker _picker = ImagePicker();
  bool isSelected(int index) => selectedImmediateTreatments.contains(index);

  TextEditingController? studentIDController, mechanismController, notesController;
  TextEditingController? firstNameController, activityController, chiefComplaintController;
  TextEditingController? lastNameController, siteController, locationController;

  final List<String> subjectType = ['Student', 'Staff', 'Visitor'];
  final List<String> subjectGender = ['Male', 'Female', 'Unspecified'];
  final List<String> injurySeverity = ['Minor', 'Moderate', 'Major'];
  RxList<BodyInjury> bodyInjuryList = <BodyInjury>[].obs;
  final List<String> commonInjuryType = [
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
  final List<String> commonIllnessType = [
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
  var selectedSubjectGender = ''.obs;
  var selectedSubjectType = "".obs;
  var selectedInjurySeverity = ''.obs;
  var selectedCommonInjuryType = ''.obs;
  var selectedCommonIllnessType = ''.obs;

  var vitalSets = <VitalSet>[].obs;

  @override
  void onInit() {
    dobController = TextEditingController();
    vitalsTimeController = TextEditingController();
    occurredDateController = TextEditingController();
    studentIDController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    siteController = TextEditingController();
    locationController = TextEditingController();
    activityController = TextEditingController();
    chiefComplaintController = TextEditingController();
    mechanismController = TextEditingController();
    notesController = TextEditingController();
    selectedSubjectType.value = subjectType[0];
    selectedSubjectGender.value = subjectGender[0];
    selectedInjurySeverity.value = injurySeverity[0];
    selectedCommonInjuryType.value = commonInjuryType[0];
    selectedCommonIllnessType.value = commonIllnessType[0];
    BaseHelper.requestPermissions();
    addVitalSet();
    super.onInit();
  }

  @override
  void dispose() {
    dobController?.dispose();
    vitalsTimeController?.dispose();
    occurredDateController?.dispose();
    studentIDController?.dispose();
    firstNameController?.dispose();
    lastNameController?.dispose();
    siteController?.dispose();
    locationController?.dispose();
    activityController?.dispose();
    chiefComplaintController?.dispose();
    mechanismController?.dispose();
    notesController?.dispose();
    super.dispose();
  }

  void setSubjectType(String value) {
    selectedSubjectType.value = value;
  }
  void setCommonInjuryType(String value) {
    selectedCommonInjuryType.value = value;
  }
  void setSubjectGender(String value) {
    selectedSubjectGender.value = value;
  }
  void setInjurySeverity(String value) {
    selectedInjurySeverity.value = value;
  }
  void setCommonIllnessType(String value) {
    selectedCommonIllnessType.value = value;
  }

  void addVitalSet() {
    vitalSets.add(VitalSet());
  }

  void removeVitalSet(int index) {
    if (vitalSets.length > 1) {
      vitalSets.removeAt(index);
    }
  }

  void addBodyInjuries(BodyInjury bodyInjury){
    bodyInjuryList.add(bodyInjury);
  }

  void removeBodyInjuries(String id){
    for(int i = 0; i<bodyInjuryList.length; i++){
      if(bodyInjuryList[i].id == id){
        bodyInjuryList.removeAt(i);
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedPhotos.add(
        ImageModel(
          file: File(pickedFile.path),
          pickedAt: DateTime.now(),
        ),
      );
      Get.back();
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      pickedPhotos.add(
        ImageModel(
          file: File(pickedFile.path),
          pickedAt: DateTime.now(),
        ),
      );
      Get.back();
    }
  }

  void updateCaption(int index, String caption) {
    pickedPhotos[index].caption = caption;
    pickedPhotos.refresh();
  }

  void removeImage(int index) {
    pickedPhotos.removeAt(index);
  }

  void toggleSelection(int index) {
    if (selectedImmediateTreatments.contains(index)) {
      selectedImmediateTreatments.remove(index);
    } else {
      selectedImmediateTreatments.add(index);
    }
  }

  void toggleGuardianConsentOnFile(){
    guardianConsentOnFile.value = !guardianConsentOnFile.value;
  }

  void toggleGuardianNotify(){
    guardianNotify.value = !guardianNotify.value;
  }

  void toggleAdminNotify(){
    adminNotify.value = !adminNotify.value;
  }

  void toggleIsFront(bool val){
    isFront.value = val;
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
}
