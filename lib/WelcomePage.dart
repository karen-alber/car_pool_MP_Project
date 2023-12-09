import 'package:car_pool/Driver/Sign_in_Driver.dart';
import 'package:flutter/material.dart';
import 'User/Sign_in_User.dart';

class WelcomePage extends StatefulWidget{
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Car Pooling App", style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Padding(
         padding: const EdgeInsets.all(20),
         child: ListView(
           children: [
             const CircleAvatar(radius: 150, backgroundImage: AssetImage('images/Capture.PNG'),),
             const SizedBox(height: 20,),
             const Text("Welcome in our Car Pooling App !", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,), textAlign: TextAlign.center,),
             const SizedBox(height: 60,),
             const Text("Please Sign in to our app whether you are a Driver or a User", style: TextStyle(fontSize: 10,),textAlign: TextAlign.center,),
             Row(
               children: [
                 const SizedBox(width: 60,),
                 ElevatedButton(
                   onPressed: (){
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Sign_in_Driver()));
                     },
                   style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
                   child: const Text("Driver", style: TextStyle(color: Colors.white)),
                 ),
                 const SizedBox(width: 60,),
                 ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Sign_in_User()));
                    },
                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
                    child: const Text("User", style: TextStyle(color: Colors.white)),
                 ),
               ],
               ),
           ]
         ),
       )
    );
  }
}

