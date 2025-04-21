import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_savdo/data/models/user_model.dart';
import 'package:online_savdo/presentation/providers/cart_provider.dart';

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

  Future<void> updateProfile(String Field, String newUserData) async {
    _user = User(
      id: _user!.id,
      name: Field == 'name' ? newUserData : _user!.name,
      phone: Field == 'phone' ? newUserData : _user!.phone,
      address: Field == 'address' ? newUserData : _user!.address, 
      cartItems: Field == 'cartItems' ? (newUserData as List).map((item) => CartItem.fromJson(item)).toList() : _user!.cartItems,
    );
    notifyListeners();
    // Bu yerda firebasedagi ma'lumotlar yangilanadi
    FirebaseFirestore.instance.collection('users').doc(_user!.id).update({
      Field: newUserData,
    }).then((value) {
      print("User Updated");
    }).catchError((error) {
      print("Failed to update user: $error");
    });
  }
}
