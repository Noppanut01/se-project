import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'การแจ้งเตือน',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'การแจ้งเตือน'),
              Tab(text: 'ข่าวสาร'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _buildNotificationPage(),
              _buildNewsPage(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNotificationPage() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'ไม่มีการแจ้งเตือน',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'ยังไม่มีการแจ้งเตือนใดๆ',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNewsPage() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'ยังไม่มีข่าวสาร',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'ยังไม่มีข่าวสารใดๆ',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
