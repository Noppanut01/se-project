import 'package:flutter/material.dart';

class SummaryExpenseWidget extends StatelessWidget {
  final double width;
  final double height;
  final Widget title1;
  final Widget title2;
  final Widget tabName1;
  final Widget tabName2;
  final Widget? content1;
  final Widget? content2;
  final Color bodyColor;
  final Color tabColor;
  final Color bgTabColor;

  const SummaryExpenseWidget({
    super.key,
    required this.width,
    required this.height,
    required this.title1,
    required this.title2,
    required this.tabName1,
    required this.tabName2,
    required this.bodyColor,
    required this.tabColor,
    required this.bgTabColor,
    this.content1,
    this.content2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              width: width * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title1,
                  title2,
                ],
              ),
            ),
            Container(
              width: width * 0.9,
              height: height * 0.4,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: bodyColor,
              ),
              child: Column(
                children: [
                  Container(
                    width: width * 0.7,
                    height: width * 0.1,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: bgTabColor,
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        color: tabColor, // Box color for selected tab
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tabs: [
                        SizedBox(
                          width: width * 0.4,
                          child: tabName1,
                        ),
                        SizedBox(
                          width: width * 0.4,
                          child: tabName2,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(child: content1),
                        Center(child: content2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
