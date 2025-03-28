import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/transaction_page.dart';
import 'notification_page.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ยอดเงินทั้งหมด:',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        InkWell(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationPage()),
                                ),
                            child:
                                Icon(Icons.notifications, color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$1,200',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ธุรกรรมล่าสุด',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionPage(),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFEFF1F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'ดูรายละเอียดเพิ่มเติม',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SizedBox(height: 16),
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
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              children: [
                                _buildTransactionList(),
                                _buildTransactionList(),
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
        ),
      ),
    );
  }

  ListView _buildTransactionList() {
    return ListView(
      children: [
        _buildTransactionTile(
          icon: Icons.arrow_upward,
          title: 'โอนไปยังบัญชีธนาคาร',
          subtitle: 'นายประสบ อุบัติเหตุ\n18:45 น.',
          amount: '780.00',
        ),
        Divider(height: 1, color: Colors.black26),
        _buildTransactionTile(
          icon: Icons.receipt_long,
          title: 'ชำระสินค้า/บริการ',
          subtitle: 'KMUTNB Bill\n17:00 น.',
          amount: '19,800.00',
        ),
        Divider(height: 1, color: Colors.black26),
        _buildTransactionTile(
          icon: Icons.arrow_downward,
          title: 'รับเงินจากบัญชีธนาคาร',
          subtitle: 'นางน้อย ๆ\n11:03 น.',
          amount: '41,500.00',
        ),
      ],
    );
  }

  ListTile _buildTransactionTile(
      {required IconData icon,
      required String title,
      required String subtitle,
      required String amount}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.black54),
      ),
      trailing: Text(
        '\$$amount  THB',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
