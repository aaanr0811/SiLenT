import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'info_screen.dart';
import 'tentang_screen.dart';
import 'riwayat_screen.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SiLenTApp());
}

class SiLenTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiLenT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  height: 160,
                  color: const Color.fromRGBO(0, 111, 111, 1.0),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SiLenT',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Monoscope',
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sign Language Translator',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    _buildGridButton('Kamera', Icons.camera_alt, context, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraScreen(),
                        ),
                      );
                    }, const Color.fromRGBO(255, 255, 255, 1.0)),
                    _buildGridButton('Riwayat', Icons.history, context, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RiwayatScreen(),
                        ),
                      );
                    }, const Color.fromRGBO(255, 255, 255, 1.0)),
                    _buildGridButton('Info', Icons.info, context, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoScreen(),
                        ),
                      );
                    }, const Color.fromRGBO(255, 255, 255, 1.0)),
                    _buildGridButton('Tentang Aplikasi', Icons.book, context,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutScreen(),
                        ),
                      );
                    }, const Color.fromRGBO(255, 255, 255, 1.0)),
                  ],
                ),
              ),
            ),
            ClipPath(
              clipper: BottomHeaderClipper(),
              child: Container(
                height: 150,
                color: const Color.fromRGBO(0, 111, 111, 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(String title, IconData icon, BuildContext context,
      VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromRGBO(0, 111, 111, 1.0),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color.fromRGBO(0, 0, 0, 1.0)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(3, 3, 3, 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 50)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 50)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 50)
      ..quadraticBezierTo(size.width / 2, 0, size.width, 50)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
