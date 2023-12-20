import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ListOfAcceptedUsers extends StatefulWidget {
  final String pageKey;

  const ListOfAcceptedUsers({Key? key, required this.pageKey}) : super(key: key);

  @override
  State<ListOfAcceptedUsers> createState() => _ListOfAcceptedUsersState();
}

class _ListOfAcceptedUsersState extends State<ListOfAcceptedUsers> {
  DatabaseReference _rideUsersReference = FirebaseDatabase.instance.ref();

  List<Map<String, dynamic>> acceptedUsers = [];

  @override
  void initState() {
    super.initState();
    fetchAcceptedUsers();
  }

  Future<void> fetchAcceptedUsers() async {
    acceptedUsers.clear();

    try {
      DatabaseEvent event = await _rideUsersReference
          .child('Rides/${widget.pageKey}/users')
          .orderByChild('status')
          .equalTo('Accepted')
          .once();

      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic>? usersData = snapshot.value as Map<dynamic, dynamic>?;

        if (usersData != null) {
          usersData.forEach((userKey, userData) {
            String userEmail = userData['email'];
            String userStatus = userData['status'];

            acceptedUsers.add({'email': userEmail, 'status': userStatus});
          });
        }
      }

      setState(() {});
    } catch (e) {
      print("Error fetching accepted users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "List of Accepted Users",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: acceptedUsers.isEmpty
          ? Center(child: Text("No accepted users"))
          : ListView.builder(
        itemCount: acceptedUsers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(acceptedUsers[index]['email']),
              subtitle: Text('Status: ${acceptedUsers[index]['status']}'),
            ),
          );
        },
      ),
    );
  }
}
