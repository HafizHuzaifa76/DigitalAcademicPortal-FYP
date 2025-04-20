import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String identifier, String password); // Now returns role
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> login(String identifier, String password) async {
    try {
      String email = identifier;

      // If it's not an email, assume it's a roll number and find the email
      if (!identifier.contains('@')) {
        QuerySnapshot userSnapshot = await _firestore
            .collectionGroup('students')
            .where('rollNo', isEqualTo: identifier)
            .limit(1)
            .get();

        if (userSnapshot.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No student found with that roll number.',
          );
        }

        email = userSnapshot.docs.first.get('email');
      }
      checkIfEmailExists(email);
      // Sign in with email
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Check for role
      final user = _auth.currentUser!;
      final uid = user.uid;
      List<String> parts = user.displayName!.split(' | ');
      String userRole = parts[0];
      String userDept = parts[1];

      // 1. Check if admin (based on UID)
      final adminDoc = await _firestore.collection('admins').doc(uid).get();
      if (adminDoc.exists) return 'admin';

      if (userRole.contains('student')) return 'studentDashboard';

      if (userRole.contains('teacher')) return 'teacherDashboard';

      // If no role matched
      return 'admin';
    } catch (e) {
      print('login error: $e');
      throw e;
    }
  }

  Future<void> checkIfEmailExists(String email) async {
    try {
      // Fetch the sign-in methods for the email
      List<String> signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);

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
