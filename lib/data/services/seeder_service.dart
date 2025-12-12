import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeederService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Run all seeders
  Future<void> runAllSeeders() async {
    try {
      if (kDebugMode) {
        print('🔥 ========================================');
        print('🔥 FIREBASE PROJECT:  ${_firestore.app.options.projectId}');
        print('🔥 ========================================');
      }

      await seedUsers();
      await seedProducts();

      if (kDebugMode) print('✅ All seeders completed successfully!');
    } catch (e) {
      if (kDebugMode) print('❌ Error running seeders: $e');
      rethrow;
    }
  }

  // Seed initial users
  Future<void> seedUsers() async {
    try {
      if (kDebugMode) print('🌱 Starting user seeding...');

      // Check if admin already exists
      final adminQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .limit(1)
          .get();

      if (adminQuery.docs.isNotEmpty) {
        if (kDebugMode) print('⚠️ Admin already exists.  Skipping user seeding.');
        return;
      }

      // Create admin user
      await _createUser(
        email: 'admin@eclat.com',
        password: 'admin123456',
        displayName: 'Admin ÉCLAT',
        role: 'admin',
      );

      // Create test users
      await _createUser(
        email: 'user1@eclat.com',
        password: 'user123456',
        displayName: 'John Doe',
        role: 'user',
      );

      await _createUser(
        email: 'user2@eclat.com',
        password: 'user123456',
        displayName: 'Jane Smith',
        role: 'user',
      );

      await _createUser(
        email:  'alice@eclat.com',
        password: 'user123456',
        displayName:  'Alice Johnson',
        role: 'user',
      );

      if (kDebugMode) print('✅ User seeding completed!');
    } catch (e) {
      if (kDebugMode) print('❌ Error seeding users: $e');
      rethrow;
    }
  }

  // Create a single user
  Future<void> _createUser({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    try {
      // Check if user already exists in Firestore
      final existingUser = await _firestore
          . collection('users')
          .where('email', isEqualTo:  email)
          .limit(1)
          .get();

      if (existingUser.docs. isNotEmpty) {
        if (kDebugMode) print('⚠️ User already exists: $email');
        return;
      }

      // Create user with Firebase Auth
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User?  user = userCredential.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);

        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'displayName': displayName,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'photoUrl': null,
          'phoneNumber': null,
        });

        if (kDebugMode) print('✅ Created $role: $email');

        // Sign out to allow other users to be created
        await _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (kDebugMode) print('⚠️ Auth user exists: $email (checking Firestore...)');

        // User exists in Auth but maybe not in Firestore, try to add to Firestore
        try {
          final authUser = await _auth.signInWithEmailAndPassword(
            email: email,
            password:  password,
          );

          if (authUser.user != null) {
            await _firestore.collection('users').doc(authUser.user!. uid).set({
              'uid': authUser.user!.uid,
              'email': email,
              'displayName': displayName,
              'role': role,
              'createdAt': FieldValue.serverTimestamp(),
              'photoUrl': null,
              'phoneNumber': null,
            }, SetOptions(merge: true));

            if (kDebugMode) print('✅ Updated Firestore for:  $email');
            await _auth.signOut();
          }
        } catch (e) {
          if (kDebugMode) print('⚠️ Could not update Firestore for $email: $e');
        }
      } else {
        if (kDebugMode) print('❌ Error creating $email:  ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error creating $email: $e');
    }
  }

  // Seed products
  Future<void> seedProducts() async {
    try {
      if (kDebugMode) print('🌱 Starting product seeding...');

      // Check if products already exist
      final existingProducts = await _firestore
          .collection('products')
          .limit(1)
          .get();

      if (existingProducts.docs. isNotEmpty) {
        if (kDebugMode) print('⚠️ Products already exist. Skipping product seeding.');
        return;
      }

      final products = [
        {
          'name': 'Silk Scarf',
          'description': 'Luxurious silk scarf with elegant floral patterns.  Perfect for any occasion.',
          'price': 129.00,
          'category':  'Accessories',
          'stock': 25,
          'imageUrl': 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=800',
          'featured': true,
        },
        {
          'name': 'Designer Sunglasses',
          'description': 'Premium polarized sunglasses with UV protection and timeless style.',
          'price': 189.00,
          'category':  'Accessories',
          'stock': 15,
          'imageUrl': 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=800',
          'featured': true,
        },
        {
          'name':  'Leather Handbag',
          'description':  'Handcrafted genuine leather handbag with spacious compartments.',
          'price': 459.00,
          'category': 'Bags',
          'stock': 8,
          'imageUrl': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800',
          'featured': true,
        },
        {
          'name': 'Minimalist Watch',
          'description':  'Elegant minimalist watch with premium leather strap.',
          'price':  299.00,
          'category':  'Watches',
          'stock': 15,
          'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
          'featured': true,
        },
        {
          'name': 'Cashmere Sweater',
          'description': 'Ultra-soft 100% cashmere sweater in classic design.',
          'price': 249.00,
          'category':  'Clothing',
          'stock': 20,
          'imageUrl': 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800',
          'featured': false,
        },
        {
          'name': 'Gold Necklace',
          'description':  'Elegant 18k gold necklace with delicate pendant.',
          'price': 599.00,
          'category':  'Jewelry',
          'stock': 8,
          'imageUrl': 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800',
          'featured': true,
        },
        {
          'name':  'Leather Wallet',
          'description': 'Slim genuine leather wallet with RFID protection.',
          'price': 79.00,
          'category':  'Accessories',
          'stock': 30,
          'imageUrl': 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800',
          'featured': false,
        },
        {
          'name': 'Wool Coat',
          'description': 'Premium wool blend coat with timeless tailoring.',
          'price': 399.00,
          'category':  'Clothing',
          'stock': 12,
          'imageUrl': 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=800',
          'featured': true,
        },
      ];

      final batch = _firestore.batch();

      for (var product in products) {
        final docRef = _firestore.collection('products').doc();
        batch.set(docRef, {
          ... product,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (kDebugMode) print('✅ Product seeding completed!  (${products.length} products)');
    } catch (e) {
      if (kDebugMode) print('❌ Error seeding products: $e');
      rethrow;
    }
  }

  // Clear all test data (use with caution!)
  Future<void> clearTestData() async {
    try {
      if (kDebugMode) print('🗑️ Clearing test data...');

      // Delete all users (except current user)
      final usersSnapshot = await _firestore. collection('users').get();
      for (var doc in usersSnapshot.docs) {
        if (doc.id != _auth.currentUser?.uid) {
          await doc.reference.delete();
        }
      }

      // Delete all products
      final productsSnapshot = await _firestore.collection('products').get();
      for (var doc in productsSnapshot.docs) {
        await doc.reference.delete();
      }

      if (kDebugMode) print('✅ Test data cleared! ');
    } catch (e) {
      if (kDebugMode) print('❌ Error clearing test data: $e');
      rethrow;
    }
  }
}