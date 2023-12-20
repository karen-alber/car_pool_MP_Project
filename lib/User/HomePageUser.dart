import 'package:car_pool/LogoutPage.dart';
import 'package:flutter/material.dart';
import 'MyCartPage.dart';
import 'ProfilePage.dart';
import 'UserHistoryPage.dart';
import 'AvailableRidesPage.dart';


class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});
  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<Widget> _screens= [
    AvailableRidesPage(),
    MyCartPage(),
    UserHistoryPage(),
    ProfilePage(),
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
                label: 'Home',
                backgroundColor: Colors.deepPurple,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
                backgroundColor: Colors.deepPurple,
              ),
              BottomNavigationBarItem(
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