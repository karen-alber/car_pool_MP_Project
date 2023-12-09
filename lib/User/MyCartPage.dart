import 'package:flutter/material.dart';
import 'OrderDetailsPage.dart';

List Rides = [
  'Mohamed@eng.asu.edu.eg\n   Gate 3 , @5:30pm\n\n Abdu-Basha to Abbaseya',
  'Mohamed@eng.asu.edu.eg\n   Gate 4 , @7:30am\n\n Abbaseya to Abdu-Basha',
];

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});
  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
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
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const OrderDetailsPage()));
                      },
                      icon: const Icon(Icons.remove_red_eye)),
                ),

              ),
            );}
      ),
    );
  }

}