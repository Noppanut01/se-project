import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/account_page.dart';
import 'package:pocket_flow/screens/add_transaction_page.dart';
import 'package:pocket_flow/screens/home_page.dart';

class BottomNavbarWidget extends StatefulWidget {
  const BottomNavbarWidget({super.key});

  @override
  State<BottomNavbarWidget> createState() => _BottomNavbarWidgetState();
}

class _BottomNavbarWidgetState extends State<BottomNavbarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Homepage(),
    SizedBox.shrink(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    if (index != 1) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void addTransaction(String name, String amount, String type) {}

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFF33363F),
            unselectedItemColor: Color.fromRGBO(0, 0, 0, 0.3),
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Account",
              ),
            ],
          ),
          Positioned(
            bottom: 35,
            left: width / 2 - (width * 0.15) / 2,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTransactionPage(),
                ),
              ),
              child: Container(
                width: width * 0.15,
                height: width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
