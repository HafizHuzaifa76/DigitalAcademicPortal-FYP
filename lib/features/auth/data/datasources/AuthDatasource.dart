// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/shared/presentation/pages/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> login(String identifier, String password) async {
    try {
      // Check if the identifier is an email
      if (identifier.contains('@')) {
        checkIfEmailExists(identifier);
        // Assume it's an email and try to sign in
        await _auth.signInWithEmailAndPassword(
          email: identifier,
          password: password,
        );
      } else {
        // Assume it's a roll number and look up the email in Firestore
        QuerySnapshot userSnapshot = await _firestore
            .collection('students')
            .where('rollNo', isEqualTo: identifier)
            .limit(1)
            .get();

        if (userSnapshot.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found with that roll number.',
          );
        }

        // Get the email associated with the roll number
        String email = userSnapshot.docs.first.get('email');

        // Sign in with the associated email
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

      }
    } catch (e) {
      // Handle errors, such as user-not-found, wrong-password, etc.
      throw e;
    }
  }

  Future<void> checkIfEmailExists(String email) async {
    try {
      // Fetch the sign-in methods for the email
      List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // If the list is not empty, the email is registered
      print(signInMethods.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        // Handle the case where the email is invalid
        print('The email address is badly formatted.');
      } else {
        // Handle other errors, such as network issues
        print('An error occurred: ${e.message}');
      }
    }
  }
}
