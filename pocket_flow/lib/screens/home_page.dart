import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/summary_page.dart';
import 'package:pocket_flow/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_page.dart';
import 'update_transaction_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ApiService apiService = ApiService();
  int? userId;
  double _totalExpense = 0.0;

  final List<String> thaiWeekdays = [
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
    'อาทิตย์'
  ];

  final List<String> thaiMonths = [
    'ม.ค.',
    'ก.พ.',
    'มี.ค.',
    'เม.ย.',
    'พ.ค.',
    'มิ.ย.',
    'ก.ค.',
    'ส.ค.',
    'ก.ย.',
    'ต.ค.',
    'พ.ย.',
    'ธ.ค.'
  ];

  String formattedDate(DateTime selectedDate) {
    return '${thaiWeekdays[selectedDate.weekday - 1]} '
        '${selectedDate.day} '
        '${thaiMonths[selectedDate.month - 1]} '
        '${selectedDate.year + 543}';
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt('userId');

    if (mounted) {
      if (storedUserId != null) {
        setState(() {
          userId = storedUserId;
          debugPrint("Loaded userId: $userId");
        });
        await _loadTotalExpense();
      } else {
        debugPrint("No userId found in SharedPreferences!");
      }
    }
  }

  Future<void> _loadTotalExpense() async {
    if (userId == null) {
      debugPrint("User ID is null, cannot fetch total expense.");
      return;
    }
    final total = await apiService.getTotalExpense(userId!);
    debugPrint("Fetched total expense: $total");
    setState(() {
      _totalExpense = total;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Map<String, List<Map<String, dynamic>>> _groupTransactionsByDate(
      List<Map<String, dynamic>> transactions) {
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};

    for (var transaction in transactions) {
      String date =
          transaction['date']; // Assuming the date is in 'YYYY-MM-DD' format

      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    return groupedTransactions;
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
                              builder: (context) => const SummaryPage(),
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
                    SizedBox(height: 16),
                    // Displaying transactions grouped by date
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: userId != null
                          ? apiService.getTransactionsByUser(userId!)
                          : null,
                      builder: (context, snapshot) {
                        if (userId == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text('No transactions available.'));
                        } else {
                          final transactions = snapshot.data!;
                          transactions
                              .sort((a, b) => b['id'].compareTo(a['id']));
                          final groupedTransactions =
                              _groupTransactionsByDate(transactions);

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: groupedTransactions.keys.length,
                            itemBuilder: (context, index) {
                              final date =
                                  groupedTransactions.keys.elementAt(index);
                              final transactionsForDate =
                                  groupedTransactions[date]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    formattedDate(DateTime.parse(date)),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 8),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: transactionsForDate.length,
                                    itemBuilder: (context, index) {
                                      final transaction =
                                          transactionsForDate[index];
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
                                              subtitle: Text(
                                                  transaction['description']),
                                              trailing: Text(
                                                  '${transaction['amount']} THB'),
                                            );
                                          } else if (catSnapshot.hasError) {
                                            return ListTile(
                                              title: Text("Unknown Category"),
                                              subtitle: Text(
                                                  transaction['description']),
                                              trailing: Text(
                                                  '${transaction['amount']} THB'),
                                            );
                                          } else {
                                            final category = catSnapshot.data!;

                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateTransactionPage(
                                                      transaction: transaction,
                                                      category: category,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ListTile(
                                                leading: category['img_url'] !=
                                                        null
                                                    ? Image.asset(
                                                        category['type'] == 'ex'
                                                            ? "assets/categories/expense/${category['img_url']}"
                                                            : "assets/categories/income/${category['img_url']}",
                                                        width: 40,
                                                        height: 40,
                                                      )
                                                    : Icon(Icons.category,
                                                        color: Colors.black54),
                                                title:
                                                    Text(category['cat_name']),
                                                subtitle: Text(
                                                    transaction['description']),
                                                trailing: Text(
                                                  '${transaction['amount'].toStringAsFixed(2)} ฿',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        category['type'] == 'ex'
                                                            ? Colors.red
                                                            : Colors.green,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
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
