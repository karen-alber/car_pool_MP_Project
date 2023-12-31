import 'package:car_pool/Driver/DriverProfilePage.dart';
import 'package:car_pool/LogoutPage.dart';
import 'package:flutter/material.dart';
import 'DriverRidesPage.dart';
import 'DriverMyRidesPage.dart';
import 'DriverHistoryPage.dart';
import 'DriverProfilePage.dart';

class HomePageDriver extends StatefulWidget {
  const HomePageDriver({super.key});
  @override
  State<HomePageDriver> createState() => _HomePageDriverState();
}

class _HomePageDriverState extends State<HomePageDriver> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<Widget> _screens= [
    DriverRidesPage(),
    DriverMyRidesPage(),
    DriverHistoryPage(),
    DriverProfilePage(),
    LogoutPage(),
  ];

  void _onPageChanged(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index){
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Rides',
                backgroundColor: Colors.deepPurple,
              ),BottomNavigationBarItem(
                icon: Icon(Icons.car_rental),
                label: 'My Rides',
                backgroundColor: Colors.deepPurple,
              ),BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
                backgroundColor: Colors.deepPurple,
              ),BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.deepPurple,
              ),BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Logout',
                backgroundColor: Colors.deepPurple,
              )
            ],
            onTap: _onItemTapped,
            currentIndex: _currentIndex,
          ),
        ),
      ),
    );
  }


}