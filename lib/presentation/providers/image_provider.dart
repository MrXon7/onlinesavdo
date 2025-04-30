import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:online_savdo/data/models/image_model.dart';

class ImageBBProvider with ChangeNotifier {
  final String _apiKey =
      '71059ff5bf7d18a709c2dff763bae584'; // ImgBB dan olingan API kaliti
  ImageBB? _images;
  String _error = '';

  ImageBB? get images => _images;
  String get error => _error;

  Future<void> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      final Uri apiUrl =
          Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
      String base64Image = base64Encode(imageBytes);
      final response = await http.post(apiUrl, body: {
        'image': base64Image,
        'name': fileName,
      });

      final responseData = json.decode(response.body);
     
      if (response.statusCode == 200) {
        // Agar rasm muvaffaqiyatli yuklangan bo'lsa, natijani oling
        _images = ImageBB.fromJson(responseData['data']);
      } else {
        // Agar xato yuz bersa, xatoni qaytaring
        throw Exception(
            'Rasm yuklashda xato: ${responseData['error']['message']}');
      }
    } catch (e) {
      _error = 'Xatolik yuz berdi: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteImage(ImageBB image) async {
    try {
      // ImgBB ning delete URLiga so'rov
      final response = await http.get(Uri.parse(image.deleteUrl));

      if (response.statusCode == 200) {
        _images = null; // O'chirilgandan so'ng rasmni null ga o'rnatish
        notifyListeners();
      } else {
        throw Exception('Oʻchirish muvaffaqiyatsiz: ${response.statusCode}');
      }
    } catch (e) {
      _error = 'Rasm o\'chirishda xato: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<XFile?> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
        imageQuality: 90,
      );
      return pickedFile;
    } catch (e) {
      _error = 'Rasm tanlashda xato: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }
}
