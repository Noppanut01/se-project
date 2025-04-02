// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/update_account_page.dart';
import 'package:pocket_flow/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_page.dart';
import 'sign_in_page.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  ApiService apiService = ApiService();
  int? userId;
  Map<String, dynamic>? user;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt('userId');

    if (storedUserId != null) {
      try {
        final fetchedUser = await apiService.getUser(storedUserId);
        setState(() {
          userId = storedUserId;
          user = fetchedUser;
          isLoading = false;
        });
      } catch (e) {
        debugPrint("Error fetching user: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  void _showExportConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการส่งออก"),
          content: Text("คุณต้องการส่งออกข้อมูลเป็นไฟล์ CSV ใช่หรือไม่?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _exportTransactionsToCSV(); // Proceed with export
              },
              child: Text("ยืนยัน"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportTransactionsToCSV() async {
    if (userId == null) {
      debugPrint("User ID is null, cannot fetch transactions.");
      return;
    }

    try {
      final transactions = await apiService.getTransactionsByUser(userId!);
      List<List<String>> data = [
        ['Date', 'Description', 'Amount'], // CSV Header
      ];

      for (var transaction in transactions) {
        data.add([
          transaction['date'] ?? 'Unknown Date',
          transaction['description'] ?? "No description",
          transaction['amount'] != null
              ? transaction['amount'].toString()
              : '0.00',
        ]);
      }

      String csvData = const ListToCsvConverter().convert(data);

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/transactions.csv');

      await file.writeAsString(csvData);

      debugPrint("CSV file saved at: ${file.path}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ส่งออกข้อมูลสำเร็จ")),
      );
    } catch (e) {
      debugPrint("Error exporting transactions: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาดในการส่งออกข้อมูล")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.1,
                color: Colors.white,
                child: isLoading
                    ? Center(child: CircularProgressIndicator()) // Show loading
                    : user != null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "บัญชีคุณ ",
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${user!['username']}",
                                      style: TextStyle(
                                          fontSize: 23, color: Colors.black54),
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NotificationPage(),
                                    ),
                                  ),
                                  child: Icon(Icons.notifications),
                                ),
                              ],
                            ),
                          )
                        : Text("ไม่พบข้อมูลผู้ใช้"),
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "ตั้งค่าการใช้งาน",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateAccountPage(
                            user: user,
                          )),
                ),
                child: Container(
                  color: Color(0xFFF6F3FA),
                  height: MediaQuery.of(context).size.height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "บัญชี",
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "รายการที่จดไว้",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: _showExportConfirmationDialog,
                child: Container(
                  color: Color(0xFFF6F3FA),
                  height: MediaQuery.of(context).size.height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ส่งออกข้อมูล",
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: TextButton(
                  onPressed: _logout,
                  child: Text(
                    'ออกจากระบบ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
