import 'package:face_celeb/widgets/home_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 108, 172, 255),
              Color.fromARGB(255, 179, 219, 251),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/images/bg_intro.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 16),
              child: const Text(
                'Face Detection',
                style: TextStyle(
                  color: Color.fromARGB(234, 255, 255, 255),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: const Text(
                'Our Celebrity Image Recognition App leverages a vast database of celebrity images and employs the powerful MobileNet model to accurately identify faces. Simply upload a photo, and our app will instantly recognize and provide information about the celebrity. With a user-friendly interface and real-time results, discovering your favorite celebrities has never been easier.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ImageSelectionScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
