import 'package:as_pass/api/signup_api.dart';
import 'package:as_pass/services/supabase_service.dart';
import 'package:as_pass/ui/auth/login.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool isValidName(String name) => _nameRegex.hasMatch(name.trim());

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

  RxBool signupLoading = false.obs;
  late SignUpApi sign;
  late AuthResponse response;

  @override
  void onInit() {
    super.onInit();
    // Initialize the SignUpApi with Supabase client when the controller is created
    sign = SignUpApi(SupabaseService.client);
  }
  //  void signup(GlobalKey<FormState> formKey, BuildContext context) {
  //   if (!agreeToTerms.value) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('⚠️ Please agree to Terms and Conditions'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //     return;
  //   }

  //   if (formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('✅ Account created successfully!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //     // Navigate to login or home page
  //     // Get.offAll(() => LoginPage());
  //   }
  // }

  void SignUp() async {
    signupLoading.value = true; // Start loading
    try {
      // Debug: Print the values being sent
      print('=== SIGNUP ATTEMPT ===');
      print(
        'Name: ${'${firstNameController.text} ${lastNameController.text}'}',
      );
      print('Email: ${emailController.text}');
      print('Password length: ${passwordController.text.length}');

      // Make the signup API call
      response = await sign.signup(
        firstNameController.text + ' ' + lastNameController.text,
        emailController.text,
        passwordController.text,
      );
      print('Signup response: $response');
      // Stop loading after the response
      signupLoading.value = false;

      // Check if the signup was successful based on the response
      if (response.user != null && response.user!.id.isNotEmpty) {
        // sp.setName(name);

        // Successful signup
        Get.snackbar(
          "Maddad'gar",
          'Signup successful! Check your inbox for verification.',
        );
        Get.offAll(
          () => LoginPage(),
        ); // Navigate to the login page after signup
      } else {
        // Signup failed (e.g., invalid email, duplicate account)
        Get.snackbar("Maddad'gar", 'Signup failed');
      }
    } catch (e) {
      signupLoading.value = false; // Ensure loading is stopped on error
      // Log or display the error message
      print("Signup error: $e");
      Get.snackbar("Maddad'gar", 'Signup failed');
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
