import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/notification_screen.dart';
import '../widgets/summary_expense_widget.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "฿",
                              style: TextStyle(fontSize: 35),
                            ),
                            Text(
                              "0",
                              style: TextStyle(fontSize: 35),
                            ),
                            Icon(
                              CupertinoIcons.eye_fill,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              );
                            },
                            child: Icon(
                              CupertinoIcons.bell_solid,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SummaryExpenseWidget(
                  width: width,
                  height: height,
                  title1: Text("Expense"),
                  title2: Text("More"),
                  content1: Text("Content 1"),
                  content2: Text("Content 2"),
                  tabName1: Tab(text: "Tab1"),
                  tabName2: Tab(text: "Tab2"),
                  bodyColor: Color(0xFFE4D8DC),
                  tabColor: Color(0xFFC9CCD5),
                  bgTabColor: Color(0xFFEDEDED),
                ),
                SizedBox(
                  height: 15,
                ),
                SummaryExpenseWidget(
                  width: width,
                  height: height,
                  title1: Text("Expense"),
                  title2: Text("More"),
                  content1: Text("Content 1"),
                  content2: Text("Content 2"),
                  tabName1: Tab(text: "Tab1"),
                  tabName2: Tab(text: "Tab2"),
                  bodyColor: Color(0xFFE4D8DC),
                  tabColor: Color(0xFFC9CCD5),
                  bgTabColor: Color(0xFFEDEDED),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
