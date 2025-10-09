import 'package:flutter/material.dart';
import 'package:lead_management/common_ui/common_button.dart';
import 'package:lead_management/common_ui/input_text_field.dart';
import 'package:lead_management/common_ui/text_styles.dart';
import 'package:lead_management/dashboard_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/login/inmakes_logo.png',
              height: 100,
              width: 250,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/login/logo.png', height: 150, width: 150),
            const SizedBox(height: 8),

            Text("Welcome to Inmakes!", style: TextStyles.heading1),
            const SizedBox(height: 8),

            Text(
              "Sign in to continue",
              style: TextStyles.heading2.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: InputTextFormField(
                label: 'Username',
                controller: TextEditingController(),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: InputTextFormField(
                label: 'Password',
                controller: TextEditingController(),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: CommonButton(
                buttonType: true,
                title: "Login",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const DashboardView();
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            CommonButton(title: "Forgot Password?", onPressed: () {}),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
