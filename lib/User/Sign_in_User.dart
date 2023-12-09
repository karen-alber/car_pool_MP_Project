import 'package:flutter/material.dart';
import 'Sign_up_User.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePageUser.dart';


class Sign_in_User extends StatefulWidget {
  const Sign_in_User({super.key});
  @override
  State<Sign_in_User> createState() => _Sign_in_UserState();
}


class _Sign_in_UserState extends State<Sign_in_User> {
  GlobalKey<FormState> mykey = GlobalKey();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Sign-in Page", style: TextStyle(color: Colors.white)),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const CircleAvatar(
              radius: 150,
              backgroundImage: AssetImage('images/Capture.PNG'),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: mykey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ('Email is required !');
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                          icon: Icon(Icons.email)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordcontroller,
                      validator: (PassCurrentValue){
                        var passNonNullValue=PassCurrentValue??"";
                        if(passNonNullValue.isEmpty){
                          return ("Password is required");
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                          icon: Icon(Icons.lock_outline)),
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
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const HomePageUser()));
                },
                child: const Text("Sign in", style: TextStyle(color: Colors.white)),
            ),
            signUpOption(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      )
    );
  }
  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?", style: TextStyle(color: Colors.purple)),
        GestureDetector(onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Sign_up_User()));
        },
        child: const Text("Sign Up", style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),
        ),
        )
      ],
    );
  }

}