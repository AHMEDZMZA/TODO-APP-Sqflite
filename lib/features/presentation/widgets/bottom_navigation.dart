import 'package:flutter/material.dart';
import '../view/archive_view.dart';
import '../view/completed_view.dart';
import '../view/home_view.dart';
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  List<Widget> pages = [
    const HomeView(),
    const CompletedView(),
    const ArchiveView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.orange.shade600,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: "Completed"),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive), label: "Archive"),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
