import 'package:color_blast/Page/messaging_page.dart';
import 'package:color_blast/Page/profile_page.dart';
import 'package:color_blast/Page/shop_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';


class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    ShopPage(),
    MessagingPage(),
    ProfilePage(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.deepOrange,
              Colors.orange,
              Colors.orangeAccent,
            ],
          ),
        ),
        child: BottomNavigationBar(
          onTap: _onClicked,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Magasin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messagerie',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _onClicked(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }
}
