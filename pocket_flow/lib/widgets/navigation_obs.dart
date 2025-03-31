import 'package:flutter/material.dart';

class NavigationObserver extends NavigatorObserver {
  final VoidCallback onPageChanged;

  NavigationObserver({required this.onPageChanged});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    onPageChanged(); // Called when a new page is pushed
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onPageChanged(); // Called when a page is popped
  }
}
