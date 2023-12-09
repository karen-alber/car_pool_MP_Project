import 'package:flutter/material.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});


  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrderTrackingPage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OrderTrackingPage(),
    );
  }

}