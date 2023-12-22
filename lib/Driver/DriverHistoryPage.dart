import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';

class DriverHistoryPage extends StatefulWidget {
  const DriverHistoryPage({Key? key}) : super(key: key);

  @override
  State<DriverHistoryPage> createState() => _DriverHistoryPageState();
}

class _DriverHistoryPageState extends State<DriverHistoryPage> {
  DatabaseReference referenceRides = FirebaseDatabase.instance.ref().child('History');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uemail;

  @override
  void initState() {
    super.initState();
    getHistoryRides();
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> getHistoryRides() async {
    final User? user = _auth.currentUser;
    List<Map<String, dynamic>> userRides = [];

    if (user != null) {
      uemail = user.email;
      DataSnapshot snapshot = (await referenceRides.once()).snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> ridesData = (snapshot.value as Map<dynamic, dynamic>) ?? {};
        ridesData.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            Map<String, dynamic> ride = {...value, 'key': key.toString()};
            if (ride['email'] == uemail) {
              userRides.add(ride);
            }
          }
        });
      } else {
        print('No rides found in the database');
      }
    } else {
      print('User is not logged in');
    }

    return userRides;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("History", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getHistoryRides(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No rides found.'));
          } else {
            List<Map<String, dynamic>> userRides = snapshot.data!;

            return ListView.builder(
              itemCount: userRides.length,
              itemBuilder: (context, index) {
                return listItem(ride: userRides[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget listItem({required Map<String, dynamic> ride}) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: ' + (ride['from'] ?? ''),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'To: ' + (ride['to'] ?? ''),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Date: ' + (ride['date'] ?? ''),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
