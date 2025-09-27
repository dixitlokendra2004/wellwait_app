import 'package:flutter/material.dart';
import '../home_screen/home_screen_page.dart';
import '../schedule/schedule_page.dart';
import '../utils/colors.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  // List of pages to display
  final List<Widget> _pages = [
    HomeScreenPage(),
    ScheduleScreenPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70, // Set the desired height
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Schedule',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: fabricColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
