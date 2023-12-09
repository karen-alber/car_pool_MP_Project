import 'package:flutter/material.dart';
import 'package:car_pool/WelcomePage.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});


  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Logout Page", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
              child: ElevatedButton(
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/welcomePage');
                },
                child: const Text("Logout", style: TextStyle(color: Colors.white)),
              ),
            ),
    );
  }
}