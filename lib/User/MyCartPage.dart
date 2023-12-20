import 'package:flutter/material.dart';
import 'OrderDetailsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({Key? key}) : super(key: key);

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');

  TextEditingController namecontroller = TextEditingController();
  TextEditingController fromcontroller = TextEditingController();
  TextEditingController tocontroller = TextEditingController();
  TextEditingController numcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;

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
                'From: ' + (rides['from']),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'To: ' + (rides['to']),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      namecontroller.text = rides['drivername'].toString();
                      fromcontroller.text = rides['from'].toString();
                      tocontroller.text = rides['to'].toString();
                      numcontroller.text = rides['num'].toString();
                      timecontroller.text = rides['time'].toString();
                      datecontroller.text = rides['date'].toString();

                      Navigator.pushNamed(context, '/userOrderDetailsPage', arguments: {
                        'Name': namecontroller.text,
                        'Num': numcontroller.text,
                        'From': fromcontroller.text,
                        'To': tocontroller.text,
                        'Time': timecontroller.text,
                        'Date': datecontroller.text,
                        'key': rides['key'],
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.deepPurple[700],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Get the current user
                      User? user = _auth.currentUser;
                      if (user != null) {
                        String currentUserEmail = user.email!;

                        // Assume ridekey is known or replace it with the actual ridekey
                        String ridekey = rides['key'];

                        // Get a reference to the users under the specified ridekey
                        DatabaseReference usersRef = reference.child(ridekey).child('users');

                        // Retrieve the snapshot of users
                        DatabaseEvent snapshot = await usersRef.once(); // Use DatabaseEvent

                        // Check if the snapshot has data
                        if (snapshot.snapshot.value != null) {
                          // Perform null check before converting to Map
                          if (snapshot.snapshot.value is Map<dynamic, dynamic>) {
                            Map<String, dynamic> users =
                            Map<String, dynamic>.from(snapshot.snapshot.value as Map<dynamic, dynamic>);

                            // Iterate through the keys in users
                            users.forEach((key, userData) {
                              // Check if the email matches the current user's email
                              if (userData['email'] == currentUserEmail) {
                                // Remove the user with the matching email
                                usersRef.child(key).remove();
                              }
                            });
                          }
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("My Cart", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: reference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            Map<dynamic, dynamic> rides = snapshot.value as Map<dynamic, dynamic>;
            rides['key'] = snapshot.key;

            // Check if the user's email exists in the 'users' section of the ride
            bool isUserInRide = (rides['users'] as Map?)?.values.any((userData) =>
            userData is Map &&
                userData.containsKey('email') &&
                userData['email'] == currentUser?.email
            ) ?? false;

            if (isUserInRide) {
              return listItem(rides: rides);
            } else {
              // Return an empty container if the user's email doesn't match
              return Container();
            }
          },
        ),
      ),
    );
  }
}
