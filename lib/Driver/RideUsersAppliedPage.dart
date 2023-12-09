import 'package:flutter/material.dart';
import 'RideUsersAppliedPage.dart';

List Rides = [
  'Mohamed@eng.asu.edu.eg\n   Gate 3 , @5:30pm\n\n Abdu-Basha to Abbaseya',
  'Mohamed@eng.asu.edu.eg\n   Gate 4 , @7:30am\n\n Abbaseya to Abdu-Basha',
];

class RideUsersAppliedPage extends StatefulWidget {
  const RideUsersAppliedPage({super.key});
  @override
  State<RideUsersAppliedPage> createState() => _RideUsersAppliedPageState();
}

class _RideUsersAppliedPageState extends State<RideUsersAppliedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("My Cart", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
          itemCount: Rides.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Card(
                child: ListTile(
                  onTap: () {
                    print('you pressed on ${Rides[index]}');
                  },
                  title: Text(Rides[index]),
                  trailing: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            //write here status code
                          },
                          icon: const Icon(Icons.check_box_outlined)),
                      IconButton(
                          onPressed: () {
                            //write here status code
                          },
                          icon: const Icon(Icons.delete_rounded)),
                    ],
                  ),
                ),

              ),
            );}
      ),
    );
  }

}