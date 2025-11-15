import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignupController extends GetxController {
  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Reactive state variables
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var agreeToTerms = false.obs;

  // Validation regex
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _passwordRegex = RegExp(r'^.{8,}$');

  final _nameRegex = RegExp(r'^\p{L}{2,}$', unicode: true);

  bool isValidEmail(String email) => _emailRegex.hasMatch(email);
  bool isValidPassword(String password) => _passwordRegex.hasMatch(password);
  bool isValidName(String name) => _nameRegex.hasMatch(name);

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void toggleAgreeToTerms(bool? value) {
    agreeToTerms.value = value ?? false;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void signup(GlobalKey<FormState> formKey, BuildContext context) {
    if (!agreeToTerms.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please agree to Terms and Conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to login or home page
      // Get.offAll(() => LoginPage());
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
