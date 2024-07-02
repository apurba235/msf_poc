import 'package:flutter/material.dart';
import 'package:msf/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double scaleValue = 0.5;

  late final _scaleAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
    reverseDuration: const Duration(milliseconds: 1500),
  );

  late final Animation<double> _scaleAnimation = Tween<double>(begin: 0.4, end: 1).animate(
    CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.elasticInOut,
    ),
  );

  @override
  void initState() {
    _scaleAnimationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000)).then(
      (v) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Login())),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset('assets/logo.png'),
          ),
        ],
      ),
    );
  }
}
