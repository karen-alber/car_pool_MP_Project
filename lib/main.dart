import 'package:flutter/material.dart';
import 'User/HomePageUser.dart';
import 'User/Sign_in_User.dart';
import 'User/Sign_up_User.dart';
import 'WelcomePage.dart';
import 'User/MyCartPage.dart';
import 'User/UserHistoryPage.dart';
import 'User/OrderDetailsPage.dart';
import 'User/OrderTrackingPage.dart';
import 'User/PaymentPage.dart';
import 'User/UserProfilePage.dart';
import 'User/AvailableRidesPage.dart';
import 'LogoutPage.dart';
import 'Driver/HomePageDriver.dart';
import 'Driver/Sign_in_Driver.dart';
import 'Driver/Sign_up_Driver.dart';
import 'Driver/RideUsersAppliedPage.dart';
import 'Driver/AddGoRidePage.dart';
import 'Driver/DriverRidesPage.dart';
import 'Driver/DriverRideChoicePage.dart';
import 'Driver/AddReturnRidePage.dart';
import 'Driver/DriverMyRidesPage.dart';
import 'Driver/ListOfAcceptedUsers.dart';
import 'Driver/DriverHistoryPage.dart';
import 'Driver/DriverProfilePage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CarPooling App",
      home: WelcomePage(),
      //const WelcomePage(),
      routes: {
        '/welcomePage': (context) => const WelcomePage(),
        '/LogoutPage': (context) =>  const LogoutPage(),

        '/userHomePageUser': (context) => const HomePageUser(),
        '/userMyCartPage': (context) => const MyCartPage(),
        '/userUserHistoryPage': (context) => const UserHistoryPage(),
        '/userOrderDetailsPage': (context) =>  const OrderDetailsPage(),
        '/userPaymentPage': (context) => const PaymentPage(),
        '/userOrderTrackingPage': (context) => const OrderTrackingPage(),
        '/userSign_in_User': (context) => const Sign_in_User(),
        '/userSign_up_User': (context) => const Sign_up_User(),
        '/userUserProfilePage': (context) => const UserProfilePage(),
        '/userAvailableRidesPage': (context) => const AvailableRidesPage(),

        '/driverHomePageDriver': (context) => const HomePageDriver(),
        '/driverSign_up_Driver': (context) => const Sign_up_Driver(),
        '/driverSign_in_Driver': (context) => const Sign_in_Driver(),
        //'/driverRideUsersAppliedPage': (context) =>  const RideUsersAppliedPage(),
        '/driverAddGoRidePage': (context) => const AddGoRidePage(),
        '/driverAddReturnRidePage': (context) => const AddReturnRidePage(),
        '/driverDriverRideChoicePage': (context) => const DriverRideChoicePage(),
        '/driverDriverRidesPage': (context) => const DriverRidesPage(),
        '/driverDriverMyRidesPage': (context) => const DriverMyRidesPage(),
        '/driverDriverHistoryPage': (context) => const DriverHistoryPage(),
        '/driverDriverProfilePage': (context) => const DriverProfilePage(),
        //'/listOfAcceptedUsers': (context) => const ListOfAcceptedUsers(),

      },
    );
  }
}