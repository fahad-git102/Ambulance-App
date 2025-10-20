import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodels/pin_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PIN Update',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: PinUpdateScreen(),
    );
  }
}

class PinUpdateScreen extends StatelessWidget {
  PinUpdateScreen({Key? key}) : super(key: key);

  final PinController controller = Get.put(PinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Obx(() => controller.isLoading.value
                  ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF3198D0)))
                  : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: controller.fadeAnimation,
                  child: SlideTransition(
                    position: controller.slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        _buildHeader(),
                        const SizedBox(height: 50),
                        _buildPinForm(),
                        const SizedBox(height: 40),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              )),
              Positioned(
                  top: 20,
                  left: 30,
                  child: InkWell(
                onTap: (){
                  Get.back();
                },
                child: Padding(padding: EdgeInsets.all(4), child: Icon(Icons.arrow_back_ios_new_outlined),),
              ))
            ],
          ),
        ),
      )
    );
  }

  Widget _buildHeader() {
    return Obx(() => Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF3198D0).withOpacity(0.1),
            border:
            Border.all(color: const Color(0xFF3198D0), width: 2),
          ),
          child: const Icon(
            Icons.lock_outline,
            size: 50,
            color: Color(0xFF3198D0),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          controller.hasExistingPin.value ? 'Update PIN' : 'Create PIN',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3198D0),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          controller.hasExistingPin.value
              ? 'Enter your old PIN and set a new one'
              : 'Set up a secure PIN for your account',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }

  Widget _buildPinForm() {
    return Obx(() => Column(
      children: [
        if (controller.hasExistingPin.value) ...[
          _buildPinField(
            controller: controller.oldPinController,
            focusNode: controller.oldPinFocus,
            label: 'Old PIN',
            icon: Icons.lock_clock,
            onSubmitted: (_) => controller.newPinFocus.requestFocus(),
          ),
          const SizedBox(height: 20),
        ],
        _buildPinField(
          controller: controller.newPinController,
          focusNode: controller.newPinFocus,
          label: 'New PIN',
          icon: Icons.lock_open,
          onSubmitted: (_) => controller.confirmPinFocus.requestFocus(),
        ),
        const SizedBox(height: 20),
        _buildPinField(
          controller: controller.confirmPinController,
          focusNode: controller.confirmPinFocus,
          label: 'Confirm PIN',
          icon: Icons.verified_user,
          onSubmitted: (_) => controller.handleSubmit(),
        ),
      ],
    ));
  }

  Widget _buildPinField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    required Function(String) onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 6,
        style: const TextStyle(
          color: Color(0xFF3198D0),
          fontSize: 18,
          letterSpacing: 8,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF3198D0)),
          counterText: '',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF3198D0),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF3198D0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3198D0).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          controller.hasExistingPin.value ? 'UPDATE PIN' : 'CREATE PIN',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ),
    ));
  }
}