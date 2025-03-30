import 'package:flutter/material.dart';

class PasswordVisibility extends StatefulWidget {
  final bool obscureText;
  final Function() onVisibilityChanged;

  const PasswordVisibility({
    super.key,
    required this.obscureText,
    required this.onVisibilityChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PasswordVisibilityState createState() => _PasswordVisibilityState();
}

class _PasswordVisibilityState extends State<PasswordVisibility> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.obscureText ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: widget.onVisibilityChanged,
    );
  }
}
