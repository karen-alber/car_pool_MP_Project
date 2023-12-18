import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RideUsersAppliedPage extends StatefulWidget {
  final String pageKey;

  RideUsersAppliedPage({Key? key, required this.pageKey}) : super(key: key);

  @override
  State<RideUsersAppliedPage> createState() => _RideUsersAppliedPageState();
}

class _RideUsersAppliedPageState extends State<RideUsersAppliedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference reference = FirebaseDatabase.instance.reference();

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
            print("userEmails: $userEmails");
          });
        }
      }

      // Update the UI after fetching user emails
      setState(() {});
      print("userEmails: $userEmails");
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
                child: ListTile(
                  title: Text(userEmail),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
