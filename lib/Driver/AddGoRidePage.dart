import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddGoRidePage extends StatefulWidget {
  const AddGoRidePage({super.key});

  @override
  State<AddGoRidePage> createState() => _AddGoRidePageState();
}

class _AddGoRidePageState extends State<AddGoRidePage> {
  GlobalKey<FormState> mykey = GlobalKey();
  TextEditingController startlocationcontroller = TextEditingController();
  TextEditingController gatecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController numcontroller = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool loading = false;
  late DatabaseReference dbRef;
  late DatabaseReference dbRef1;
  Query dbRef2 = FirebaseDatabase.instance.ref().child('Drivers');
  late DateTime now;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Rides');
    now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
  }

  // Function to get the next two dates
  List<String> getNextTwoDates() {
    DateTime currentDate = DateTime.now();
    DateTime nextDate = currentDate.add(Duration(days: 1));
    DateTime dayAfterNextDate = currentDate.add(Duration(days: 2));

    String nextDateFormatted = DateFormat('yyyy-MM-dd').format(nextDate);
    String dayAfterNextDateFormatted = DateFormat('yyyy-MM-dd').format(dayAfterNextDate);

    return [nextDateFormatted, dayAfterNextDateFormatted];
  }

  @override
  Widget build(BuildContext context) {
    List<String> nextTwoDates = getNextTwoDates();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Going to Faculty Ride", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: mykey,
              child: Column(
                children: [
                  Text("Driver Name Appear for Users:", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: namecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ('Driver Name is required !');
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Driver name',
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Driver Mobile Number for Contact:", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: numcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ('Driver Number is required !');
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mobile number',
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Start Trip Location:", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: startlocationcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ('Start Location is required !');
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Location',
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Destination:", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField(
                    value: null,
                    hint: const Text('Select Gate'),
                    items: ['Gate 3', 'Gate 4'].map((gate) {
                      return DropdownMenuItem(
                        value: gate,
                        child: Text(gate),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle gate selection
                      setState(() {
                        gatecontroller.text = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Start Trip Time:", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField(
                    value: null,
                    hint: const Text('Select Time'),
                    items: ['7:30 am'].map((time) {
                      return DropdownMenuItem(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle time selection
                      setState(() {
                        timecontroller.text = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Select Date:", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField(
                    value: null,
                    hint: const Text('Select Date'),
                    items: nextTwoDates.map((date) {
                      return DropdownMenuItem(
                        value: date,
                        child: Text(date),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle date selection
                      setState(() {
                        dateController.text = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
              onPressed: () async {
                // Fetch the snapshot from the "Drivers" node
                DatabaseEvent event = await dbRef2.once();
                // Get the snapshot from the event
                DataSnapshot snapshot = event.snapshot;

                final FirebaseAuth _auth = FirebaseAuth.instance;
                String? uemail;
                final User? user = _auth.currentUser;

                if (user != null) {
                  uemail = user.email;
                  print(uemail);

                  Map<String, String> ridesData = {
                    'drivername': namecontroller.text,
                    'email': uemail ?? '',
                    'num': numcontroller.text,
                    'from': startlocationcontroller.text,
                    'to': gatecontroller.text,
                    'time': timecontroller.text,
                    'date': dateController.text, // Use the selected date
                  };
                  dbRef.push().set(ridesData);
                }
                Navigator.pushReplacementNamed(context, '/driverHomePageDriver');
              },
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
