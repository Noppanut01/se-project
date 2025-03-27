// import 'package:flutter/material.dart';

// import 'transaction_detail_page.dart';

// // import 'transaction_detail_page.dart';

// class TransactionPage extends StatelessWidget {
//   const TransactionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return SafeArea(
//       bottom: false,
//       child: Scaffold(
//         body: Column(
//           children: [
//             Container(
//               width: width,
//               height: height * 0.08,
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//               ),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Container(
//                   width: width * 0.12,
//                   height: width * 0.12,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                   ),
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25.0),
//                         ),
//                       ),
//                       hint: Text('Filter 1'),
//                       items: <String>['Option 1', 'Option 2', 'Option 3']
//                           .map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         // Handle change
//                       },
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25.0),
//                         ),
//                       ),
//                       hint: Text('Filter 2'),
//                       items: <String>['Option A', 'Option B', 'Option C']
//                           .map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         // Handle change
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 9, // Replace with the actual number of transactions
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin:
//                         EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => TransactionDetailPage()),
//                         );
//                       },
//                       child: ListTile(
//                         leading: Icon(Icons.monetization_on),
//                         title: Text('Transaction $index'),
//                         subtitle: Text('Details of transaction $index'),
//                         trailing: Text('-\$${(index + 1) * 10}'),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class TransactionPage extends StatefulWidget {
//   @override
//   _TransactionPageState createState() => _TransactionPageState();
// }

// class _TransactionPageState extends State<TransactionPage> {
//   List transactions = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchTransactions();
//   }

//   Future<void> fetchTransactions() async {
//     final response = await http
//         .get(Uri.parse('http://your-fastapi-server-ip:8000/transactions'));

//     if (response.statusCode == 200) {
//       setState(() {
//         transactions = json.decode(response.body);
//       });
//     } else {
//       throw Exception('Failed to load transactions');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text('ธุรกรรมล่าสุด',
//                 style: TextStyle(fontSize: 16, color: Colors.black)),
//           ),
//           Expanded(
//             child: transactions.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       var transaction = transactions[index];
//                       return Column(
//                         children: [
//                           _transactionTile(
//                             transaction['title'],
//                             transaction['subtitle'],
//                             transaction['time'],
//                             transaction['amount'],
//                             transaction['currency'],
//                             getIcon(transaction['icon']),
//                           ),
//                           Divider(height: 1, color: Colors.grey),
//                         ],
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   IconData getIcon(String iconName) {
//     switch (iconName) {
//       case "arrow_upward":
//         return Icons.arrow_upward;
//       case "receipt":
//         return Icons.receipt;
//       case "arrow_downward":
//         return Icons.arrow_downward;
//       default:
//         return Icons.money;
//     }
//   }

//   Widget _transactionTile(String title, String subtitle, String time,
//       String amount, String currency, IconData iconData) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: Row(
//         children: [
//           Icon(iconData, size: 24, color: Colors.black),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: TextStyle(fontSize: 16, color: Colors.black)),
//                 Text(subtitle,
//                     style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text('$amount $currency',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('ยอดเงินทั้งหมด:',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('\$1,200',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ธุรกรรมล่าสุด',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                    Row(
                      children: [
                        Text('ดูรายละเอียดเพิ่มเติม',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                        SizedBox(width: 4),
                        Icon(Icons.notifications_none,
                            size: 24, color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('วันนี้',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                height: 2,
                                width: 60,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('เดือนนี้',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                      Divider(height: 1, color: Colors.grey),
                      _transactionTile(
                          'โอนไปยังบัญชีธนาคาร',
                          'นายประสบ อุปัติเหตุ',
                          '18:45 น.',
                          '780.00',
                          'THB',
                          Icons.arrow_upward),
                      Divider(height: 1, color: Colors.grey),
                      _transactionTile('ชำระสินค้า/บริการ', 'KMUTNB Bill',
                          '17:00 น.', '19,800.00', 'THB', Icons.receipt),
                      Divider(height: 1, color: Colors.grey),
                      _transactionTile('รับเงินจากบัญชีธนาคาร', 'นางน้อย ๆ',
                          '11:03 น.', '41,500.00', 'THB', Icons.arrow_downward),
                      Divider(height: 1, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _transactionTile(String title, String subtitle, String time,
      String amount, String currency, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(iconData, size: 24, color: Colors.black),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$amount $currency',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
