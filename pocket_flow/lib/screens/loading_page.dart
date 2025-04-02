import 'dart:async';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  final Widget page;
  const LoadingPage({
    super.key,
    required this.page,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    navigateTo();
  }

  void navigateTo() {
    Timer(Duration(milliseconds: 300), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
