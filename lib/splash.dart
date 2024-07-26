import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('SplashPage'),
      ),
    );
  }

  void newHomePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/HomePage');
  }
}
