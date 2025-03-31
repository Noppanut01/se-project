// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pocket_flow/widgets/bottom_navbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocket_flow/screens/sign_in_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _visible = true;
      });
    });

    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        final bool isLoggedIn = await _checkLoginStatus();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                isLoggedIn ? BottomNavbarWidget() : SignInPage(),
          ),
        );
      }
    });
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(seconds: 1),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/app/splash.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
