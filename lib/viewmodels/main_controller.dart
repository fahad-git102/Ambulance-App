import 'dart:io';

import 'package:ambulance_app/models/body_injury.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/base_helper.dart';
import '../core/dropdown_manager.dart';
import '../models/image_model.dart';
import '../models/vitals_sets.dart';

class MainController extends GetxController {
  TextEditingController? dobController;
  TextEditingController? occurredDateController;
  TextEditingController? vitalsTimeController;
  RxBool guardianConsentOnFile = false.obs;
  var selectedImmediateTreatments = <int>[].obs;
  RxBool isFront = true.obs;
  RxBool isMale = true.obs;
  RxBool guardianNotify = false.obs;
  RxBool adminNotify = false.obs;

  var pickedPhotos = <ImageModel>[].obs;
  final ImagePicker _picker = ImagePicker();
  bool isSelected(int index) => selectedImmediateTreatments.contains(index);

  TextEditingController? studentIDController, mechanismController, notesController;
  TextEditingController? firstNameController, activityController, chiefComplaintController;
  TextEditingController? lastNameController, siteController, locationController;

  final List<String> subjectGender = ['Male', 'Female', 'Unspecified'];
  RxList<BodyInjury> bodyInjuryList = <BodyInjury>[].obs;

  var subjectType = <String>[].obs;
  var injurySeverity = <String>[].obs;
  var commonInjuryType = <String>[].obs;
  var dispositionsList = <String>[].obs;
  var commonIllnessType = <String>[].obs;
  var immediateTreatments = <String>[].obs;


  final List<String> defaultSubjectType = ['Student', 'Staff', 'Visitor'];
  final List<String> defaultSubjectGender = ['Male', 'Female', 'Unspecified'];
  final List<String> defaultInjurySeverity = ['Minor', 'Moderate', 'Major', 'Other'];
  final List<String> defaultCommonInjuryType = [
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
  final List<String> defaultDispositionsList = [
    'Returned to class',
    'Sent home',
    'Released to guardian',
    'EMS activated',
    'Refused care',
    'Other',
  ];
  final List<String> defaultCommonIllnessType = [
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

  final List<String> defaultImmediateTreatments = [
    'Ice',
    'Wound Care',
    'Bandage',
    'Splint',
    'Inhaler',
    'Epi',
    'Cpr',
    'Other',
  ];

  var selectedSubjectGender = ''.obs;
  var selectedDisposition = ''.obs;
  var selectedSubjectType = "".obs;
  var selectedInjurySeverity = ''.obs;
  var selectedCommonInjuryType = ''.obs;
  var selectedCommonIllnessType = ''.obs;

  var vitalSets = <VitalSet>[].obs;

  final RxString otherIllnessText = ''.obs;
  final RxString otherInjuryText = ''.obs;
  final RxString otherSeverityText = ''.obs;
  final RxString otherDispositionText = ''.obs;
  final RxString otherTreatmentText = ''.obs;

  Rx<File?> logoImage = Rx<File?>(null);

  Future<void> saveLogoImage(File imageFile) async {
    logoImage.value = imageFile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logo_image_path', imageFile.path);
  }

  Future<void> loadLogoImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('logo_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      logoImage.value = File(imagePath);
    }
  }

  Future<void> removeLogoImage() async {
    logoImage.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logo_image_path');
  }

  String get finalIllnessType {
    return selectedCommonIllnessType.value == "Other" && otherIllnessText.value.isNotEmpty
        ? otherIllnessText.value
        : selectedCommonIllnessType.value;
  }

  String get finalInjuryType {
    return selectedCommonInjuryType.value == "Other" && otherInjuryText.value.isNotEmpty
        ? otherInjuryText.value
        : selectedCommonInjuryType.value;
  }

  String get finalSeverity {
    return selectedInjurySeverity.value == "Other" && otherSeverityText.value.isNotEmpty
        ? otherSeverityText.value
        : selectedInjurySeverity.value;
  }

  String get finalDisposition {
    return selectedDisposition.value == "Other" && otherDispositionText.value.isNotEmpty
        ? otherDispositionText.value
        : selectedDisposition.value;
  }

  @override
  void onInit() {
    _initDropdowns();
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
    selectedSubjectGender.value = subjectGender[0];
    BaseHelper.requestPermissions();
    addVitalSet();
    super.onInit();
  }

  void resetAllData() {
    studentIDController?.clear();
    firstNameController?.clear();
    lastNameController?.clear();
    dobController?.clear();
    occurredDateController?.clear();
    siteController?.clear();
    locationController?.clear();
    activityController?.clear();
    chiefComplaintController?.clear();
    mechanismController?.clear();
    notesController?.clear();

    selectedSubjectType.value = subjectType.isNotEmpty ? subjectType.first : '';
    selectedSubjectGender.value = subjectGender.isNotEmpty ? subjectGender.first : '';
    selectedInjurySeverity.value = injurySeverity.isNotEmpty ? injurySeverity.first : '';
    selectedCommonInjuryType.value = commonInjuryType.isNotEmpty ? commonInjuryType.first : '';
    selectedCommonIllnessType.value = commonIllnessType.isNotEmpty ? commonIllnessType.first : '';
    selectedDisposition.value = dispositionsList.isNotEmpty ? dispositionsList.first : '';

    vitalSets.clear();
    bodyInjuryList.clear();
    pickedPhotos.clear();
    selectedImmediateTreatments.clear();

    guardianConsentOnFile.value = false;
    guardianNotify.value = false;
    adminNotify.value = false;
    isFront.value = true;
    isMale.value = true;

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

  Future<void> _initDropdowns() async {
    await loadDropdownValues();

    selectedSubjectType.value = subjectType.isNotEmpty ? subjectType[0] : '';
    selectedSubjectGender.value = subjectGender[0];
    selectedInjurySeverity.value = injurySeverity.isNotEmpty ? injurySeverity[0] : '';
    selectedCommonInjuryType.value = commonInjuryType.isNotEmpty ? commonInjuryType[0] : '';
    selectedCommonIllnessType.value = commonIllnessType.isNotEmpty ? commonIllnessType[0] : '';
    selectedDisposition.value = dispositionsList.isNotEmpty ? dispositionsList[0] : '';
  }

  Future<void> loadDropdownValues() async {
    subjectType.assignAll(await DropdownManager.getValues(DropdownKeys.subjectType, defaultSubjectType));
    injurySeverity.assignAll(await DropdownManager.getValues(DropdownKeys.injurySeverity, defaultInjurySeverity));
    commonInjuryType.assignAll(await DropdownManager.getValues(DropdownKeys.commonInjuryType, defaultCommonInjuryType));
    dispositionsList.assignAll(await DropdownManager.getValues(DropdownKeys.dispositionsList, defaultDispositionsList));
    commonIllnessType.assignAll(await DropdownManager.getValues(DropdownKeys.commonIllnessType, defaultCommonIllnessType));
    immediateTreatments.assignAll(await DropdownManager.getValues(DropdownKeys.immediateTreatments, defaultImmediateTreatments));

    if (subjectType.isNotEmpty) selectedSubjectType.value = subjectType.first;
    if (injurySeverity.isNotEmpty) selectedInjurySeverity.value = injurySeverity.first;
    if (commonInjuryType.isNotEmpty) selectedCommonInjuryType.value = commonInjuryType.first;
    if (commonIllnessType.isNotEmpty) selectedCommonIllnessType.value = commonIllnessType.first;
    if (dispositionsList.isNotEmpty) selectedDisposition.value = dispositionsList.first;
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
  void setDisposition(String value) {
    selectedDisposition.value = value;
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

  void editBodyInjury(String? id, String? injuryType, String? severity, String? notes) {
    final index = bodyInjuryList.indexWhere((e) => e.id == id);
    if (index != -1) {
      bodyInjuryList[index] = BodyInjury(
        id: bodyInjuryList[index].id,
        injuryType: injuryType,
        severity: severity,
        notes: notes,
        bodySide: bodyInjuryList[index].bodySide,
        region: bodyInjuryList[index].region,
        added: bodyInjuryList[index].added,
      );
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

  void toggleIsMale(bool val){
    isMale.value = val;
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

  pickDateTime(DateTime initialDate, TextEditingController? controller) async {
    try {
      final pickedDate = await BaseHelper.datePicker(
        Get.context,
        initialDate: initialDate,
      );
      if (pickedDate == null) return;
      final pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (pickedTime == null) return;
      final finalDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      controller?.text = DateFormat('MMM dd, yyyy - hh:mm a').format(finalDateTime);
      print("DateTime picked: ${controller?.text}");
    } catch (e) {
      print("Error picking date/time: $e");
    }
  }

}
