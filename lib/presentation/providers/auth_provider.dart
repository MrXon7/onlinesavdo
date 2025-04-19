import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_savdo/data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  String? _telegramId;
  User? _userData;
  bool _isLoading = true;
  bool _isConnected = false;

  String? get telegramId => _telegramId;
  User? get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;

  AuthProvider() {
    _getTelegramId();
  }

  void _getTelegramId() {
    // Telegram ID olish uchun kod
    // Bu yerda siz telegram ID olish uchun kerakli kodni yozishingiz mumkin
    _telegramId = "123456789"; // Misol uchun, bu yerda telegram ID o'rnatiladi

    if (_telegramId != null) {
      _checkUserInFirestore(_telegramId!);
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  // userni firestoredan tekshirish
  void _checkUserInFirestore(String tgId) async {
    // Bu yerda foydalanuvchini Firestore'dan tekshirish uchun kerakli kodni yozishingiz mumkin
    // Agar foydalanuvchi mavjud bo'lsa, _userData o'rnatiladi
    // Aks holda, yangi foydalanuvchi yaratish jarayoni boshlanadi
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(tgId).get();
      if (userDoc.exists) {
        _userData = User.fromJson(userDoc.data() as Map<String, dynamic>);
       
      } else {
        _userData = null;
      }
    } catch (e) {
      print("Errorim: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Foydalanuvchini Firestore'ga saqlash
  Future<void> registerUser(User newuser, BuildContext context) async {
    try {
      if (_telegramId == null) return;
      _isLoading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newuser.id)
          .set(newuser.toJson());
      _userData = newuser;
    } catch (e) {
      print("Errorim: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
