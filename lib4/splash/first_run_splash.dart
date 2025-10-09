
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'splash_gate.dart';

class FirstRunSplash extends ConsumerStatefulWidget {
  const FirstRunSplash({super.key});

  @override
  ConsumerState<FirstRunSplash> createState() => _FirstRunSplashState();
}

class _FirstRunSplashState extends ConsumerState<FirstRunSplash> {
  final PageController _pc = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pc,
            children: const [
              _SplashPage('Welcome to FoodApp', 'assets/splash1.png'),
              _SplashPage('Browse & Book', 'assets/splash2.png'),
              _SplashPage('Fast Checkout', 'assets/splash3.png'),
            ],
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: () => navigateToHome(context, ref),
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashPage extends StatelessWidget {
  final String caption;
  final String asset;
  const _SplashPage(this.caption, this.asset);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(asset, height: 240, fit: BoxFit.contain),
          const SizedBox(height: 24),
          Text(
            caption,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
