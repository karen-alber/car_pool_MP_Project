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

  DatabaseReference reference = FirebaseDatabase.instance.reference().child('Rides');

  TextEditingController namecontroller = TextEditingController();
  TextEditingController fromcontroller = TextEditingController();
  TextEditingController tocontroller = TextEditingController();
  TextEditingController numcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();

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

                    Navigator.pushNamed(context, '/userOrderDetailsPage', arguments: {
                      'Name': namecontroller.text,
                      'Num': numcontroller.text,
                      'From': fromcontroller.text,
                      'To': tocontroller.text,
                      'Time': timecontroller.text,
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
                  onTap: () {
                    reference.child(rides['key']).remove();
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

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

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
            Map rides = snapshot.value as Map;
            rides['key'] = snapshot.key;

            // Check if the user's email exists in the 'users' section of the ride
            bool isUserInRide = (rides['users'] as Map?)?.values.any((userData) =>
            userData is Map &&
                userData.containsKey('email') &&
                userData['email'] == user?.email
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
