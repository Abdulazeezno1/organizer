import 'package:flutter/material.dart';
import 'package:salaryplan/screens/history_screen.dart';
import 'package:salaryplan/screens/home_page.dart';
import 'package:salaryplan/screens/recurring_screen.dart';
import 'package:salaryplan/screens/wishlist_screen.dart';
import 'package:salaryplan/widget/add_salary.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    WishlistScreen(),
    RecurringScreen(),
    HistoryScreen(),
  ];
  String _getTitle() {
    if (selectedIndex == 0) return "Home";
    if (selectedIndex == 1) return "Wishlist";
    if (selectedIndex == 2) return "Recurring";
    return "History";
  }

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getTitle()), centerTitle: true),
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
          BottomNavigationBarItem(icon: Icon(Icons.repeat), label: "Recurring"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const AddSalary();
                  },
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
