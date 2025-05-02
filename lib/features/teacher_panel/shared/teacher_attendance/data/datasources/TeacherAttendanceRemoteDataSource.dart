import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/TeacherAttendance.dart';

abstract class TeacherAttendanceRemoteDataSource {
  Future<List<TeacherAttendance>> getTeacherAttendance();
}

class TeacherAttendanceRemoteDataSourceImpl implements TeacherAttendanceRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<TeacherAttendance>> getTeacherAttendance() async {
    // Implementation will go here
    throw UnimplementedError();
  }
}