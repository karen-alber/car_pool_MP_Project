import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomePageDriver.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:car_pool/database_helper.dart';


class Sign_up_Driver extends StatefulWidget {
  const Sign_up_Driver({super.key});


  @override
  State<Sign_up_Driver> createState() => _Sign_up_DriverState();
}


class _Sign_up_DriverState extends State<Sign_up_Driver> {
  GlobalKey<FormState> mykey = GlobalKey();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  bool loading = false;
  late DatabaseReference dbRef;

  mydatabaseclass mydb = mydatabaseclass();
  List<Map> mylist = [];

  Future Reading_Database() async {
    List<Map> response = await mydb.reading('''SELECT * FROM 'TABLE' ''');
    mylist = [];
    mylist.addAll(response);
    setState(() {});
  }


  @override
  void initState(){
    Reading_Database();
    super.initState();
    mydb.checking();
    dbRef = FirebaseDatabase.instance.ref().child('Drivers');
  }

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
                        controller: namecontroller,
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
                         validator: (Value) {
                           RegExp regex = RegExp(r'^[a-zA-Z0-9]+@eng\.asu\.edu\.eg$');
                           var mailNonNullValue=Value??"";
                          if(mailNonNullValue.isEmpty){
                            return ("Email is required");
                          }
                          else if(!regex.hasMatch(mailNonNullValue)){
                            return ("You must use your faculty mail !");
                          }
                          return null;
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
                          else if(passNonNullValue.length<8){
                            return ("Password Must be more than 8 characters");
                          }
                          else if(!regex.hasMatch(passNonNullValue)){
                            return ("Try using lower characters and digits");
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
                    onPressed: () async {
                      if (mykey.currentState!.validate()) {
                        Map<String, String> Drivers = {
                          'name': namecontroller.text,
                          'email': emailcontroller.text,
                          'password': passwordcontroller.text,
                        };
                        dbRef.push().set(Drivers);
                        setState(() {});

                        await mydb.writing('''INSERT INTO 'TABLE' 
          ('EMAIL', 'NAME', 'PASSWORD', 'TYPE') VALUES ("${emailcontroller.text}","${namecontroller.text}","${passwordcontroller.text}","Driver") ''');
                        Reading_Database();
                        setState(() {});

                        final auth = FirebaseAuth.instance;
                        auth.createUserWithEmailAndPassword(email: emailcontroller.text, password: passwordcontroller.text).then((value){
                          Navigator.pushReplacementNamed(context, '/driverHomePageDriver');
                        }).onError((error, stackTrace){
                          print("Error ${error.toString()}");
                        });

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