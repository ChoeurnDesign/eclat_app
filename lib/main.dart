import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; // ✅ NO SPACE before . dart
import 'firebase_options.dart';
import 'data/services/seeder_service.dart';
import 'data/services/cart_service.dart';
import 'data/services/wishlist_service.dart';
import 'data/services/payment_service.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Seed database if empty
    final firestore = FirebaseFirestore.instance;
    final productsSnapshot = await firestore.collection('products').limit(1).get();

    if (productsSnapshot.docs.isEmpty) {
      final seeder = SeederService();
      await seeder.runAllSeeders();
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => WishlistService()),
        ChangeNotifierProvider(create: (_) => PaymentService()),
      ],
      child: const MyApp(),
    ),
  );
}