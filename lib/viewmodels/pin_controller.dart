import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/password_screen.dart';

class PinController extends GetxController with GetTickerProviderStateMixin {
  final oldPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  final oldPinFocus = FocusNode();
  final newPinFocus = FocusNode();
  final confirmPinFocus = FocusNode();

  final hasExistingPin = false.obs;
  final isLoading = true.obs;
  final savedPin = Rxn<String>();

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();
    setupAnimations();
    checkExistingPin();
  }

  void setupAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    animationController.forward();
  }

  Future<void> checkExistingPin() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString('user_pin');
    savedPin.value = pin;
    hasExistingPin.value = pin != null;
    isLoading.value = false;
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', pin);
  }

  void showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> handleSubmit() async {
    if (hasExistingPin.value) {
      if (oldPinController.text.isEmpty) {
        showMessage('Please enter your old PIN', isError: true);
        return;
      }
      if (oldPinController.text != savedPin.value) {
        showMessage('Old PIN is incorrect', isError: true);
        shakeAnimation();
        return;
      }
    }

    if (newPinController.text.isEmpty) {
      showMessage('Please enter a new PIN', isError: true);
      return;
    }

    if (newPinController.text.length < 4) {
      showMessage('PIN must be at least 4 digits', isError: true);
      return;
    }

    if (newPinController.text != confirmPinController.text) {
      showMessage('PINs do not match', isError: true);
      shakeAnimation();
      return;
    }

    await savePin(newPinController.text);
    showMessage('PIN ${hasExistingPin.value ? 'updated' : 'created'} successfully!');

    // Reset form
    savedPin.value = newPinController.text;
    hasExistingPin.value = true;
    oldPinController.clear();
    newPinController.clear();
    confirmPinController.clear();
    Navigator.pushAndRemoveUntil(
      Get.context!,
      MaterialPageRoute(builder: (context) => PasswordScreen()),
          (route) => false,
    );
  }

  void shakeAnimation() {
    animationController.reset();
    animationController.forward();
  }

  @override
  void onClose() {
    oldPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    oldPinFocus.dispose();
    newPinFocus.dispose();
    confirmPinFocus.dispose();
    animationController.dispose();
    super.onClose();
  }
}