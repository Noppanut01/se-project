import 'package:flutter/material.dart';
import 'notification_page.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Summary',
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
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'ยอดใช้จ่าย',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFFF9F9F9),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: 'ดูสัปดาห์'),
                                Tab(text: 'ดูเดือน'),
                              ],
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 300,
                              child: TabBarView(
                                children: [
                                  _buildTransactionList('สัปดาห์นี้'),
                                  _buildTransactionList('เดือนนี้'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'ธุรกรรมล่าสุด',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFFF9F9F9),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: 'วันนี้'),
                                Tab(text: 'เดือนนี้'),
                              ],
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 300,
                              child: TabBarView(
                                children: [
                                  _buildTransactionList('วันนี้'),
                                  _buildTransactionList('เดือนนี้'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildTransactionList(String header) {
    return ListView(
      children: [
        Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
        TransactionItem(
          icon: Icons.account_balance_wallet_outlined,
          title: 'โอนไปยังบัญชีธนาคาร',
          subtitle: 'นายปรเมษฐ งอนวิเศษกุล\n18:45 น.',
          amount: '780.00 THB',
        ),
        Divider(),
        TransactionItem(
          icon: Icons.receipt_long_outlined,
          title: 'ชำระสินค้/บริการ',
          subtitle: 'KMUTNB Bill\n17:00 น.',
          amount: '19,800.00 THB',
        ),
        Divider(),
        TransactionItem(
          icon: Icons.account_balance_wallet_outlined,
          title: 'รับเงินจากบัญชีธนาคาร',
          subtitle: 'นายอนันต์ งอนวิเศษกุล\n11:03 น.',
          amount: '41,500.00 THB',
        ),
        Divider(),
        TransactionItem(
          icon: Icons.videogame_asset_outlined,
          title: 'เติมเงิน',
          subtitle: 'ROV',
          amount: '160.00 THB',
        ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 32),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Text(amount, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
