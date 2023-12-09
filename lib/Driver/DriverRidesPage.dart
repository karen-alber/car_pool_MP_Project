import 'package:flutter/material.dart';
import 'RideUsersAppliedPage.dart';
import 'DriverRideChoicePage.dart';
import 'package:firebase_database/firebase_database.dart';

List Rides = [
  'Mohamed@eng.asu.edu.eg\n   Gate 3 , @5:30pm\n\n Abdu-Basha to Abbaseya',
  'Mohamed@eng.asu.edu.eg\n   Gate 4 , @7:30am\n\n Abbaseya to Abdu-Basha',
];

class DriverRidesPage extends StatefulWidget {
  const DriverRidesPage({super.key});
  @override
  State<DriverRidesPage> createState() => _DriverRidesPageState();
}

class _DriverRidesPageState extends State<DriverRidesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/driverDriverRideChoicePage');
          },
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Rides", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
          itemCount: Rides.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Card(
                child: ListTile(
                  onTap: () {
                    print('you pressed on ${Rides[index]}');
                  },
                  title: Text(Rides[index]),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const RideUsersAppliedPage()));
                      },
                      icon: const Icon(Icons.remove_red_eye)),
                ),

              ),
            );}
      ),
    );
  }

}