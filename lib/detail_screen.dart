import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import flutter_tts
import 'database_helper.dart';
import 'riwayat_screen.dart';

class DetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> images;
  final int initialIndex;
  final Function refreshCallback;

  DetailScreen({
    required this.images,
    required this.initialIndex,
    required this.refreshCallback,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late PageController _pageController;
  late FlutterTts flutterTts; // Initialize flutterTts

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    flutterTts = FlutterTts(); // Initialize TTS
  }

  @override
  void dispose() {
    _pageController.dispose();
    flutterTts.stop(); // Stop TTS when disposing
    super.dispose();
  }

  Future<void> _deleteImage(String path) async {
    await DatabaseHelper().deleteImage(path);
    widget.refreshCallback();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RiwayatScreen(),
      ),
    );
  }

  Future<void> _speakText(String text) async {
    await flutterTts.setLanguage("id-ID"); // Set language
    await flutterTts.setPitch(1.0); // Set pitch
    await flutterTts.speak(text); // Speak the text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Gambar'),
        backgroundColor: Color.fromRGBO(0, 111, 111, 1.0),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Hapus Gambar?'),
                    actions: [
                      TextButton(
                        child: Text('Tidak'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Hapus'),
                        onPressed: () {
                          _deleteImage(widget
                              .images[_pageController.page!.toInt()]['path']);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.file(
                    File(widget.images[index]['path']),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${widget.images[index]['label'] ?? 'Tidak ada prediksi'}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
              IconButton(
                icon: Icon(Icons.volume_up),
                onPressed: () {
                  _speakText(
                      widget.images[index]['label'] ?? 'Tidak ada prediksi');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
