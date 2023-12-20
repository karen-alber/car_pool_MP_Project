import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';
import 'DriverRideChoicePage.dart';

class DriverRidesPage extends StatefulWidget {
  const DriverRidesPage({Key? key}) : super(key: key);

  @override
  State<DriverRidesPage> createState() => _DriverRidesPageState();
}

class _DriverRidesPageState extends State<DriverRidesPage> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference historyreference = FirebaseDatabase.instance.ref().child('History');
  DatabaseReference ridesreference = FirebaseDatabase.instance.ref().child('Rides');

  Widget listItem({required Map rides}) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: 124,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver Name: ' + (rides['drivername'] ?? ''),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'From: ' + (rides['from'] ?? ''),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'To: ' + (rides['to'] ?? ''),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  // Function to check and move rides to history
  Future<void> checkAndMoveRidesToHistory() async {
    DateTime now = DateTime.now();
    String currentDate = DateFormat('yyyy-MM-dd').format(now);
    String currentTime = DateFormat('HH:mm:ss').format(now);

    DatabaseEvent event = await dbRef.once();
    DataSnapshot snapshot = event.snapshot;

    // Handle null snapshot value
    if (snapshot.value == null) {
      return;
    }
    Map<dynamic, dynamic>? ridesData = snapshot.value as Map<dynamic, dynamic>?;

    if (ridesData != null) {
      ridesData.forEach((key, ride) async {
        String rideTime = ride['time'];
        String rideDate = ride['date'];

        // print(rideTime);
        // print(rideDate);
        if (rideDate.compareTo(currentDate) < 0) {
          if(rideTime == "5:30 pm" && currentTime.compareTo('17:30:00') <= 0){
            // Move ride to history
            await historyreference.child(key).set(ride);
            print('Moved ride $key to History');
            // Delete ride from Rides
            await ridesreference.child(key).remove();
            print('Removed ride $key from Rides');
          }
          else if(rideTime == "7:30 am" && currentTime.compareTo('7:30:00') <= 0){
            // Move ride to history
            await historyreference.child(key).set(ride);
            print('Moved ride $key to History');
            // Delete ride from Rides
            await ridesreference.child(key).remove();
            print('Removed ride $key from Rides');
          }
          else {
            print('Skipped ride $key');
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the function when the page is initialized
    checkAndMoveRidesToHistory().then((_) {
      // After filtering, update the state to rebuild the widget with the new data
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DriverRideChoicePage()),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("All Rides", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            Map rides = snapshot.value as Map;
            rides['key'] = snapshot.key;

            return listItem(rides: rides);
          },
        ),
      ),
    );
  }
}
