
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'splash_gate.dart';

class ReturningSplash extends ConsumerStatefulWidget {
  const ReturningSplash({super.key});

  @override
  ConsumerState<ReturningSplash> createState() => _ReturningSplashState();
}

class _ReturningSplashState extends ConsumerState<ReturningSplash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      navigateToHome(context, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/splash_static.png'),
          height: 200,
        ),
      ),
    );
  }
}
