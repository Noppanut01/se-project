// import 'package:flutter/material.dart';
// import 'package:pocket_flow/screens/add_transaction_page.dart';
// import 'package:pocket_flow/screens/account_page.dart';
// import 'package:pocket_flow/screens/transaction_page.dart';

// class BottomNavbarWidget extends StatefulWidget {
//   const BottomNavbarWidget({super.key});

//   @override
//   State<BottomNavbarWidget> createState() => _BottomNavbarWidgetState();
// }

// class _BottomNavbarWidgetState extends State<BottomNavbarWidget> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     TransactionPage(),
//     SizedBox.shrink(),
//     AccountPage(),
//   ];

//   void _onItemTapped(int index) {
//     if (index != 1) {
//       // Prevents selecting the floating action button
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: _pages[_selectedIndex], // Dynamically change body content
//       bottomNavigationBar: Stack(
//         alignment: Alignment.bottomCenter,
//         clipBehavior: Clip.none,
//         children: [
//           BottomNavigationBar(
//             backgroundColor: Colors.white,
//             type: BottomNavigationBarType.fixed,
//             currentIndex: _selectedIndex,
//             onTap: _onItemTapped,
//             items: [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: "Home",
//               ),
//               BottomNavigationBarItem(
//                 icon: SizedBox.shrink(),
//                 label: "",
//               ), // Floating button space
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: "Account",
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 35,
//             left: width / 2 - (width * 0.15) / 2,
//             child: InkWell(
//               onTap: () {
//                 // Open a modal instead of navigating
//                 showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true, // Allows modal to float higher
//                   backgroundColor: Colors.transparent, // Makes modal floating
//                   builder: (context) => Padding(
//                     padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).size.height *
//                             0.2), // Adjust floating height
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(20)), // Rounded corners
//                       ),
//                       child: AddTransactionPage(), // Your modal content
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 width: width * 0.15,
//                 height: width * 0.15,
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       spreadRadius: 2,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(Icons.add, color: Colors.white, size: 30),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/add_transaction_page.dart';
import 'package:pocket_flow/screens/account_page.dart';
import 'package:pocket_flow/screens/transaction_page.dart';

class BottomNavbarWidget extends StatefulWidget {
  const BottomNavbarWidget({super.key});

  @override
  State<BottomNavbarWidget> createState() => _BottomNavbarWidgetState();
}

class _BottomNavbarWidgetState extends State<BottomNavbarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TransactionPage(),
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

  void _showFloatingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows better height control
      backgroundColor:
          Colors.transparent, // Transparent background for floating effect
      barrierColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height *
                0.115, // Lift modal above navbar
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ), // Rounded top corners
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black26,
              //     blurRadius: 10,
              //     spreadRadius: 2,
              //   ),
              // ],
            ),
            child: AddTransactionPage(), // Your modal content
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _pages[_selectedIndex], // Dynamically change body content
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
              ), // Floating button space
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
              onTap: _showFloatingModal, // Open floating modal
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
