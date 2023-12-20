import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';

class UserHistoryPage extends StatefulWidget {
  const UserHistoryPage({super.key});

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Rides');
   @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("History", style: TextStyle(color: Colors.white)),
      ),
       body: Column(
         children: [

         ],
      ),
    );
  }

  Future<String?> fetchHistoryOfUser () async {

  }
}