// import 'package:flutter/material.dart';

// class StatisticsPage extends StatelessWidget {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Statistika'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('orders').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();
                
//                 int totalOrders = snapshot.data!.docs.length;
//                 int completedOrders = snapshot.data!.docs
//                     .where((doc) => doc['status'] == 'completed')
//                     .length;
//                 double totalRevenue = snapshot.data!.docs
//                     .where((doc) => doc['status'] == 'completed')
//                     .fold(0.0, (sum, doc) => sum + doc['totalAmount']);
                
//                 return Column(
//                   children: [
//                     StatCard(
//                       title: 'Jami Buyurtmalar',
//                       value: totalOrders.toString(),
//                       icon: Icons.shopping_cart,
//                       color: Colors.blue,
//                     ),
//                     StatCard(
//                       title: 'Yakunlangan Buyurtmalar',
//                       value: completedOrders.toString(),
//                       icon: Icons.check_circle,
//                       color: Colors.green,
//                     ),
//                     StatCard(
//                       title: 'Jami Daromad',
//                       value: '\$${totalRevenue.toStringAsFixed(2)}',
//                       icon: Icons.attach_money,
//                       color: Colors.purple,
//                     ),
//                   ],
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             Text('Oxirgi 7 kunlik savdo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Container(
//               height: 200,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore.collection('orders')
//                     .where('status', isEqualTo: 'completed')
//                     .where('createdAt', isGreaterThan: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 7))))
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return CircularProgressIndicator();
                  
//                   // Bu joyda grafik yoki diagramma qo'shishingiz mumkin
//                   // Masalan: charts_flutter paketidan foydalanish
//                   return Center(child: Text('Bu yerda grafik bo\'lishi mumkin'));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const StatCard({
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: Icon(icon, size: 40, color: color),
//         title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(value, style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }