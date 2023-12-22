import 'package:car_pool/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car_pool/database_helper.dart';
import 'package:firebase_database/firebase_database.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  mydatabaseclass mydb = mydatabaseclass();
  List<Map> mylist = [];
  String? uemail;
  late DatabaseReference dbRef;
  static String? uname;
  static String? upass;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    Reading_Database();
    dbRef = FirebaseDatabase.instance.ref().child('Users');
    setState(() {
      getOldData();
    });
  }

  Future Reading_Database() async {
    List<Map> response = await mydb.reading('''SELECT * FROM 'TABLE' WHERE EMAIL = '$uemail' ''');
    mylist = [];
    mylist.addAll(response);
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> PrintingDatabase() async {
    // Your database reading logic here
    return await mydb.queryAllRows();
  }

  Future<String?> getCurrentUser() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      uemail = user.email;
    }
    return uemail;
  }

  Future<void> updateName() async {
    await mydb.updating('''UPDATE 'TABLE' SET 'NAME' = '${nameController.text}' WHERE EMAIL = '$uemail' ''');
    Reading_Database();
    setState(() {});

    DatabaseEvent snapshot = await dbRef.once(); // Use DatabaseEvent
    // Check if the snapshot has data
    if (snapshot.snapshot.value != null) {
      // Perform null check before converting to Map
      if (snapshot.snapshot.value is Map<dynamic, dynamic>) {
        Map<String, dynamic> users =
        Map<String, dynamic>.from(snapshot.snapshot.value as Map<dynamic, dynamic>);

        // Iterate through the keys in users
        users.forEach((key, userData) {
          // Check if the email matches the current user's email
          if (userData['email'] == uemail) {
            Map<String, String> nameUpdate = {
              'name': nameController.text
            };
            // Remove the user with the matching email
            dbRef.child(key).update(nameUpdate);
            setState(() {});
          }
        });
      }
    }
  }

  Future<void> getOldData() async {

    DatabaseEvent snapshot = await dbRef.once(); // Use DatabaseEvent
    // Check if the snapshot has data
    if (snapshot.snapshot.value != null) {
      // Perform null check before converting to Map
      if (snapshot.snapshot.value is Map<dynamic, dynamic>) {
        Map<String, dynamic> users =
        Map<String, dynamic>.from(snapshot.snapshot.value as Map<dynamic, dynamic>);

        // Iterate through the keys in users
        users.forEach((key, userData) {
          // Check if the email matches the current user's email
          if (userData['email'] == uemail) {
            uname = userData['name'];
            upass = userData['password'];
            setState(() {});
          }
        });
      }
    }
  }

  Future<void> updatePassword() async {
    await mydb.updating('''UPDATE 'TABLE' SET 'PASSWORD' = '${passwordController.text}' WHERE EMAIL = '$uemail' ''');
    Reading_Database();
    setState(() {});

    DatabaseEvent snapshot = await dbRef.once(); // Use DatabaseEvent
    // Check if the snapshot has data
    if (snapshot.snapshot.value != null) {
      // Perform null check before converting to Map
      if (snapshot.snapshot.value is Map<dynamic, dynamic>) {
        Map<String, dynamic> users =
        Map<String, dynamic>.from(snapshot.snapshot.value as Map<dynamic, dynamic>);

        // Iterate through the keys in users
        users.forEach((key, userData) async {
          // Check if the email matches the current user's email
          if (userData['email'] == uemail) {
            Map<String, String> passUpdate = {
              'password': passwordController.text,
            };
            // Remove the user with the matching email
            dbRef.child(key).update(passUpdate);
            setState(() {});

            // Updating password in authentication
            User? user = _auth.currentUser;
            if (user != null) {
              // Retrieve the user's current password
              String currentPassword = userData['password'];

              // Reauthenticate the user
              AuthCredential credential = EmailAuthProvider.credential(email: uemail ?? '', password: currentPassword);
              await user.reauthenticateWithCredential(credential);

              // Update the password
              await user.updatePassword(passwordController.text);
            }
            setState(() {});
          }
        });
      }
    }
  }

  Future<void> deleteAccount() async {
    await mydb.deleting('''DELETE FROM 'TABLE' WHERE EMAIL = '$uemail' ''');

    DatabaseEvent snapshot = await dbRef.once(); // Use DatabaseEvent
    // Check if the snapshot has data
    if (snapshot.snapshot.value != null) {
      // Perform null check before converting to Map
      if (snapshot.snapshot.value is Map<dynamic, dynamic>) {
        Map<String, dynamic> users =
        Map<String, dynamic>.from(snapshot.snapshot.value as Map<dynamic, dynamic>);

        // Iterate through the keys in users
        users.forEach((key, userData) async {
          // Check if the email matches the current user's email
          if (userData['email'] == uemail) {
            // Remove the user with the matching email
            dbRef.child(key).remove();
            setState(() {});

            // Delete the user account from Firebase Authentication
            User? user = _auth.currentUser;
            if (user != null) {
              // Retrieve the user's current password
              String currentPassword = userData['password'];

              // Reauthenticate the user
              AuthCredential credential = EmailAuthProvider.credential(email: uemail ?? '', password: currentPassword);
              await user.reauthenticateWithCredential(credential);

              // Delete the user account
              await user.delete();
            }
          }
        });
      }
    }

    // Delete the user account from Firebase Authentication
    User? user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }

    Navigator.pushReplacementNamed(context, '/welcomePage');
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (context) => const WelcomePage()));
   // Close the profile page after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Profile Page", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $uemail'),
            SizedBox(height: 32),
            Text('Current Name: $uname'),
            buildEditableTextField("Name", nameController, updateName),
            SizedBox(height: 32),
            Text('Current Password: $upass'),
            buildEditableTextField("Password", passwordController, updatePassword),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: deleteAccount,
                child: Text("Delete Account"),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async{
                  List<Map<String, dynamic>> databaseData = await PrintingDatabase();
                  print("SQLite Database Data:");
                  for (var data in databaseData) {
                    data.forEach((key, value) {
                      print("$key: $value");
                    });
                  }
                },
                child: Text("Print mydb in console"),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildEditableTextField(String label, TextEditingController controller, Function() onPressed) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}
