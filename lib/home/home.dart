import 'package:as_pass/ui/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Welcome Home!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is your home page',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            GestureDetector(
              child: Text("Click me to logout"),
              onTap: () => {Get.offAll(() => LoginPage())},
            ),
          ],
        ),
      ),
    );
  }
}
