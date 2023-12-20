import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:collection/collection.dart';
import 'ListOfAcceptedUsers.dart';
import 'package:intl/intl.dart';

class RideUsersAppliedPage extends StatefulWidget {
  final String pageKey;

  RideUsersAppliedPage({Key? key, required this.pageKey}) : super(key: key);

  @override
  State<RideUsersAppliedPage> createState() => _RideUsersAppliedPageState();
}

class _RideUsersAppliedPageState extends State<RideUsersAppliedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference reference = FirebaseDatabase.instance.ref();

  List<String> userEmails = [];
  Map<dynamic, dynamic>? usersData;

  @override
  void initState() {
    super.initState();
    fetchUserEmails();
  }

  Future<void> fetchUserEmails() async {
    userEmails.clear();
    try {
      // Use DataSnapshot from DatabaseEvent.snapshot
      DatabaseEvent event = await reference.child('Rides/${widget.pageKey}/users').once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        usersData = snapshot.value as Map<dynamic, dynamic>?;
        print("usersData: $usersData");

        if (usersData != null) {
          usersData!.forEach((userKey, userData) {
            String userEmail = userData['email'];
            userEmails.add(userEmail);
          });
        }
      }
      // Update the UI after fetching user emails
      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Users' Requests",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Display the fetched user emails in cards
          if (userEmails.isNotEmpty)
            ...userEmails.map(
                  (userEmail) => Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(userEmail),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DatabaseReference rideUsersReference = reference.child('Rides/${widget.pageKey}/users');
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
                            // Find the user with the current userEmail
                            var userEntry = usersData?.entries.firstWhereOrNull(
                                  (entry) => entry.value['email'] == userEmail,
                            );

                            DatabaseReference rideref = reference.child('Rides/${widget.pageKey}');

                            String rideDate = (await rideref.child('date').once()).snapshot.value.toString();
                            String rideTime = (await rideref.child('time').once()).snapshot.value.toString();


                            // print("Comparing formattedCurrentDate: $formattedCurrentDate with rideDate: $rideDate & $rideTime");
                            // print("Comparing currentTime: $currentTime with rideTime: $rideTime");

                            // Check additional conditions
                            if (rideTime == "5:30 pm") {
                              if (formattedCurrentDate.compareTo(rideDate) == 0 && currentTime.compareTo("16:30:00") < 0||
                                  formattedCurrentDate.compareTo(rideDate) < 0) {
                                // Additional conditions met, proceed with the update
                                if (userEntry != null) {
                                  // Update the status to "Rejected"
                                  await rideUsersReference.child(userEntry.key).update({'status': 'Accepted'});
                                  print('User status updated to Accepted');
                                  // Refresh the user emails
                                  await fetchUserEmails();
                                }
                              }
                            }
                            else if (rideTime == "7:30 am") {
                              if (formattedCurrentDate.compareTo(rideDate) < 0 && currentTime.compareTo("23:30:00") < 0) {
                                // Additional conditions met, proceed with the update
                                if (userEntry != null) {
                                  // Update the status to "Rejected"
                                  await rideUsersReference.child(userEntry.key).update({'status': 'Accepted'});
                                  print('User status updated to Accepted');
                                  // Refresh the user emails
                                  await fetchUserEmails();
                                }
                              }
                            }
                            else {
                              // Main conditions not met, show snackbar
                              showSnackBar("You can't accept any users anymore.", Colors.red);
                            }
                          },
                          child: Text('Accept'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            DatabaseReference rideUsersReference = reference.child('Rides/${widget.pageKey}/users');

                            // Find the user with the current userEmail
                            var userEntry = usersData?.entries.firstWhereOrNull(
                                  (entry) => entry.value['email'] == userEmail,
                            );

                            if (userEntry != null) {
                              // Update the status to "Accepted"
                              await rideUsersReference.child(userEntry.key).update({'status': 'Rejected'});
                              print('User status updated to Rejected');
                              // Refresh the user emails
                              await fetchUserEmails();
                            }
                          },
                          child: Text('Reject'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListOfAcceptedUsers(pageKey: widget.pageKey),),
                );
              },

              child: Text('List of Accepted Users'))
        ],
      ),
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
