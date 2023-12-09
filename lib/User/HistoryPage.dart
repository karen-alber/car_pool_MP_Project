import 'package:flutter/material.dart';

List Rides = [
  'Wael@eng.asu.edu.eg\n   Gate 3 , @5:30pm , 18/11/2023\n\n Abdu-Basha to Abbaseya',
  'Karen@eng.asu.edu.eg\n   Gate 4 , @7:30am , 19/11/2023\n\n Abbaseya to Abdu-Basha',
  'Farid@eng.asu.edu.eg\n   Gate 3 , @5:30pm , 16/11/2023\n\n Abdu-Basha to Abbaseya',
];

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});


  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("History", style: TextStyle(color: Colors.white)),
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
                ),

              ),
            );}
      ),
    );
  }
}