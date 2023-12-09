import 'package:flutter/material.dart';
import 'AddGoRidePage.dart';

class DriverRideChoicePage extends StatefulWidget {
  const DriverRideChoicePage({super.key});

  @override
  State<DriverRideChoicePage> createState() => _DriverRideChoicePageState();
}

class _DriverRideChoicePageState extends State<DriverRideChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Ride Choice Page", style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/driverAddGoRidePage');
                },
                title: Center(child: Text("To Faculty")),

              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/driverAddReturnRidePage');
                },
                title: Center(child: Text("From Faculty")),
              ),
            ),
          ],
        )
    );
  }
}
