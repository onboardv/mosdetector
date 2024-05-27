import 'package:flutter/material.dart';

class SoundBackgroundScreen extends StatelessWidget {
  const SoundBackgroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Centered background image
          Center(
            child: Image.asset(
              'assets/background_sound_image.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Other widgets can be added here

        ],
      ),
    );
  }
}
