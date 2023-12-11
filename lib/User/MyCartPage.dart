import 'package:flutter/material.dart';
import 'OrderDetailsPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class MyCartPage extends StatefulWidget {
  const MyCartPage({Key? key}) : super(key: key);
  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Cart');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Cart');

  TextEditingController namecontroller = TextEditingController();
  TextEditingController fromcontroller = TextEditingController();
  TextEditingController tocontroller = TextEditingController();
  TextEditingController numcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();


  // ?? ''

  Widget listItem({required Map cart}) {
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
              'From: ' + (cart['from']),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'To: ' + (cart['to']),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    namecontroller.text = cart['drivername'].toString();
                    fromcontroller.text = cart['from'].toString();
                    tocontroller.text = cart['to'].toString();
                    numcontroller.text = cart['num'].toString();
                    timecontroller.text = cart['time'].toString();

                    Navigator.pushNamed(context,
                        '/userOrderDetailsPage',arguments: {
                          'Name':namecontroller.text, 'Num': numcontroller.text,'From': fromcontroller.text,
                          'To': tocontroller.text, 'Time': timecontroller.text,});

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
                    reference.child(cart['key']).remove();
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("My Cart", style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          height: double.infinity,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

              Map cart = snapshot.value as Map;
              cart['key'] = snapshot.key;

              return listItem(cart: cart);

            },
          ),
        )
    );
  }
}
