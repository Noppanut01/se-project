// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocket_flow/services/api_services.dart';
import 'package:fl_chart/fl_chart.dart';

import 'notification_page.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  ApiService apiService = ApiService();
  int? userId;
  String selectedCategory = 'All'; // Default selection
  List<String> categories = []; // Placeholder for categories
  Map<int, Color> categoryColors = {};

  // Fetch the userId from shared preferences
  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    setState(() {}); // Trigger a rebuild after userId is set
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    fetchCategories(); // Fetch categories on init
  }

  void fetchCategories() async {
    List<Map<String, dynamic>> categoryData = await apiService.getCategories();
    setState(() {
      categories =
          categoryData.map((cat) => cat['cat_name'] as String).toList();
    });
  }

  // Define a list of colors for each category
  Color generateRandomColor() {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.indigo,
      Colors.lime,
      Colors.amber,
      Colors.grey,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Summary',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  // Handle notification icon tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
                child: Icon(Icons.notifications, color: Colors.black),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 250, // Define height for PieChart
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: userId != null
                        ? apiService.getTransactionsByUser(userId!)
                        : null,
                    builder: (context, snapshot) {
                      if (userId == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No transactions available.'));
                      } else {
                        Map<int, List<Map<String, dynamic>>>
                            groupedTransactions = {};
                        // Group transactions by category_id
                        for (var transaction in snapshot.data!) {
                          int categoryId = transaction['category_id'];
                          if (!groupedTransactions.containsKey(categoryId)) {
                            groupedTransactions[categoryId] = [];
                          }
                          groupedTransactions[categoryId]!.add(transaction);
                        }

                        // Prepare data for PieChart
                        List<PieChartSectionData> pieChartSections = [];
                        // Iterate through grouped transactions and prepare data
                        groupedTransactions
                            .forEach((categoryId, transactions) async {
                          double totalExpense = 0.0;
                          double totalIncome = 0.0;
                          // Calculate total expense and income for each category
                          // Fetch category details using categoryId
                          Map<String, dynamic> category =
                              await apiService.getCategoryById(categoryId);
                          for (var transaction in transactions) {
                            if (category['type'] == 'ex') {
                              totalExpense += transaction['amount'];
                            } else {
                              totalIncome += transaction['amount'];
                            }
                          }

                          // Assign a random color or a color from the predefined list
                          pieChartSections.add(
                            PieChartSectionData(
                              value: totalExpense + totalIncome,
                              color: categoryColors.putIfAbsent(
                                  categoryId, () => generateRandomColor()),
                              title: "${category['cat_name']}",
                              radius: 100,
                            ),
                          );
                        });

                        return PieChart(
                          PieChartData(
                            sections: pieChartSections,
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 1,
                            centerSpaceRadius: 10,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    DefaultTabController(
                      length: categories.length + 1,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                                8), // Add padding to make it feel more spacious
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Simple white background for minimalistic look
                              borderRadius: BorderRadius.circular(
                                  16), // Rounded corners for the container
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.1), // Light shadow for depth
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  dividerColor: Colors.transparent,
                                  isScrollable: true,
                                  labelColor: Colors
                                      .black, // Simple black color for selected tabs
                                  unselectedLabelColor: Colors.black
                                      .withOpacity(
                                          0.6), // Slightly gray for unselected
                                  indicator: BoxDecoration(
                                    color: Colors
                                        .black, // Black indicator for the selected tab
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  tabs: [
                                    Tab(
                                      child: Align(
                                        alignment: Alignment
                                            .centerLeft, // Align to the left
                                        child: Container(
                                          width: 100,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 30),
                                          decoration: BoxDecoration(
                                            color: selectedCategory == 'All'
                                                ? Colors.black
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                width: 2),
                                          ),
                                          child: Text(
                                            'All',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: selectedCategory == 'All'
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ...categories.map((category) => Tab(
                                          child: Container(
                                            width: 120,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 30),
                                            decoration: BoxDecoration(
                                              color:
                                                  selectedCategory == category
                                                      ? Colors.black
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  width: 2),
                                            ),
                                            child: Text(
                                              category,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    selectedCategory == category
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                  onTap: (index) {
                                    setState(() {
                                      selectedCategory = index == 0
                                          ? 'All'
                                          : categories[index - 1];
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
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
                              Map<int, List<Map<String, dynamic>>>
                                  groupedTransactions = {};

                              for (var transaction in snapshot.data!) {
                                int categoryId = transaction['category_id'];
                                if (!groupedTransactions
                                    .containsKey(categoryId)) {
                                  groupedTransactions[categoryId] = [];
                                }
                                groupedTransactions[categoryId]!
                                    .add(transaction);
                              }

                              return ListView.builder(
                                itemCount: groupedTransactions.length,
                                itemBuilder: (context, categoryIndex) {
                                  int categoryId = groupedTransactions.keys
                                      .elementAt(categoryIndex);
                                  List<Map<String, dynamic>> transactions =
                                      groupedTransactions[categoryId]!;

                                  return FutureBuilder<Map<String, dynamic>>(
                                    future:
                                        apiService.getCategoryById(categoryId),
                                    builder: (context, catSnapshot) {
                                      if (catSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return ListTile(
                                          title: Text("Loading category..."),
                                          subtitle: Text(
                                              'Fetching category details...'),
                                        );
                                      } else if (catSnapshot.hasError ||
                                          !catSnapshot.hasData) {
                                        return ListTile(
                                          title: Text("Unknown Category"),
                                          subtitle:
                                              Text('No details available'),
                                        );
                                      } else {
                                        final category = catSnapshot.data!;
                                        double totalExpense = 0.0;
                                        double totalIncome = 0.0;

                                        for (var transaction in transactions) {
                                          if (category['type'] == 'ex') {
                                            totalExpense +=
                                                transaction['amount'];
                                          } else {
                                            totalIncome +=
                                                transaction['amount'];
                                          }
                                        }

                                        if (selectedCategory != "All" &&
                                            category['cat_name'] !=
                                                selectedCategory) {
                                          return SizedBox
                                              .shrink(); // Hide categories that do not match
                                        }

                                        Color summaryColor =
                                            categoryColors[categoryId] ??
                                                Colors.grey;

                                        return ExpansionTile(
                                          title: Row(
                                            children: [
                                              category['img_url'] != null
                                                  ? Image.asset(
                                                      category['type'] == 'ex'
                                                          ? "assets/categories/expense/${category['img_url']}"
                                                          : "assets/categories/income/${category['img_url']}",
                                                      width: 40,
                                                      height: 40,
                                                    )
                                                  : Icon(Icons.category,
                                                      color: Colors.black),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  category['cat_name'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                category['type'] == 'ex'
                                                    ? '${totalExpense.toStringAsFixed(2)} ฿'
                                                    : '${totalIncome.toStringAsFixed(2)} ฿',
                                                style: TextStyle(
                                                  color:
                                                      summaryColor, // Set the summary color based on category type
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            ...transactions.map((transaction) {
                                              return ListTile(
                                                title: Text(
                                                    transaction['description']),
                                                trailing: Text(
                                                  '${transaction['amount']} ฿',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        summaryColor, // Use the same color for transaction amount
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
