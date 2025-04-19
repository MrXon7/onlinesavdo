import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_savdo/data/models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  UserProvider() {
    // Bu yerda foydalanuvchi ma'lumotlarini yuklash jarayonini boshlaymiz
    // Misol uchun, Firebase yoki boshqa manbadan ma'lumotlarni olish
  }

  Future<void> loadUserData(String userId) async{
    // Bu yerda foydalanuvchi ma'lumotlarini yuklaymiz
    try{
      final doc= await FirebaseFirestore.instance.collection('users').doc(userId).get(); 
      if(doc.exists){
        _user=User.fromJson(doc.data()!);
      } 
    notifyListeners();
    }catch(e){
      print("Error: $e");
    }
  }

  Future<void> updateProfile(User newUserData) async {
    _user = newUserData;
    notifyListeners();
    // Bu yerda firebasedagi ma'lumotlar yangilanadi
  }
}
