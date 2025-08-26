import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admob_helper_controller.dart';

class AdmobHelperView extends GetView<AdmobHelperController> {
  const AdmobHelperView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdmobHelperView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdmobHelperView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
