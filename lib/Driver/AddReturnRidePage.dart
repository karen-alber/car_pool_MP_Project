import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddReturnRidePage extends StatefulWidget {
  const AddReturnRidePage({super.key});

  @override
  State<AddReturnRidePage> createState() => _AddReturnRidePageState();
}

class _AddReturnRidePageState extends State<AddReturnRidePage> {
  GlobalKey<FormState> mykey = GlobalKey();
  TextEditingController gatecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController endlocationcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController numcontroller = TextEditingController();

  bool loading = false;
  late DatabaseReference dbRef;
  late DatabaseReference dbRef1;
  Query dbRef2 = FirebaseDatabase.instance.ref().child('Drivers');


  @override
  void initState(){
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Rides');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Returning from Faculty Ride", style: TextStyle(color: Colors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Form(
                key: mykey,
                child: Column(
                  children: [
                    Text("Driver Name Appear for Users:",style: TextStyle(fontWeight: FontWeight.bold),),
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
                    Text("Driver Mobile Number for Contact:",style: TextStyle(fontWeight: FontWeight.bold),),
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
                    Text("Start Trip Location:",style: TextStyle(fontWeight: FontWeight.bold),),
                    DropdownButtonFormField(
                      value: null,
                      hint: const Text('Select Gate'),
                      items: ['Gate 3', 'Gate 4'].map((gate) {
                        return DropdownMenuItem(
                          value: gate,
                          child: Text(gate),
                        );}).toList(),
                      onChanged: (value) {
                        // Handle gate selection
                        setState(() {
                          gatecontroller.text = value!;
                        });
                      },),
                    const SizedBox(
                      height: 50,
                    ),
                    Text("Destination:",style: TextStyle(fontWeight: FontWeight.bold),),
                    TextFormField(
                      controller: endlocationcontroller,
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
                    Text("Start Trip Time:",style: TextStyle(fontWeight: FontWeight.bold),),
                    DropdownButtonFormField(
                      value: null,
                      hint: const Text('Select Time'),
                      items: ['5:30 pm'].map((time) {
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
                      height: 20,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style:
                const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
                onPressed: () async{
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
                    // Insert the driver's name, email, and other ride details into the "Rides" node
                    Map<String, String> ridesData = {
                      'drivername': namecontroller.text,
                      'email': uemail ?? '',
                      'num': numcontroller.text,
                      'from': gatecontroller.text,
                      'to': endlocationcontroller.text,
                      'time': timecontroller.text,
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

