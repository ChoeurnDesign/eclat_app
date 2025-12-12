import 'package:flutter/cupertino.dart';
import '../widgets/home_navbar.dart';
import '../widgets/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: null,
      child: Column(
        children: [
          HomeNavbar(),
          Expanded(
            child: HomeBody(),
          ),
        ],
      ),
    );
  }
}