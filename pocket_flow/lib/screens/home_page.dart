import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/summary_page.dart';
import 'package:pocket_flow/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ApiService apiService = ApiService();
  int? userId;
  double _totalExpense = 0.0;

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      debugPrint("Loaded userId: $userId");
    });
  }

  Future<void> _loadTotalExpense() async {
    if (userId == null) {
      debugPrint("User ID is null, cannot fetch total expense.");
      return;
    }
    final total = await apiService.getTotalExpense(userId!);
    debugPrint("Fetched total expense: $total");
    setState(() {
      _totalExpense = total; // Ensure it's never null
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserId().then((_) {
      _loadTotalExpense();
    });
  }

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
                          'ยอดใช่จ่าย:',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          ),
                          child: Icon(Icons.notifications, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "฿ ${_totalExpense.toStringAsFixed(2)}",
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
                            height: MediaQuery.of(context).size.height * 0.58,
                            child: TabBarView(
                              children: [
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future:
                                      apiService.getTransactionsByUser(userId!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child:
                                            Text('No transactions available.'),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child:
                                            Text('No transactions available.'),
                                      );
                                    } else {
                                      final transactions = snapshot.data!
                                        ..sort((a, b) =>
                                            b['id'].compareTo(a['id']));
                                      return ListView.builder(
                                        itemCount: transactions.length,
                                        itemBuilder: (context, index) {
                                          final transaction =
                                              transactions[index];
                                          final categoryId =
                                              transaction['category_id'];
                                          return FutureBuilder<
                                              Map<String, dynamic>>(
                                            future: apiService
                                                .getCategoryById(categoryId),
                                            builder: (context, catSnapshot) {
                                              if (catSnapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return ListTile(
                                                  title: Text("Loading..."),
                                                  subtitle: Text(transaction[
                                                      'description']),
                                                  trailing: Text(
                                                      '${transaction['amount']} THB'),
                                                );
                                              } else if (catSnapshot.hasError) {
                                                return ListTile(
                                                  title:
                                                      Text("Unknown Category"),
                                                  subtitle: Text(transaction[
                                                      'description']),
                                                  trailing: Text(
                                                      '${transaction['amount']} THB'),
                                                );
                                              } else {
                                                final category =
                                                    catSnapshot.data!;
                                                return ListTile(
                                                  leading:
                                                      category['img_url'] !=
                                                              null
                                                          ? Image.asset(
                                                              category['type'] ==
                                                                      'ex'
                                                                  ? "assets/categories/expense/${category['img_url']}"
                                                                  : "assets/categories/income/${category['img_url']}",
                                                              width: 40,
                                                              height: 40,
                                                            )
                                                          : Icon(Icons.category,
                                                              color: Colors
                                                                  .black54),
                                                  title: Text(
                                                      category['cat_name']),
                                                  subtitle: Text(transaction[
                                                      'description']),
                                                  trailing: Text(
                                                    '${transaction['amount']} THB',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: category['type'] ==
                                                              'ex'
                                                          ? Colors.red
                                                          : Colors.green,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                                Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Text('This month transactions'),
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
        ),
      ),
    );
  }
}
