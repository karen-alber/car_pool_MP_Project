import 'package:flutter/material.dart';
import 'OrderDetailsPage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});


  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  GlobalKey<FormState> mykey = GlobalKey();
  TextEditingController CardNumbercontroller = TextEditingController();
  TextEditingController CardUsernamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Payment Page", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("hint: you can pay here through visa/credit card or pay cash during the ride"),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text("Pay by Visa/Credit Card", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

            Form(
                key: mykey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: CardNumbercontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ('Card Number is required !');
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Card No.'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: CardUsernamecontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ('Card Username is required !');
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Card Username'),
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
                  if (mykey.currentState!.validate()) {
                    //do nothing
                  }
                },
                child: const Text("Pay", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}