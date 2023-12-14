import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DriverMyRidesPage extends StatefulWidget {
  const DriverMyRidesPage({Key? key}) : super(key: key);

  @override
  State<DriverMyRidesPage> createState() => _DriverMyRidesPageState();
}

class _DriverMyRidesPageState extends State<DriverMyRidesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uemail;

  @override
  void initState() {
    super.initState();
    getCurrentUserRides();
    setState() {};
  }

  Future<List<Map<String, dynamic>>> getCurrentUserRides() async {
    DatabaseReference referenceRides = FirebaseDatabase.instance.ref().child('Rides');
    final User? user = _auth.currentUser;
    List<Map<String, dynamic>> userRides = [];

    if (user != null) {
      uemail = user.email;
      print(uemail);

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
        title: const Text("Rides", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getCurrentUserRides(),
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
            Text(
              'Time: ' + (ride['time'] ?? ''),
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
                  onTap: () {
                    // Add your logic for deleting the ride
                    //reference.child(ride['key']).remove();
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

}



