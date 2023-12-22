import 'package:flutter/material.dart';
import 'PaymentPage.dart';
import 'OrderTrackingPage.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late Map myreceiveddata;

  @override
  Widget build(BuildContext context) {
    myreceiveddata = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Order Details Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text('Name: ' + (myreceiveddata['Name']),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20,),
            Text('Mobile No.: ' + (myreceiveddata['Num']),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20,),
            Text('From: ' + (myreceiveddata['From']),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20,),
            Text('To: ' + (myreceiveddata['To']),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20,),
            Text('Time: ' + (myreceiveddata['Time']),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20,),
            Text('Date: ' + (myreceiveddata['Date']),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/userOrderTrackingPage', arguments: {
                    'Time': myreceiveddata['Time'],
                    'Date': myreceiveddata['Date'],
                    'ridekey': myreceiveddata['key'],
                  });
                },
                child: Text('Check the Ride Status'),),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/userPaymentPage');
              },
              child: Text('Pay for this ride'),),
          ],
        ),
      ),
    );
  }
}
