import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/categories_page.dart';
import 'package:pocket_flow/screens/loading_page.dart';
import 'package:pocket_flow/services/api_services.dart';
import 'package:pocket_flow/widgets/bottom_navbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTransactionPage extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final Map<String, dynamic> category;

  const UpdateTransactionPage({
    super.key,
    required this.transaction,
    required this.category,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UpdateTransactionPageState createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState extends State<UpdateTransactionPage> {
  bool isExpense = true;
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;
  String? selectedCategoryImage;
  List<Map<String, dynamic>> categories = [];
  ApiService apiService = ApiService();
  int? userId;

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

  Future<void> _loadUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  Future<void> _deleteTransaction() async {
    await apiService.deleteTransaction(widget.transaction['id']);
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => LoadingPage(page: BottomNavbarWidget())));
  }

  @override
  void initState() {
    super.initState();
    _loadUserID();

    // Pre-fill the existing transaction data
    amountController.text = widget.transaction['amount'].toString();
    noteController.text = widget.transaction['description'];
    isExpense =
        widget.category['type'] == 'ex'; // Assuming type 'ex' is expense
    selectedCategory = widget.transaction[
        'category_name']; // Assuming category is in 'category_name'
    selectedCategoryImage = widget.transaction[
        'category_image']; // Assuming category image is in 'category_image'
  }

  Future<int> getCategoryId(String categoryName) async {
    List<Map<String, dynamic>> categories = await apiService.getCategories();

    debugPrint("Fetched categories: $categories"); // Print full response

    if (categories.isEmpty) {
      debugPrint("No categories found.");
      return 0; // Handle case where no categories exist
    }

    for (var category in categories) {
      if (category['cat_name'] == categoryName) {
        debugPrint("Category matched! Returning ID: ${category['id']}");
        return category['id'] ?? 0;
      }
    }

    debugPrint("Category '$categoryName' not found.");
    return 0; // Return a default value if category is not found
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = '${thaiWeekdays[selectedDate.weekday - 1]} '
        '${selectedDate.day} '
        '${thaiMonths[selectedDate.month - 1]} '
        '${selectedDate.year + 543}';

    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                    ),
                  ),
                  ToggleButtons(
                    isSelected: [isExpense, !isExpense],
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: Colors.blue,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('รายจ่าย'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('รายรับ'),
                      ),
                    ],
                    onPressed: (index) {
                      setState(() {
                        isExpense = index == 0;
                        selectedCategoryImage = null;
                        selectedCategory = null;
                      });
                    },
                  ),
                  InkWell(
                    onTap: _deleteTransaction,
                    child: Icon(Icons.delete),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F4FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formattedDate,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 28),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "0 ฿",
                        hintStyle: TextStyle(
                          color: Color(0xFFC6C6C6),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(
                          isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isExpense ? Colors.red : Colors.green,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xFFCDDDF0),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          selectedCategoryImage = null;
                          selectedCategory = null;
                        });

                        final categoryData = await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: CategoriesPage(
                                isExpense: isExpense,
                              ),
                            );
                          },
                        );

                        if (categoryData != null) {
                          setState(() {
                            selectedCategory = categoryData['cat_name'];
                            selectedCategoryImage = categoryData['img_url'];
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color(0xFFCDDDF0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 15,
                        ),
                        child: Row(
                          children: [
                            selectedCategoryImage != null
                                ? Image.asset(
                                    isExpense
                                        ? "assets/categories/expense/$selectedCategoryImage"
                                        : "assets/categories/income/$selectedCategoryImage",
                                    width: 24,
                                    height: 24)
                                : Image.asset('assets/icon/category.png',
                                    width: 24, height: 24),
                            SizedBox(width: 10),
                            Text(
                              selectedCategory ?? "เลือกหมวดหมู่",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: noteController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 18),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "เพิ่มโน้ต",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        prefixIcon: Icon(
                          Icons.note_add,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xFFCDDDF0),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCDDDF0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        String amountText = amountController.text;
                        String note = noteController.text.isEmpty
                            ? isExpense
                                ? "รายจ่าย"
                                : "รายรับ"
                            : noteController.text;

                        if (amountText.isEmpty ||
                            selectedCategory == null ||
                            selectedCategory!.isEmpty) {
                          debugPrint(
                              "Please enter the amount and select a category.");
                          return;
                        }

                        double amount = double.tryParse(amountText) ?? 0.0;

                        int? categoryId =
                            await getCategoryId(selectedCategory!);
                        try {
                          final response = await apiService.updateTransaction(
                            widget.transaction['id'],
                            amount,
                            note,
                            categoryId,
                            userId!,
                          );
                          debugPrint(
                              "Transaction updated successfully: $response");
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoadingPage(page: BottomNavbarWidget()),
                              ));
                        } catch (e) {
                          debugPrint("Failed to update transaction: $e");
                        }
                      },
                      child: Text(
                        "บันทึกการแก้ไข",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 20),
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
