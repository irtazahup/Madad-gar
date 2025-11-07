import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive state variables
  var obscurePassword = true.obs;

  // Validation regex
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  bool isValidEmail(String email) => _emailRegex.hasMatch(email);
  bool isValidPassword(String password) => _passwordRegex.hasMatch(password);

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void login(GlobalKey<FormState> formKey, BuildContext context) {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Form submitted successfully!')),
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
