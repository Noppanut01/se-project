import 'package:flutter/material.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.13,
      width: width * 0.7,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: width * 0.13,
                  height: width * 0.13,
                  decoration: BoxDecoration(
                    color: Color(0xFF33363F),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              Text("add")
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: width * 0.13,
                  height: width * 0.13,
                  decoration: BoxDecoration(
                    color: Color(0xFF33363F),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.create,
                    color: Colors.white,
                  ),
                ),
              ),
              Text("create")
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: width * 0.13,
                  height: width * 0.13,
                  decoration: BoxDecoration(
                    color: Color(0xFF33363F),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "join",
              )
            ],
          ),
        ],
      ),
    );
  }
}
