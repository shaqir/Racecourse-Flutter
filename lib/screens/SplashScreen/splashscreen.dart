import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff674ea7), // Background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100), // Top padding
            const Text(
              'Racecourse Track',
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60), // Padding between text and logo
            Center(
              child: Image.asset(
                'assets/logo.png', // Logo path
                width: 150, // Adjust the size as needed
                color: Colors.white, // White logo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
