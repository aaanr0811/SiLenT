import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'riwayat_screen.dart';
import 'database_helper.dart';
import 'tflite_helper.dart'; // Import the helper class

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  bool _isLoading = true;
  File? _capturedImage;
  List<dynamic>? _output;
  late CameraDescription _camera;
  FlutterTts flutterTts = FlutterTts();
  bool palmFound = false;
  int palmFoundCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    _camera = cameras.first;

    _controller = CameraController(_camera, ResolutionPreset.high);
    try {
      await _controller.initialize();
      await _controller.startImageStream(_processCameraImage);
      setState(() {
        _isCameraInitialized = true;
      });
      print('Kamera berhasil diinisialisasi');
    } catch (e) {
      print('Error saat menginisialisasi kamera: $e');
    }
  }

  Future<void> _loadModel() async {
    try {
      await TfliteHelper.loadModel('assets/model.tflite', 'assets/labels.txt');
      setState(() {
        _isLoading = false;
      });
      print('Model berhasil dimuat');
    } catch (e) {
      print('Error saat memuat model: $e');
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (!_isCameraInitialized || _isLoading || palmFound) return;

    try {
      var output = await TfliteHelper.runModelOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        rotation: 90, // Sesuaikan dengan rotasi kamera Anda
        numResults: 2, // Ubah sesuai dengan kebutuhan Anda
        threshold: 0.5, // Sesuaikan threshold jika diperlukan
      );

      setState(() {
        _output = output;
      });

      if (_output == null || _output!.isEmpty) {
        print('Tidak ada hasil deteksi dari model.');
      } else {
        int handCount = 0;
        for (var result in _output!) {
          if (result['label'] == 'hand' && result['confidence'] > 0.75) {
            handCount++;
          }
        }

        if (handCount == 1) {
          // Tindakan jika satu tangan terdeteksi
          print('Satu tangan terdeteksi!');
          palmFound = true; // Ubah kondisi sesuai kebutuhan
        } else if (handCount >= 2) {
          palmFoundCount += 1;
          if (palmFoundCount == 50) {
            palmFound = true;
            // Tambahkan tindakan jika dua tangan terdeteksi
            print('Dua tangan terdeteksi 50 kali!');
          }
        }
      }
    } catch (e) {
      print('Error saat menjalankan model: $e');
    }
  }

  Future<void> _processImage(File image) async {
    if (!_isCameraInitialized) {
      print('Kamera belum diinisialisasi');
      return;
    }

    try {
      var output = await TfliteHelper.runModelOnImage(
        path: image.path,
        numResults: 2, // Ubah sesuai dengan kebutuhan Anda
        threshold: 0.5, // Sesuaikan threshold jika diperlukan
      );

      setState(() {
        _output = output;
      });

      if (_output == null || _output!.isEmpty) {
        print('Tidak ada hasil deteksi dari model.');
      } else {
        print('Hasil deteksi:');
        _output!.forEach((result) {
          print(
              'Label: ${result['label']}, Confidence: ${result['confidence']}');
        });
      }
    } catch (e) {
      print('Error saat menjalankan model: $e');
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("id-ID"); // Set language to Indonesian
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _pickImage(ImageSource source) async {
    await _controller.stopImageStream(); // Hentikan aliran gambar
    await _controller.dispose(); // Matikan kamera
    setState(() {
      _isCameraInitialized = false;
    });

    var imagePicker = ImagePicker();
    var pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile == null) {
      _initializeCamera(); // Mulai kembali kamera jika tidak ada gambar dipilih
      return;
    }

    setState(() {
      _isLoading = true;
      _capturedImage = File(pickedFile.path);
    });

    await _processImage(_capturedImage!);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveImageToStorage() async {
    if (_capturedImage == null) return;

    // Tampilkan dialog pemuatan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Menyimpan...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Baca gambar dari file
      final imageBytes = await _capturedImage!.readAsBytes();
      // Decode gambar
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        print('Gagal mendecode gambar.');
        return;
      }

      // Resize gambar
      img.Image resizedImage = img.copyResize(originalImage, width: 800);

      // Encode gambar kembali ke format JPEG dengan kualitas kompresi
      final resizedImageBytes = img.encodeJpg(resizedImage, quality: 85);

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().toString() + '.jpg';
      final savedImage = File('${appDir.path}/$fileName');
      await savedImage.writeAsBytes(resizedImageBytes);

      print('Gambar berhasil disimpan: ${savedImage.path}');

      // Simpan path gambar dan hasil prediksi ke database
      await DatabaseHelper().insertImagePath(savedImage.path,
          _output![0]['label']); // pastikan label disimpan dengan benar

      if (!mounted) return; // Ensure context is still valid

      // Tutup dialog pemuatan
      Navigator.of(context).pop();

      // Tampilkan snackbar atau dialog berhasil disimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gambar berhasil disimpan.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigasi ke halaman RiwayatScreen setelah menyimpan gambar
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RiwayatScreen(),
        ),
      );
    } catch (e) {
      print('Error saat menyimpan gambar: $e');
      // Tambahkan penanganan kesalahan jika diperlukan
      Navigator.of(context).pop(); // Tutup dialog pemuatan jika ada error
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    TfliteHelper.closeModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Layar Kamera'),
        backgroundColor: Color.fromRGBO(0, 111, 111, 1.0),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _capturedImage != null
                  ? Container(
                      color: Color.fromRGBO(0, 111, 111, 1.0),
                      child: Image.file(_capturedImage!, fit: BoxFit.cover),
                    )
                  : _isCameraInitialized
                      ? CameraPreview(_controller)
                      : Container(),
          Positioned(
            bottom: 16,
            left: 16,
            child: _output != null && _output!.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.white,
                        child: Text(
                          '${_output![0]['label']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      if (_capturedImage != null)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _capturedImage = null;
                                  _initializeCamera();
                                });
                              },
                              child: Text('Coba Lagi'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _saveImageToStorage();
                              },
                              child: Text('Simpan'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _speak(_output![0]['label']);
                              },
                              child: Icon(Icons.volume_up),
                            ),
                          ],
                        ),
                    ],
                  )
                : Container(),
          ),
        ],
      ),
      floatingActionButton: _capturedImage == null && _isCameraInitialized
          ? FloatingActionButton(
              onPressed: () => _pickImage(ImageSource.camera),
              tooltip: 'Ambil Foto',
              child: Icon(Icons.camera_alt),
            )
          : null,
    );
  }
}
