import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_savdo/data/models/product_model.dart';
import 'package:online_savdo/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class EditProductScreen extends StatelessWidget {
  final Product product;
  EditProductScreen({super.key, required this.product});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _descriptionController.text = product.description;
    _categoryController.text = product.categorie;
    _imageUrlController.text = product.imageUrl;
    
    Future<void> saveForm() async {
      if (!_form.currentState!.validate()) {
        return;
      }
      _form.currentState!.save();
      try {
        if (product.id.isEmpty) {
          // Yangi mahsulot qo'shish
          await Provider.of<ProductProvider>(context, listen: false).addProduct(
            Product(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              imageUrl: _imageUrlController.text,
              categorie: _categoryController.text,
            ),
            // Add the second required argument here
          );
        } else {
          // bor mahsulotni taxririlash
          await Provider.of<ProductProvider>(context, listen: false)
              .updateProduct(
            Product(
              id: product.id,
              name: _nameController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              imageUrl: _imageUrlController.text,
              categorie: _categoryController.text,
            ),
          );
        }
        print("IMAGE URL: ${_imageUrlController.text}");

// Controllerlarni tozalash
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _categoryController.clear();
        _imageUrlController.clear();
        Navigator.of(context).pop();
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } finally {}
    }

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedImage != null) {
        _imageUrlController.text = File(pickedImage.path).toString();
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tahrirlash/qo\'shish',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Nomi', border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mahsulot nomini kiriting.';
                  }
                  return null;
                },
               
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                    labelText: 'Narxi', border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Iltimos mahsulot narxini kiriting.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Iltimos faqat raqam kiriting.';
                  }
                  if (double.parse(value) <= 0) {
                    return '0 da yuqori qiymat kiriting.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    labelText: 'Tafsif', border: OutlineInputBorder()),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mahsulot tafsifini kiriting.';
                  }
                  if (value.length < 10) {
                    return 'Kamida 10 ta belgi kiritilishi kerak.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                    labelText: 'Categorya', border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mahsulot kategoriyasini kiriting.';
                  }
                  return null;
                },
              ),
              // TextFormField(
              //   initialValue: _initValues['quantity'],
              //   decoration: InputDecoration(labelText: 'Quantity'),
              //   textInputAction: TextInputAction.next,
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'Please enter quantity.';
              //     }
              //     if (int.tryParse(value) == null) {
              //       return 'Please enter a valid number.';
              //     }
              //     if (int.parse(value) < 0) {
              //       return 'Please enter a positive number.';
              //     }
              //     return null;
              //   },
              //   onSaved: (value) {
              //     _editedProduct = Product(
              //       id: _editedProduct.id,
              //       name: _editedProduct.name,
              //       description: _editedProduct.description,
              //       price: _editedProduct.price,
              //       imageUrl: _editedProduct.imageUrl,
              //       categorie: _editedProduct.categorie
              //     );
              //   },
              // ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Center(
                              child: Icon(Icons.image,
                                  size: 50, color: Colors.grey[700]),
                            )
                          : FittedBox(
                              child: Text(_imageUrlController.text),
                              // Image.network(
                              //   _imageUrlController.text,
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
