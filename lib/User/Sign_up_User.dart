import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomePageUser.dart';

class Sign_up_User extends StatefulWidget {
  const Sign_up_User({super.key});


  @override
  State<Sign_up_User> createState() => _Sign_up_UserState();
}


class _Sign_up_UserState extends State<Sign_up_User> {
  GlobalKey<FormState> mykey = GlobalKey();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Sign-up Page", style: TextStyle(color: Colors.white)),
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
                        controller: usernamecontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ('Username is required !');
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Username',
                            icon: Icon(Icons.person)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                          RegExp regex=RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                          var passNonNullValue=PassCurrentValue??"";
                          if(passNonNullValue.isEmpty){
                            return ("Password is required");
                          }
                          else if(passNonNullValue.length<6){
                            return ("Password Must be more than 5 characters");
                          }
                          else if(!regex.hasMatch(passNonNullValue)){
                            return ("Password should contain lower characters and digits");
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
                    onPressed: (){
                       if (mykey.currentState!.validate()) {
                             Navigator.pushReplacement(context,
                                 MaterialPageRoute(builder: (context) => const HomePageUser()));
                       }
                    },
                    child: const Text("Sign up", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        )
    );
  }

}