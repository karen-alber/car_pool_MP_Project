import 'package:flutter/material.dart';
import 'Sign_up_Driver.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'HomePageDriver.dart';



class Sign_in_Driver extends StatefulWidget {
  const Sign_in_Driver({super.key});
  @override
  State<Sign_in_Driver> createState() => _Sign_in_DriverState();
}


class _Sign_in_DriverState extends State<Sign_in_Driver> {
  GlobalKey<FormState> mykey = GlobalKey();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Sign-in Page", style: TextStyle(color: Colors.white)),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const CircleAvatar(
              radius: 150,
              backgroundImage: AssetImage('images/Capture.PNG'),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: mykey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ('Email is required !');
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                          icon: Icon(Icons.email)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordcontroller,
                      validator: (PassCurrentValue){
                        var passNonNullValue=PassCurrentValue??"";
                        if(passNonNullValue.isEmpty){
                          return ("Password is required");
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                          icon: Icon(Icons.lock_outline)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
            ),
            ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
              onPressed: () {
               final auth = FirebaseAuth.instance;
               final email = emailcontroller.text;
               final password = passwordcontroller.text;
               if (mykey.currentState!.validate()) {
                 // Attempt to sign in with email and password
                 auth.signInWithEmailAndPassword(
                     email: email, password: password).then((value) {
                   // Authentication successful, now check the database
                   DatabaseReference driversReference = FirebaseDatabase
                       .instance.ref().child('Drivers');
                   driversReference
                       .orderByChild('email')
                       .equalTo(email)
                       .once()
                       .then((DatabaseEvent event) {
                     DataSnapshot snapshot = event.snapshot;

                     // Check if the snapshot value is not null and is of type Map
                     if (snapshot.value != null && snapshot.value is Map) {
                       // Cast the snapshot value to Map<dynamic, dynamic>
                       Map<dynamic, dynamic> driversData = snapshot
                           .value as Map<dynamic, dynamic>;

                       bool isdriverFound = false;

                       // Iterate over each driver to find a match for email and password
                       driversData.forEach((key, driver) {
                         if (driver is Map && driver['password'] == password) {
                           isdriverFound = true;
                         }
                       });

                       if (isdriverFound) {
                         // Email and password match found, navigate to the home page
                         Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(
                               builder: (context) => const HomePageDriver()),
                         );
                       } else {
                         // No matching email and password found
                         print("Invalid email or password");
                         showSnackBar("Invalid email or password", Colors.red);
                       }
                     } else {
                       // Handle the case where the snapshot value is null or not of type Map
                       print("Invalid data structure received from Firebase");
                       showSnackBar(
                           "Error fetching data from the database", Colors.red);
                     }
                   }).onError((error, stackTrace) {
                     // Handle errors in the database query
                     print("Database query error: $error");
                     showSnackBar("Error querying the database", Colors.red);
                   });
                 }).onError((error, stackTrace) {
                   // Authentication sign-in error
                   print("Sign-in error: $error");
                   showSnackBar(
                       "No matching email and password found", Colors.red);
                 });
               }
              },

                child: const Text("Sign in", style: TextStyle(color: Colors.white)),
            ),
            signUpOption(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      )
    );
  }
  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?", style: TextStyle(color: Colors.purple)),
        GestureDetector(onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Sign_up_Driver()));
        },
        child: const Text("Sign Up", style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),
        ),
        )
      ],
    );
  }

  // Add this function to show a snackbar message
  void showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}