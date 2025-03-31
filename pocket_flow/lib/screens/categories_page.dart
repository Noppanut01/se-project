import 'package:flutter/material.dart';
import '../services/api_services.dart';

class CategoriesPage extends StatefulWidget {
  final bool isExpense;

  const CategoriesPage({super.key, required this.isExpense});

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<Map<String, dynamic>>> categories;

  @override
  void initState() {
    super.initState();
    categories = ApiService().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load categories'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No categories available'));
        } else {
          final filteredCategories = snapshot.data!.where((category) {
            return category['type'] == (widget.isExpense ? 'ex' : 'in');
          }).toList();

          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                SizedBox(height: 16),
                Text(
                  "เลือกหมวดหมู่",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    padding: EdgeInsets.all(16),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      var category = filteredCategories[index];
                      return categoryItem(
                        category['img_url'],
                        category['cat_name'],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget categoryItem(String imgUrl, String label) {
    String assetPath = widget.isExpense
        ? 'assets/categories/expense/$imgUrl'
        : 'assets/categories/income/$imgUrl';

    return GestureDetector(
      onTap: () {
        Navigator.pop(context, {'img_url': imgUrl, 'cat_name': label});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, width: 40, height: 40),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
