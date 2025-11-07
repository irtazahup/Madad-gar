import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:as_pass/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(LoginController()); // Inject controller

  @override
  Widget build(BuildContext context) {
    print("📱 Full LoginPage build called once");

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 🖼️ Logo or image
                    Image.asset('assets/images/loginPage.jpg', height: 180),

                    const SizedBox(height: 40),

                    // 📧 Email field
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!controller.isValidEmail(value)) {
                          return 'Enter a valid email (e.g. example@mail.com)';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // 🔒 Password field (reactive)
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (!controller.isValidPassword(value)) {
                            return 'Password must be 8+ chars, include letters & numbers';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 35),

                    // 🚀 Submit Button
                    ElevatedButton(
                      onPressed: () => controller.login(
                        _formKey,
                        context,
                      ), // Validation handled in controller
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
