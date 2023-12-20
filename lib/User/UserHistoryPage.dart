import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHistoryPage extends StatefulWidget {
  const UserHistoryPage({super.key});

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('History');

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("History", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchHistoryOfUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<String>? rideKeys = snapshot.data;

            if (rideKeys != null && rideKeys.isNotEmpty) {
              return FirebaseAnimatedList(
                query: reference,
                itemBuilder: (context, snapshot, animation, index) {
                  DataSnapshot data = snapshot;
                  String currentRideKey = data.key.toString(); // Convert to string

                  if (rideKeys.contains(currentRideKey)) {
                    // Display ride details here (date, from, to, and drivername)
                    String date = data.child('date').value.toString();
                    String from = data.child('from').value.toString();
                    String to = data.child('to').value.toString();
                    String drivername = data.child('drivername').value.toString();

                    return Card(
                      child: ListTile(
                        title: Text("Date: $date"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("From: $from"),
                            Text("To: $to"),
                            Text("Driver: $drivername"),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // If the ride key is not in the user's accepted rides, return an empty container
                    return Container();
                  }
                },
              );
            } else {
              // If no accepted rides, display a message
              return Center(
                child: Text("No accepted rides found."),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<String>> fetchHistoryOfUser() async {
    final User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String currentUserEmail = currentUser.email!;
      List<String> acceptedRides = [];

      try {
        DatabaseReference reference = FirebaseDatabase.instance.ref().child('History');
        DatabaseEvent snapshot = await reference.once();

        // Check if the snapshot has data
        if (snapshot.snapshot.value != null) {
          // Perform null check before converting to Map
          Map<Object?, Object?>? historyData = snapshot.snapshot.value as Map<Object?, Object?>?;

          if (historyData != null) {
            historyData.forEach((rideKey, ride) {
              if (ride is Map<Object?, Object?>) {
                if (ride['users'] != null) {
                  Map<Object?, Object?>? users = ride['users'] as Map<Object?, Object?>?;

                  if (users != null) {
                    users.forEach((userKey, userData) {
                      if (userData is Map<Object?, Object?> &&
                          userData['email'] == currentUserEmail &&
                          userData['status'] == 'Accepted') {
                        acceptedRides.add(rideKey.toString());
                      }
                    });
                  }
                }
              } else {
                print("Invalid ride format for key: $rideKey");
              }
            });
          }
        }
      } catch (e) {
        print("Error fetching history data: $e");
      }

      return acceptedRides;
    } else {
      return [];
    }
  }

}
