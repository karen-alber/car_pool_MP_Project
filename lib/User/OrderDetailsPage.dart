import 'package:flutter/material.dart';
import 'PaymentPage.dart';

List Rides = [
  'Driver:\nMohamed@eng.asu.edu.eg\n\nRide Details:\nGate 3 , @5:30pm, 21/11/2023\n\nRoute:\nAbdu-Basha to Abbaseya',
  'Driver:\nMohamed@eng.asu.edu.eg\n\nRide Details:\nGate 4 , @7:30am, 21/11/2023\n\nRoute:\nAbbaseya to Abdu-Basha',
];
var index = 0;

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});
  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Ride Details", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(Rides[index], style: const TextStyle(fontSize: 20),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
          child: const Column(
            children: [
              Text("Pay"),
              Icon(Icons.payment),
            ],
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/userPaymentPage');
          }),
    );
  }
}