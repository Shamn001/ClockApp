import 'package:clock1/screens/home.dart';
import 'package:clock1/screens/swatch.dart';
import 'package:clock1/screens/timer.dart';
import 'package:clock1/screens/wclock.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  final List<Widget> _screen =[
    HomeScreen(),
    Wclock(),
    Swatch(),
    Timer()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(enableFeedback: false,
        selectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex=index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm),label: 'Alarm'),
          BottomNavigationBarItem(icon: Icon(Icons.lock_clock),label: 'World clock'),
          BottomNavigationBarItem(icon: Icon(Icons.timer_sharp),label: 'Stopwatch'),
          BottomNavigationBarItem(icon: Icon(Icons.timer_10),label: 'Timer')
        ],
        ),
    );
  }
}