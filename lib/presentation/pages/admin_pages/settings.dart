import 'package:flutter/material.dart';

class AdminSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profil ma\'lumotlari'),
                  onTap: () {
                    // Profil sozlamalari sahifasiga o'tish
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Bildirishnomalar'),
                  onTap: () {
                    // Bildirishnomalar sozlamalari
                  },
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Xavfsizlik'),
                  onTap: () {
                    // Xavfsizlik sozlamalari
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Yordam va qo\'llanma'),
                  onTap: () {
                    // Yordam sahifasiga o'tish
                  },
                ),
              ],
            ),
            Column(
              children: [
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Chiqish', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    // Chiqish logikasi
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
