import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  late Map<String, dynamic> myReceivedData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data passed as arguments
    myReceivedData = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
            "Ride Status Tracking", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<String?>(
        future: checkRideStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Logic is completed, you can now display the result
            final status = snapshot.data;
            return Center(
              child: Text(
                "Status: ${status}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            );
          } else {
            // While waiting for the future to complete, you can show a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<String?> checkRideStatus() async {
    try {
      final User? currentUser = _auth.currentUser;

      // Get current Date
      DateTime currentDate = DateTime.now();
      // Get the previous day
      DateTime previousDay = currentDate.subtract(Duration(days: 1));
      // Format the current date and previous day to match the format in the database
      String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(
          currentDate);
      print("Current Date: $formattedCurrentDate");
      String formattedPreviousDay = DateFormat('yyyy-MM-dd').format(
          previousDay);
      print("Previous Day: $formattedPreviousDay");

      // Get the current time
      DateTime now = DateTime.now();
      // Format the current time
      String currentTime = DateFormat('HH:mm:ss').format(now);
      print("Current Time: $currentTime");


      if (currentUser != null) {
        String currentUserEmail = currentUser.email!;
        String ridekey = myReceivedData['ridekey'];

        // Get a reference to the users under the specified ridekey
        DatabaseReference usersRef = reference.child(ridekey).child('users');

        // Retrieve the snapshot of users
        DatabaseEvent snapshot = await usersRef.once();

        // Check if the snapshot has data
        if (snapshot.snapshot.value != null) {
          if (snapshot.snapshot.value is Map<dynamic, dynamic>) {
            Map<String, dynamic> users =
            Map<String, dynamic>.from(
                snapshot.snapshot.value as Map<dynamic, dynamic>);

            // Search for the entry with the current user's email
            var currentUserDataEntry = users.entries.firstWhere(
                  (entry) => entry.value['email'] == currentUserEmail,
              orElse: () => MapEntry<String, dynamic>('key', null),
            );

            // Check if currentUserData is not null
            if (currentUserDataEntry.value != null) {
              String userKey = currentUserDataEntry.key;
              // print(userKey + 'userkey');
              // Check if 'status' key exists in currentUserData
              if (currentUserDataEntry.value.containsKey('status')) {
                String? userStatus = currentUserDataEntry
                    .value['status'] as String?;

                // print(myReceivedData['Time']);
                // print(myReceivedData['Date']);

                // Check conditions for "5:30"
                if (myReceivedData['Time'] == "5:30 pm" &&
                    userStatus == "pending") {
                  if (formattedCurrentDate.compareTo(myReceivedData['Date']) ==
                      0 &&
                      currentTime.compareTo("12:00:00") > 0) {
                    // Set the status in the database to "Refused"
                    Map<String, String> statusUpdate = {
                      'status': "Auto Rejected",
                    };
                    usersRef.child(userKey).update(statusUpdate);
                    setState(() {});
                  }
                  print("User Status from 5:30 condition: $userStatus");
                  return userStatus;
                }
                else if (myReceivedData['Time'] == "7:30 am" &&
                    userStatus == "pending") {
                  if (formattedCurrentDate.compareTo(myReceivedData['Date']) <
                      0 &&
                      currentTime.compareTo("21:00:00") > 0) {
                    // Set the status in the database to "Refused"
                    Map<String, String> statusUpdate = {
                      'status': "Auto Rejected",
                    };
                    usersRef.child(userKey).update(statusUpdate);
                    setState(() {});
                  }
                  else if (formattedCurrentDate.compareTo(myReceivedData['Date']) == 0 &&
                      currentTime.compareTo("7:30:00") < 0) {
                    // Set the status in the database to "Refused"
                    Map<String, String> statusUpdate = {
                      'status': "Auto Rejected",
                    };
                    usersRef.child(userKey).update(statusUpdate);
                  }
                  print("User Status from 7:30 condition: $userStatus");
                  return userStatus;
                }
                return userStatus;
              }
              else {
                print("Error: 'status' key not found in currentUserData");
              }
            } else {
              print("Error: currentUserData is null");
            }
          }
        }
      }
    } catch (e, stackTrace) {
      print("Error fetching data: $e");
      print("StackTrace: $stackTrace");
    }
    return null;
  }
}