import 'package:flutter/cupertino.dart';
import '../core/routes/app_routes.dart'; // ✅ NO SPACE before .dart
import '../core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'ÉCLAT',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes. onGenerateRoute,
    );
  }
}