// lib/app/modules/login/views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:food_app/app/common_ui/text_form_filed.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                InputTextFormField(
                  controller: controller.emailController,
                  onChanged: (value) {
                    controller.emailController.value = TextEditingValue(
                      text: value.toLowerCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText:
                        !controller.isEmailValid &&
                            controller.emailController.text.isNotEmpty
                        ? 'Invalid email format (must be lowercase Gmail)'
                        : null,
                    labelStyle: const TextStyle(color: Colors.black),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: 'Email',
                ),

                const SizedBox(height: 16),

                InputTextFormField(
                  controller: controller.passwordController,
                  obscureText: true,
                  label: 'Password',
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => null,
                ),

                const SizedBox(height: 16),

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Login"),
                      ),
                      ElevatedButton(
                        onPressed: controller.goToRegister,
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
