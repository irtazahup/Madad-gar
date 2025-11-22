import 'package:as_pass/api/login_api.dart';
import 'package:as_pass/home/home.dart';
import 'package:as_pass/services/supabase_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  RxBool loginLoading = false.obs;
  late AuthResponse response;
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive state variables
  var obscurePassword = true.obs;
  late LoginApi login;
  void onInit() {
    login = LoginApi(SupabaseService.client);
    // TODO: implement onInit
    super.onInit();
  }

  // Validation regex
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _passwordRegex = RegExp(r'^.{8,}$');

  bool isValidEmail(String email) => _emailRegex.hasMatch(email);
  bool isValidPassword(String password) =>
      _passwordRegex.hasMatch(password.trim());

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // void Login(GlobalKey<FormState> formKey, BuildContext context) {
  //   print("Login called");
  //   if (formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('✅ Form submitted successfully!')),
  //     );
  //   }
  // }

  void Login() async {
    loginLoading.value = true; // Start loading
    try {
      response = await login.login(
        emailController.text,
        passwordController.text,
      );
      loginLoading.value = false; // Stop loading

      // Check if the login is successful based on the response
      if (response.session?.accessToken != null) {
        // Successful login
        // sp.setSession(email,response.user?.id ?? "");
        // sp.setLogin();
        Get.snackbar("Maddad'gar", 'خوش آمدید!');
        Get.off(() => HomePage());
      } else {
        // Login failed
        Get.snackbar("Maddad'gar", 'Invalid email or password');
      }
    } catch (e) {
      loginLoading.value = false; // Ensure loading is stopped on error
      // Log or display the error message
      print("Login error: $e");

      Get.snackbar("Maddad'gar", 'Apna Net Check kren');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
