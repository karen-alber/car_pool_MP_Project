import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'OrderDetailsPage.dart';
import 'MyCartPage.dart';
import 'ProfilePage.dart';
import 'UserHistoryPage.dart';


class AvailableRidesPage extends StatefulWidget {
  const AvailableRidesPage({Key? key}) : super(key: key);
  @override
  State<AvailableRidesPage> createState() => _AvailableRidesPageState();
}

class _AvailableRidesPageState extends State<AvailableRidesPage> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference reference = FirebaseDatabase.instance.ref();
  DatabaseReference ridesreference = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference historyreference = FirebaseDatabase.instance.ref().child('History');
  Query usersreference = FirebaseDatabase.instance.ref().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  String? uemail;
  late DatabaseReference dbRef1;

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
              'From: ' + (rides['from']?? ''),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'To: ' + (rides['to']?? ''),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final User? user = _auth.currentUser;
                    if (user != null) {
                      uemail = user.email;

                      DateTime currentDate = DateTime.now();
                      DateTime previousDay = currentDate.subtract(Duration(days: 1));
                      String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
                      String formattedPreviousDay = DateFormat('yyyy-MM-dd').format(previousDay);

                      DateTime now = DateTime.now();
                      String currentTime = DateFormat('HH:mm:ss').format(now);
                      String key = rides['key'];
                      // print(rides['key']);

                      DatabaseReference rideref = reference.child('Rides/${key}');

                      String rideDate = (await rideref.child('date').once()).snapshot.value.toString();
                      String rideTime = (await rideref.child('time').once()).snapshot.value.toString();

                      // Check additional conditions
                      if (rideTime == "5:30 pm") {
                        if (formattedCurrentDate.compareTo(rideDate) == 0 && currentTime.compareTo("13:00:00") < 0 ||
                            formattedCurrentDate.compareTo(rideDate) < 0) {
                          // Data to update in the 'users' field of the specific ride
                          Map<String, dynamic> userData = {
                            'email': uemail,
                            'status': 'pending',
                          };
                          // Update the 'users' field of the specific ride
                          ridesreference.child(key).child('users').push().set(userData);
                        }
                      }
                      else if (rideTime == "7:30 am") {
                        if (formattedCurrentDate.compareTo(rideDate) < 0 && currentTime.compareTo("22:00:00") < 0) {
                          // Data to update in the 'users' field of the specific ride
                          Map<String, dynamic> userData = {
                            'email': uemail,
                            'status': 'pending',
                          };

                          // Update the 'users' field of the specific ride
                          ridesreference.child(key).child('users').push().set(userData);
                        }
                      } else {
                        // Main conditions not met, show snackbar
                        showSnackBar("You can't add this ride anymore.", Colors.red);
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.deepPurple[700],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

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

        //print(rideTime);
        //print(rideDate);
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
  void initState(){
    super.initState();
    dbRef1 = FirebaseDatabase.instance.ref().child('Rides');
    checkAndMoveRidesToHistory().then((_) {
      // After filtering, update the state to rebuild the widget with the new data
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Available Rides", style: TextStyle(color: Colors.white)),
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
        )
    );
  }

  void showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}