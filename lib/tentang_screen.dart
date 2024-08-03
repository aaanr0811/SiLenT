import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart'; // Import video_player

void main() => runApp(MaterialApp(home: AboutScreen()));

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/tutor.mp4')
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Color.fromARGB(
              255, 0, 111, 111), // Background color for the title
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Tentang Aplikasi',
            style: TextStyle(
              color: Colors.white, // Change text color to white
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Change icon color to white
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor:
            Color.fromARGB(255, 0, 111, 111), // Set AppBar background to blue
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'PENGGUNAAN APLIKASI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration:
                          TextDecoration.underline, // Underline the text
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/penggunaan.png',
                    fit:
                        BoxFit.cover, // Adjust this to fit your image as needed
                  ),
                  SizedBox(height: 20),
                  Text(
                    'DEMO VIDEO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration:
                          TextDecoration.underline, // Underline the text
                    ),
                  ),
                  SizedBox(height: 10),
                  _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(
                          height: 200,
                          color: Colors.black12,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'KAMUS HURUF',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration:
                          TextDecoration.underline, // Underline the text
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/kamushuruf.jpg',
                    fit:
                        BoxFit.cover, // Adjust this to fit your image as needed
                  ),
                  SizedBox(height: 20),
                  Text(
                    'KAMUS KATA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration:
                          TextDecoration.underline, // Underline the text
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/kamuskata.png',
                    fit:
                        BoxFit.cover, // Adjust this to fit your image as needed
                  ),
                  SizedBox(height: 20),
                  Text(
                    'REFRENSI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration:
                          TextDecoration.underline, // Underline the text
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _launchURL('https://pmpk.kemdikbud.go.id/sibi/kosakata');
                    },
                    child: Text(
                      'https://pmpk.kemdikbud.go.id/sibi/kosakata',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            Colors.blue, // Change color to indicate it's a link
                        decoration:
                            TextDecoration.underline, // Underline the link
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
