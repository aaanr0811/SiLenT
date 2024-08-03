import 'dart:typed_data';
import 'package:flutter_tflite/flutter_tflite.dart';

class TfliteHelper {
  static bool _modelLoaded = false;

  /// Memuat model dan label dari jalur yang diberikan.
  static Future<void> loadModel(String modelPath, String labelsPath) async {
    try {
      String? res = await Tflite.loadModel(
        model: modelPath,
        labels: labelsPath,
      );
      if (res != null) {
        _modelLoaded = true;
        print('Model berhasil dimuat: $res');
      } else {
        print('Gagal memuat model.');
      }
    } catch (e) {
      print('Error saat memuat model: $e');
    }
  }

  /// Menjalankan model pada frame kamera.
  static Future<List<dynamic>?> runModelOnFrame({
    required List<Uint8List> bytesList,
    required int imageHeight,
    required int imageWidth,
    int rotation = 0,
    int numResults = 2,
    double threshold = 0.5,
  }) async {
    if (!_modelLoaded) {
      print('Model belum dimuat.');
      return null;
    }

    try {
      var output = await Tflite.runModelOnFrame(
        bytesList: bytesList,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        rotation: rotation,
        numResults: numResults,
        threshold: threshold,
      );
      return output;
    } catch (e) {
      print('Error saat menjalankan model pada frame: $e');
      return null;
    }
  }

  /// Menjalankan model pada gambar yang diambil.
  static Future<List<dynamic>?> runModelOnImage({
    required String path,
    int numResults = 2,
    double threshold = 0.5,
  }) async {
    if (!_modelLoaded) {
      print('Model belum dimuat.');
      return null;
    }

    try {
      var output = await Tflite.runModelOnImage(
        path: path,
        numResults: numResults,
        threshold: threshold,
      );
      return output;
    } catch (e) {
      print('Error saat menjalankan model pada gambar: $e');
      return null;
    }
  }

  /// Menutup model yang dimuat.
  static Future<void> closeModel() async {
    if (!_modelLoaded) return;

    try {
      await Tflite.close();
      _modelLoaded = false;
      print('Model berhasil ditutup.');
    } catch (e) {
      print('Error saat menutup model: $e');
    }
  }
}
