import 'dart:io';
import 'package:flutter/material.dart';
import 'package:silent_app/main.dart';
import 'database_helper.dart'; // Import DatabaseHelper
import 'detail_screen.dart'; // Import DetailScreen

class RiwayatScreen extends StatefulWidget {
  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<Map<String, dynamic>> images = [];

  @override
  void initState() {
    super.initState();
    loadImagesFromDatabase();
  }

  Future<void> loadImagesFromDatabase() async {
    List<Map<String, dynamic>> data = await DatabaseHelper().getImages();
    setState(() {
      images = data;
    });
  }

  Future<void> _refreshImages() async {
    await loadImagesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              )
            : null,
        title: Text('Riwayat'),
        backgroundColor: Color.fromRGBO(0, 111, 111, 1.0), // Warna hijau
        foregroundColor: Colors.white, // Warna teks menjadi putih
        iconTheme:
            IconThemeData(color: Colors.white), // Warna ikon menjadi putih
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _refreshImages();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 2.0), // Jarak dari atas
        child: images.isEmpty
            ? Center(
                child: Text('Tidak ada gambar tersimpan.'),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing:
                      0, // Tidak ada jarak horizontal antar gambar
                  mainAxisSpacing: 0, // Tidak ada jarak vertikal antar gambar
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            images: images,
                            initialIndex: index,
                            refreshCallback:
                                _refreshImages, // Pass the refresh callback
                          ),
                        ),
                      );
                    },
                    child: Image.file(
                      File(images[index]['path']),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
