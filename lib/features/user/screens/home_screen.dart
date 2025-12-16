import 'package:flutter/cupertino.dart';
import '../widgets/home_navbar.dart';
import '../widgets/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scrollOffset = 0.0;

  void _updateScrollOffset(double offset) {
    if (mounted) {
      setState(() {
        _scrollOffset = offset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: null,
      child: Column(
        children: [
          HomeNavbar(scrollOffset: _scrollOffset),
          Expanded(
            child: HomeBody(
              onScrollUpdate: _updateScrollOffset,
            ),
          ),
        ],
      ),
    );
  }
}