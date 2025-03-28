import 'package:flutter/material.dart';

import 'notification_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _selectedOption = 'manage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              ),
              child: Icon(Icons.notifications, color: Colors.black),
            ),
          ),
        ],
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Noppanut',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pocket',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    DropdownButton<String>(
                      value: _selectedOption,
                      style: TextStyle(
                          color: Colors.black), // Make it look like normal text
                      underline: SizedBox(), // Remove the underline
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue!;
                        });
                      },
                      items: <String>[
                        'manage', // This should match the default value
                        'create pocket',
                        'join pocket',
                        'delete pocket'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
                SizedBox(height: 8),
                // Divider(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPocketCard('Family', 'เงินครอบครัว', '5 คน'),
                    _buildPocketCard(
                        'Ben Inc.', 'สวัสดิการอาหาร\nพนักงาน', '45 คน'),
                  ],
                ),
                SizedBox(height: 32),
                _buildSectionTitle('ตั้งค่าการใช้งาน'),
                _buildMenuItem('บัญชี'),
                _buildMenuItem('ตั้งค่าปฏิทิน'),
                _buildMenuItem('เปลี่ยนธีม'),
                _buildSectionTitle('รายการที่อดไว้'),
                _buildMenuItem('ส่งออกข้อมูล'),
                _buildSectionTitle('ใครเล่าให้ฟัง'),
                _buildMenuItem('คำถามที่เจอบ่อย'),
                _buildMenuItem('ข้อตกลงและเงื่อนไข'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPocketCard(String title, String description, String count) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(description),
          SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
