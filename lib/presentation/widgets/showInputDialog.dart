import 'package:flutter/material.dart';
import 'package:online_savdo/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

void ShowInputDialog(BuildContext context, String field, String content) {
  TextEditingController textController = TextEditingController();
  String errorText = '';

  void validateInput( ) {
    if (field == 'name') {
      if (textController.text.isEmpty) {
        errorText = 'Ma\'lumot kiritilishi shart!';
      } else if (textController.text.length < 3) {
        errorText = 'Ism kamida 3 ta belgidan iborat bo\'lishi kerak!';
      } else {
        errorText = '';
      }
    } else if (field == 'address') {
      if (textController.text.isEmpty) {
        errorText = 'Ma\'lumot kiritilishi shart!';
      } else if (textController.text.length < 5) {
        errorText = 'Kamida 5 ta belgi kiritish kerak!';
      } else {
        errorText = '';
      }
    } else if (field == 'phone') {
      final pattern = r'^\+998[0-9]{9}$';
      final regExp = RegExp(pattern);
      String phone = "+998${textController.text}";
      if (textController.text.isEmpty) {
        errorText = 'Ma\'lumot kiritilishi shart!';
      } else if (!regExp.hasMatch(phone)) {
        errorText = "Tel-raqamni 941234567 kabi kiriting";
      } else {
        errorText = '';
      }
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(content),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                    labelText: "$field kiritish",
                    errorText: errorText.isEmpty ? null : errorText,
                    ),
                    
                onChanged: (value) {
                  setState(() {
                    validateInput();
                  });
                },
              ),
            ],
          );
        }),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return TextButton(
              onPressed: () {
                setState(() {
                  validateInput();
                });

                if (errorText.isEmpty) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateProfile(field, textController.text);
                      Navigator.of(context).pop();
                }
                
              },
              child: Text('OK'),
            );
          }),
        ],
      );
    },
  );
}
