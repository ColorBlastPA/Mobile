import 'package:color_blast/Page/messaging_pro_page.dart';
import 'package:color_blast/Page/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'messagin_page.dart';

class NavigationProPage extends StatefulWidget {
  const NavigationProPage({Key? key}) : super(key: key);

  @override
  State<NavigationProPage> createState() => _NavigationProPageState();
}

class _NavigationProPageState extends State<NavigationProPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MessagingProPage(),
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
              icon: Icon(Icons.message),
              label: 'Messagerie',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
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
