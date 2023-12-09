import 'package:flutter/material.dart';
import 'MyCartPage.dart';
import 'ProfilePage.dart';
import 'HistoryPage.dart';

List Rides = [
  'Mohamed@eng.asu.edu.eg\n   Gate 3 , @5:30pm\n\n Abdu-Basha to Abbaseya',
  'Wael@eng.asu.edu.eg\n   Gate 3 , @5:30pm\n\n Abdu-Basha to Abbaseya',
  'Karen@eng.asu.edu.eg\n   Gate 4 , @7:30am\n\n Abbaseya to Abdu-Basha',
  'Farid@eng.asu.edu.eg\n   Gate 3 , @5:30pm\n\n Abdu-Basha to Abbaseya',
  'Mohamed@eng.asu.edu.eg\n   Gate 4 , @7:30am\n\n Abbaseya to Abdu-Basha',
];

class AvailableRidesPage extends StatefulWidget {
  const AvailableRidesPage({super.key});
  @override
  State<AvailableRidesPage> createState() => _AvailableRidesPageState();
}

class _AvailableRidesPageState extends State<AvailableRidesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Available Rides List", style: TextStyle(color: Colors.white)),
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
                  trailing: IconButton(
                      onPressed: () {
                        //write here
                      },
                      icon: const Icon(Icons.add_circle_outline)),
                ),
              ),
            );
          }
      ),
      );
  }


}