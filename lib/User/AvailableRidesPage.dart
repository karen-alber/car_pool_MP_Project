import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'OrderDetailsPage.dart';
import 'MyCartPage.dart';
import 'ProfilePage.dart';
import 'HistoryPage.dart';


class AvailableRidesPage extends StatefulWidget {
  const AvailableRidesPage({Key? key}) : super(key: key);
  @override
  State<AvailableRidesPage> createState() => _AvailableRidesPageState();
}

class _AvailableRidesPageState extends State<AvailableRidesPage> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Rides');
  DatabaseReference ridesreference = FirebaseDatabase.instance.ref().child('Rides');
  Query usersreference = FirebaseDatabase.instance.ref().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  String? uemail;
  late DatabaseReference dbRef1;


  @override
  void initState(){
    super.initState();
    dbRef1 = FirebaseDatabase.instance.ref().child('Rides');
  }


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
                    //write here what saves this item in mycart
                    final User? user = _auth.currentUser;
                    // await dbRef1.orderByChild('key').equalTo(rides['key']).once().then((DatabaseEvent event) {
                    //   DataSnapshot snapshot = event.snapshot;
                    //   Map<dynamic, dynamic>? cartItem = snapshot.value as Map<dynamic, dynamic>?;
                    //   dbRef1.push().set(rides);
                    // });
                    if (user != null) {
                      uemail = user.email;
                      // Data to update in the 'users' field of the specific ride
                      Map<String, dynamic> userData = {
                        'email': uemail,   // Replace with the actual name
                        'status': 'pending',  // Replace with the actual status
                      };

                      // Update the 'users' field of the specific ride
                      ridesreference.child(rides['key']).child('users').push().set(userData);
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
}