// import 'package:flutter/material.dart';

// class AccountPage extends StatelessWidget {
//   const AccountPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text("Account Page", style: TextStyle(fontSize: 24))),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          leading: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          elevation: 0,
          title: Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFB0C4DE),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('ชื่อบัญชี'),
                    ),
                    Spacer(),
                    Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              Divider(),
              buildListTile(context, 'เบอร์มือถือ', '000-xxx-xx67'),
              buildListTile(context, 'วันเกิด', '...'),
              buildListTile(context, 'การจัดการข้อมูลส่วนบุคคล', '...'),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: Text('ลบบัญชี'),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('ออกจากระบบ'),
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

  Widget buildListTile(BuildContext context, String title, String subtitle) {
    return Container(
      color: Colors.grey[200],
      child: ListTile(
        title: Text(title),
        trailing: Text(subtitle),
      ),
    );
  }
}
