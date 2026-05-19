import 'package:flutter/material.dart';
import 'package:organizer/screens/home_page.dart';
import 'package:organizer/screens/wishlist_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  final List<Widget> pages = [HomePage(), WishlistScreen()];

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "WishList",
          ),
        ],
      ),
    );
  }
}
