
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/sections/data/models/SectionModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/Student.dart';
import '../models/StudentModel.dart';

abstract class StudentRemoteDataSource{
  Future<StudentModel> addStudent(StudentModel student);
  Future<void> addNewStudentsList(List<Student> morningStudents, List<Student> eveningStudents);
  Future<void> addPreviousStudentsList(List<Student> morningStudents, List<Student> eveningStudents);
  Future<StudentModel> editStudent(StudentModel student);
  Future<void> deleteStudent(String dept, String studentID);
  Future<Map<String, List<StudentModel>>> allStudents();
  Future<List<StudentModel>> getStudentsByDepartment(String deptName);
  Future<List<StudentModel>> getStudentsBySemester(String deptName, String semester);
  Future<void> setSectionLimit(String deptName, String semester, int limit);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<StudentModel> addStudent(StudentModel student) async {
    var deptRef = _firestore.collection('departments').doc(student.studentDepartment);
    var studentRef = deptRef.collection('students').doc(student.studentRollNo);
    var deptSnapshot = await deptRef.get();
    if (!deptSnapshot.exists) {
      throw Exception('Department not exists');
    }

    var studentSnapshot = await studentRef.get();
    if (studentSnapshot.exists) {
      throw Exception('Student already exists');
    }

    if(student.studentSection.isEmpty) {
      await _assignSection(student).then((assignedSection) {
        student.studentSection = assignedSection;
        print(assignedSection);
        _createStudentAccount(student);
      });
    }

    else{
      _createStudentAccount(student);
    }

    return student;
  }

  Future<void> _createStudentAccount(StudentModel student) async {
    var deptRef = _firestore.collection('departments').doc(student.studentDepartment);
    var studentRef = deptRef.collection('students').doc(student.studentRollNo);
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: student.studentEmail, password: student.studentCNIC);
    final String displayName = 'student | ${student.studentDepartment} | ${student.studentName}';

    await userCredential.user!.updateDisplayName(displayName);

    studentRef.set(student.toMap()).then((value) {
      _createCompulsoryCourseSections(student, student.studentSection);
    });
  }

  Future<void> _createCompulsoryCourseSections(StudentModel student, String sectionName) async {
    var coursesRef = _firestore.collection('departments')
        .doc(student.studentDepartment)
        .collection('semesters')
        .doc(student.studentSemester)
        .collection('courses');

    var compulsoryCoursesQuery = await coursesRef.where('courseType', isEqualTo: 'compulsory').get();

    for (var courseDoc in compulsoryCoursesQuery.docs) {
      var courseData = courseDoc.data();
      String courseId = courseDoc.id;

      var sectionRef = coursesRef.doc(courseId).collection('sections').doc(sectionName);

      await _firestore.runTransaction((transaction) async {
        var sectionSnapshot = await transaction.get(sectionRef);

        if (!sectionSnapshot.exists) {
          transaction.set(sectionRef, {
            'sectionName': sectionName,
            'shift': student.studentShift,
            'totalStudents': 1,
            'studentList': [student.studentRollNo],
          });
        } else {
          var sectionData = sectionSnapshot.data();
          List<dynamic> studentList = sectionData?['studentList'] ?? [];
          if (!studentList.contains(student.studentRollNo)) {
            studentList.add(student.studentRollNo);

            transaction.update(sectionRef, {
              'totalStudents': studentList.length,
              'studentList': studentList,
            });
          }
        }
      });
    }
  }

  Future<String> _assignSection(StudentModel student) async {
    int sectionLimit = await _getSectionLimit(student.studentDepartment, student.studentSemester);

    if (student.studentShift.toLowerCase() == 'morning') {
      return _assignToShiftSection(student.studentDepartment, student.studentSemester, 'morning', sectionLimit, student);
    } else if (student.studentShift.toLowerCase() == 'evening') {
      return _assignToShiftSection(student.studentDepartment, student.studentSemester, 'evening', sectionLimit, student);
    }

    throw Exception('Invalid student shift');
  }

  Future<int> _getSectionLimit(String deptName, String semester) async {
    var semesterRef = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    var semesterDoc = await semesterRef.get();
    return semesterDoc.data()?['sectionLimit'] ?? 30; // Default section limit is 30
  }

  Future<String> _assignToShiftSection(String deptName, String semester, String shift, int sectionLimit, StudentModel student) async {
    final sectionRef = _firestore.collection('departments').doc(deptName)
        .collection('semesters').doc(semester)
        .collection('sections');

    // Fetch the sections matching the shift outside the transaction
    var sectionQuery = await sectionRef.where('shift', isEqualTo: shift).get();

    return await _firestore.runTransaction((transaction) async {
      // Iterate through fetched sections
      for (var doc in sectionQuery.docs) {
        var sectionData = doc.data();
        int totalStudents = sectionData['totalStudents'] ?? 0;
        List<dynamic> studentList = List<dynamic>.from(sectionData['studentList'] ?? []);
        print('totalStudents $totalStudents, $sectionLimit');

        if (totalStudents < sectionLimit) {
          // Assign student to this section
          studentList.add(student.studentRollNo);

          transaction.update(doc.reference, {
            'totalStudents': totalStudents + 1,
            'studentList': studentList,
          });

          return sectionData['sectionName'];
        }
      }

      // No suitable section found, create a new one
      int nextSectionIndex = sectionQuery.docs.length + 1;
      String sectionID = (shift == 'morning') ? 'A$nextSectionIndex' : 'E$nextSectionIndex';
      String sectionName = (shift == 'morning') ? 'Morning A$nextSectionIndex' : 'Evening E$nextSectionIndex';

      final newSectionRef = sectionRef.doc(sectionName);

      // Create a new section
      transaction.set(newSectionRef, {
        'sectionID': sectionID,
        'sectionName': sectionName,
        'shift': shift,
        'totalStudents': 1,
        'studentList': [student.studentRollNo],
      });

      return sectionName;
    });
  }

  Future<String> _createNewSection(String deptName, String semester, String shift, int nextSectionIndex, StudentModel student) async {
    final sectionRef = _firestore.collection('departments').doc(deptName)
        .collection('semesters').doc(semester).collection('sections');

    String sectionID = (shift == 'morning') ? 'A$nextSectionIndex' : 'E$nextSectionIndex';
    String sectionName = (shift == 'morning') ? 'Morning A$nextSectionIndex' : 'Evening E$nextSectionIndex';

    // Start a Firestore transaction
    return await _firestore.runTransaction((transaction) async {
      // Check if the section already exists
      DocumentSnapshot sectionSnapshot = await transaction.get(sectionRef.doc(sectionName));
      if (sectionSnapshot.exists) {
        throw Exception('Section $sectionName already exists');
      }

      // Create the section data
      SectionModel section = SectionModel(
        sectionID: sectionID,
        sectionName: sectionName,
        shift: shift,
        totalStudents: 1,
        studentList: [student.studentRollNo],
      );

      // Set the section document
      transaction.set(sectionRef.doc(sectionName), section.toMap());

      return sectionName;
    });
  }

  // @override
  // Future<void> addStudentsList(List<Student> students) async {
  //   WriteBatch batch = _firestore.batch();
  //   const int sectionLimit = 30; // Maximum students per section
  //   Map<String, List<Map<String, dynamic>>> sectionDataByShift = {
  //     'Morning': [],
  //     'Evening': [],
  //   };
  //
  //   if (students.isNotEmpty) {
  //     // Fetch existing sections for both shifts
  //     var firstStudent = students.first;
  //     var sectionRef = _firestore
  //         .collection('departments')
  //         .doc(firstStudent.studentDepartment)
  //         .collection('semesters')
  //         .doc(firstStudent.studentSemester)
  //         .collection('sections');
  //
  //     var morningSections = await sectionRef.where('shift', isEqualTo: 'Morning').get();
  //     var eveningSections = await sectionRef.where('shift', isEqualTo: 'Evening').get();
  //
  //     sectionDataByShift['Morning'] = morningSections.docs.map((doc) => doc.data()).toList();
  //     sectionDataByShift['Evening'] = eveningSections.docs.map((doc) => doc.data()).toList();
  //   }
  //
  //   // Pre-fetch compulsory courses
  //   var coursesRef = _firestore
  //       .collection('departments')
  //       .doc(students.first.studentDepartment)
  //       .collection('semesters')
  //       .doc(students.first.studentSemester)
  //       .collection('courses');
  //
  //   var compulsoryCoursesQuery = await coursesRef.where('courseType', isEqualTo: 'compulsory').get();
  //
  //   // Create Firebase Auth futures for parallel execution
  //   List<Future> authFutures = [];
  //
  //   // Assign students to sections
  //   for (var currentStudent in students) {
  //     var student = StudentModel.fromStudent(currentStudent);
      // var deptRef = _firestore.collection('departments').doc(student.studentDepartment);
      // var studentRef = deptRef.collection('students').doc(student.studentRollNo);
  //
  //     // Check if the student already exists
  //     var studentSnapshot = await studentRef.get();
  //     if (studentSnapshot.exists) {
  //       throw Exception('Student with roll no ${student.studentRollNo} already exists');
  //     }
  //
  //     // Create user in Firebase Authentication
  //     authFutures.add(
  //       _auth.createUserWithEmailAndPassword(
  //         email: student.studentEmail,
  //         password: student.studentCNIC,
  //       ),
  //     );
  //
  //     String shift = student.studentShift;
  //     List<Map<String, dynamic>> sections = sectionDataByShift[shift] ?? [];
  //     String? sectionName;
  //     bool assigned = false;
  //
  //     // Assign to an existing section if space is available
  //     for (var section in sections) {
  //       int totalStudents = section['totalStudents'] ?? 0;
  //       if (totalStudents < sectionLimit) {
  //         sectionName = section['sectionName'];
  //         section['totalStudents'] = totalStudents + 1;
  //         section['studentList'] = [...(section['studentList'] ?? []), student.studentRollNo];
  //         assigned = true;
  //         break;
  //       }
  //     }
  //
  //     // If no section has space, create a new section
  //     if (!assigned) {
  //       int newSectionIndex = sections.length + 1;
  //       sectionName = (shift.toLowerCase() == 'morning') ? 'A$newSectionIndex' : 'E$newSectionIndex';
  //
  //       sections.add({
  //         'sectionName': sectionName,
  //         'shift': shift,
  //         'totalStudents': 1,
  //         'studentList': [student.studentRollNo],
  //       });
  //       sectionDataByShift[shift] = sections;
  //     }
  //
  //     // Ensure sectionName is non-null before assignment
  //     if (sectionName == null) {
  //       throw Exception('Failed to assign a section for student ${student.studentRollNo}');
  //     }
  //
  //     student.studentSection = sectionName;
  //
  //     // Add student data to Firestore batch
  //     batch.set(studentRef, student.toMap());
  //   }
  //
  //   // Update sections in Firestore
  //   for (var shift in sectionDataByShift.keys) {
  //     for (var section in sectionDataByShift[shift]!) {
  //       batch.set(
  //         _firestore
  //             .collection('departments')
  //             .doc(students.first.studentDepartment)
  //             .collection('semesters')
  //             .doc(students.first.studentSemester)
  //             .collection('sections')
  //             .doc(section['sectionName']),
  //         section,
  //         SetOptions(merge: true),
  //       );
  //     }
  //   }
  //
  //   // Add students to compulsory courses
  //   for (var courseDoc in compulsoryCoursesQuery.docs) {
  //     var courseId = courseDoc.id;
  //
  //     for (var shift in sectionDataByShift.keys) {
  //       for (var section in sectionDataByShift[shift]!) {
  //         String sectionName = section['sectionName'];
  //         List<String> studentList = section['studentList'] ?? [];
  //
  //         batch.set(
  //           coursesRef.doc(courseId).collection('sections').doc(sectionName),
  //           {
  //             'sectionName': sectionName,
  //             'shift': shift,
  //             'totalStudents': FieldValue.increment(studentList.length),
  //             'studentList': FieldValue.arrayUnion(studentList),
  //           },
  //           SetOptions(merge: true),
  //         );
  //       }
  //     }
  //   }
  //
  //   // Wait for all Firebase Authentication tasks to complete
  //   await Future.wait(authFutures);
  //
  //   // Commit Firestore batch
  //   await batch.commit();
  //
  //   print('All students added successfully using optimized section assignment.');
  // }

  @override
  Future<void> addNewStudentsList(List<Student> morningStudents, List<Student> eveningStudents) async {
    int sectionLimit = 30; // Maximum students per section
    WriteBatch batch = _firestore.batch();

    // Function to assign students to a shift
    Future<void> assignShiftStudents(List<Student> students, String shift) async {
      if (students.isEmpty) return;

      _getSectionLimit(students.first.studentDepartment, students.first.studentSemester)
          .then((value) => sectionLimit = value);

      var sectionRef = _firestore
          .collection('departments')
          .doc(students.first.studentDepartment)
          .collection('semesters')
          .doc(students.first.studentSemester)
          .collection('sections');

      // Fetch existing sections for the shift
      var sectionQuery = await sectionRef.where('shift', isEqualTo: shift).get();
      List<Map<String, dynamic>> sections = sectionQuery.docs.map((doc) => doc.data()).toList();

      var coursesRef = _firestore
          .collection('departments')
          .doc(students.first.studentDepartment)
          .collection('semesters')
          .doc(students.first.studentSemester)
          .collection('courses');

      var compulsoryCoursesQuery = await coursesRef.where('courseType', isEqualTo: 'compulsory').get();

      // If no sections exist, create the first section
      if (sections.isEmpty) {
        String initialSectionName = shift == 'Morning' ? 'Morning A1' : 'Evening E1';
        sections.add({
          'sectionName': initialSectionName,
          'shift': shift,
          'totalStudents': 0,
          'studentList': []
        });
      }

      // Prepare parallel tasks for Firebase Auth user creation
      List<Future> authFutures = [];

      // Assign students to sections
      for (var currentStudent in students) {
        var student = StudentModel.fromStudent(currentStudent);

        // Check if the student already exists
        var deptRef = _firestore.collection('departments').doc(student.studentDepartment);
        var studentRef = deptRef.collection('students').doc(student.studentRollNo);
        var deptSnapshot = await deptRef.get();
        if (!deptSnapshot.exists) {
          throw Exception('Department not exists');
        }

        var studentSnapshot = await studentRef.get();
        if (studentSnapshot.exists) {
          throw Exception('Student with roll number ${student.studentRollNo} already exists');
        }

        // Add Firebase Auth user creation task to the list
        authFutures.add(
          _auth.createUserWithEmailAndPassword(
            email: student.studentEmail,
            password: student.studentCNIC,
          ),
        );

        bool assigned = student.studentSection.isNotEmpty;
        String? sectionName = assigned ? student.studentSection : null;

        // Try to fit the student into an existing section
        if(!assigned) {
          for (var section in sections) {
            int totalStudents = section['totalStudents'] ?? 0;
            if (totalStudents < sectionLimit) {
              sectionName = section['sectionName'];
              section['totalStudents'] = totalStudents + 1;
              section['studentList'] = [
                ...(section['studentList'] ?? []),
                student.studentRollNo
              ];
              assigned = true;
              break;
            }
          }
        }

        // If no section has space, create a new section
        if (!assigned) {
          int newSectionIndex = sections.length + 1;
          sectionName = shift == 'Morning' ? 'Morning A$newSectionIndex' : 'Evening E$newSectionIndex';
          sections.add({
            'sectionName': sectionName,
            'shift': shift,
            'totalStudents': 1,
            'studentList': [student.studentRollNo]
          });
        }

        // Set the student's section
        if (sectionName == null) {
          throw Exception('Section name cannot be null');
        }

        student.studentSection = sectionName;
        batch.set(studentRef, student.toMap());

      }

      // Wait for all Firebase Auth user creation tasks to complete
      await Future.wait(authFutures);

      // Update all sections in Firestore
      for (var section in sections) {
        batch.set(
          sectionRef.doc(section['sectionName']),
          section,
          SetOptions(merge: true),
        );
      }

      // Update all sections in Firestore
      for (var courseDoc in compulsoryCoursesQuery.docs) {
        var courseId = courseDoc.id;
        var courseSectionRef = coursesRef.doc(courseId).collection('sections');

        for (var section in sections) {
          batch.set(
            courseSectionRef.doc(section['sectionName']),
            section,
            SetOptions(merge: true),
          );
        }
      }
    }

    // Assign morning and evening students
    await assignShiftStudents(morningStudents, 'Morning');
    await assignShiftStudents(eveningStudents, 'Evening');

    // Commit the batch operation
    await batch.commit();

    print('All students have been successfully assigned to sections.');
  }

  @override
  Future<void> addPreviousStudentsList(List<Student> morningStudents, List<Student> eveningStudents) async {
    WriteBatch batch = _firestore.batch();

    // Function to assign previous students to their existing sections
    Future<void> assignShiftStudents(List<Student> students, String shift) async {
      debugPrint('students: ${students.length}');
      if (students.isEmpty) return;

      var firstStudent = students.first;
      var sectionRef = _firestore
          .collection('departments')
          .doc(firstStudent.studentDepartment)
          .collection('semesters')
          .doc(firstStudent.studentSemester)
          .collection('sections');

      // Fetch existing sections for the shift
      var sectionQuery = await sectionRef.where('shift', isEqualTo: shift).get();
      Map<String, Map<String, dynamic>> sections = {
        for (var doc in sectionQuery.docs) doc.id: doc.data(),
      };

      var coursesRef = _firestore
          .collection('departments')
          .doc(firstStudent.studentDepartment)
          .collection('semesters')
          .doc(firstStudent.studentSemester)
          .collection('courses');

      var compulsoryCoursesQuery = await coursesRef.where('courseType', isEqualTo: 'compulsory').get();

      // Prepare parallel tasks for Firebase Auth user creation
      List<Future> authFutures = [];

      // Assign students to their existing sections
      for (var currentStudent in students) {
        var student = StudentModel.fromStudent(currentStudent);

        // Check if the student already exists
        var deptRef = _firestore.collection('departments').doc(student.studentDepartment);
        var studentRef = deptRef.collection('students').doc(student.studentRollNo);
        var deptSnapshot = await deptRef.get();
        if (!deptSnapshot.exists) {
          throw Exception('Department not exists');
        }

        var studentSnapshot = await studentRef.get();
        if (studentSnapshot.exists) {
          throw Exception('Student with roll number ${student.studentRollNo} already exists');
        }

        // Add Firebase Auth user creation task
        authFutures.add(
          _auth.createUserWithEmailAndPassword(
            email: student.studentEmail,
            password: student.studentCNIC,
          ),
        );

        String sectionName = '$shift ${student.studentSection}';
        if (!sections.containsKey(sectionName)) {
          sections[sectionName] = {
            'sectionName': sectionName,
            'shift': shift,
            'totalStudents': 1,
            'studentList': []
          };
        }

        // Update section with new student
        sections[sectionName]!['totalStudents'] = (sections[sectionName]!['totalStudents'] ?? 0) + 1;
        List<dynamic> studentList = sections[sectionName]!['studentList'] ?? [];
        studentList.add(student.studentRollNo);
        sections[sectionName]!['studentList'] = studentList;

        // Add student document to Firestore
        print(sectionName);
        batch.set(studentRef, student.toMap());
      }

      // Wait for all Firebase Auth user creation tasks to complete
      // await Future.wait(authFutures);

      // Update all sections in Firestore
      for (var section in sections.entries) {
        print(section.key);
        batch.set(
          sectionRef.doc(section.key),
          section.value,
          SetOptions(merge: true),
        );
      }

      // Update students in compulsory courses
      for (var courseDoc in compulsoryCoursesQuery.docs) {
        var courseId = courseDoc.id;
        var courseSectionRef = coursesRef.doc(courseId).collection('sections');

        for (var section in sections.entries) {
          batch.set(
            courseSectionRef.doc(section.key),
            section.value,
            SetOptions(merge: true),
          );
        }
      }
    }

    print('adding previous students');
    // Assign morning and evening students to their sections
    await assignShiftStudents(morningStudents, 'Morning');
    await assignShiftStudents(eveningStudents, 'Evening');

    // Commit the batch operation
    await batch.commit();

    print('All previous students have been successfully added to their sections.');
  }

  Future<void> addStudentsBatch(List<StudentModel> students) async {
    WriteBatch batch = _firestore.batch();
    Map<String, Map<String, dynamic>> localSectionDataMap = {}; // Local cache for sections
    Map<String, List<String>> sectionUpdates = {}; // Tracks studentRollNo updates for sections
    Map<String, int> sectionStudentCounts = {}; // Tracks student counts for sections
    List<Future> authFutures = []; // Parallel tasks for Firebase Auth

    // Pre-fetch section data for all students' department, semester, and shift
    if (students.isNotEmpty) {
      var firstStudent = students.first;
      var sectionRef = _firestore
          .collection('departments')
          .doc(firstStudent.studentDepartment)
          .collection('semesters')
          .doc(firstStudent.studentSemester)
          .collection('sections');

      var sectionQuery = await sectionRef.where('shift', isEqualTo: firstStudent.studentShift).get();
      for (var doc in sectionQuery.docs) {
        localSectionDataMap[doc.id] = doc.data();
        sectionStudentCounts[doc.id] = doc.data()['totalStudents'] ?? 0;
      }
    }

    // Pre-fetch compulsory courses
    var coursesRef = _firestore
        .collection('departments')
        .doc(students.first.studentDepartment)
        .collection('semesters')
        .doc(students.first.studentSemester)
        .collection('courses');

    var compulsoryCoursesQuery = await coursesRef.where('courseType', isEqualTo: 'compulsory').get();

    // Process each student
    for (var student in students) {
      var deptRef = _firestore.collection('departments').doc(student.studentDepartment);
      var studentRef = deptRef.collection('students').doc(student.studentRollNo);
      var deptSnapshot = await deptRef.get();
      if (!deptSnapshot.exists) {
        throw Exception('Department not exists');
      }

      // Check if the student already exists
      var studentSnapshot = await studentRef.get();
      if (studentSnapshot.exists) {
        throw Exception('Student with roll no ${student.studentRollNo} already exists');
      }

      // Create user in Firebase Authentication (parallel execution)
      authFutures.add(
        _auth.createUserWithEmailAndPassword(
          email: student.studentEmail,
          password: student.studentCNIC,
        ),
      );

      // Assign a section to the student
      String? sectionName;
      bool assigned = false;

      for (var entry in localSectionDataMap.entries) {
        var sectionData = entry.value;
        int totalStudents = sectionStudentCounts[entry.key] ?? 0;
        int sectionLimit = 30;

        if (totalStudents < sectionLimit) {
          sectionName = entry.key;
          sectionStudentCounts[entry.key] = totalStudents + 1;
          sectionUpdates[entry.key] = [...(sectionUpdates[entry.key] ?? []), student.studentRollNo];
          assigned = true;
          break;
        }
      }

      // If no section has space, create a new one
      if (!assigned) {
        int newSectionIndex = localSectionDataMap.length + 1;
        String newSectionID = (student.studentShift.toLowerCase() == 'morning') ? 'A$newSectionIndex' : 'E$newSectionIndex';
        sectionName = newSectionID;

        localSectionDataMap[sectionName] = {
          'sectionName': sectionName,
          'shift': student.studentShift,
          'totalStudents': 1,
          'studentList': [student.studentRollNo],
        };
        sectionStudentCounts[sectionName] = 1;
        sectionUpdates[sectionName] = [student.studentRollNo];
      }

      student.studentSection = sectionName!;

      // Add student data to Firestore batch
      batch.set(studentRef, student.toMap());
    }

    // Update section data in Firestore
    for (var entry in sectionUpdates.entries) {
      String sectionName = entry.key;
      List<String> updatedStudentList = entry.value;

      batch.set(
        _firestore
            .collection('departments')
            .doc(students.first.studentDepartment)
            .collection('semesters')
            .doc(students.first.studentSemester)
            .collection('sections')
            .doc(sectionName),
        {
          'sectionName': sectionName,
          'shift': students.first.studentShift,
          'totalStudents': sectionStudentCounts[sectionName],
          'studentList': FieldValue.arrayUnion(updatedStudentList),
        },
        SetOptions(merge: true),
      );
    }

    // Add students to compulsory courses
    for (var courseDoc in compulsoryCoursesQuery.docs) {
      var courseId = courseDoc.id;

      for (var sectionEntry in sectionUpdates.entries) {
        String sectionName = sectionEntry.key;
        List<String> studentList = sectionEntry.value;

        batch.set(
          coursesRef.doc(courseId).collection('sections').doc(sectionName),
          {
            'sectionName': sectionName,
            'shift': students.first.studentShift,
            'totalStudents': FieldValue.increment(studentList.length),
            'studentList': FieldValue.arrayUnion(studentList),
          },
          SetOptions(merge: true),
        );
      }
    }

    // Wait for all Firebase Authentication tasks to complete
    await Future.wait(authFutures);

    // Commit Firestore batch
    await batch.commit();

    print('All students added successfully in an optimized manner.');
  }

  // Future<StudentModel> addStudent(StudentModel student) async {
    // var deptRef = _firestore.collection('departments').doc(student.studentDepartment);
    // var studentRef = deptRef.collection('students').doc(student.studentRollNo);
  //   var snapshot = await ref.get();
  //
  //   _auth.createUserWithEmailAndPassword(email: student.studentEmail, password: student.studentCNIC);
  //
  //   if (!snapshot.exists) {
  //     await ref.set(student.toMap());
  //   } else {
  //     throw Exception('Student already exists');
  //   }
  //
  //   return student;
  // }

  @override
  Future<void> deleteStudent(String dept, String rollNo) async {
    var deptRef = _firestore.collection('departments').doc(dept);
    var studentRef = deptRef.collection('students').doc(rollNo);
    studentRef.delete();
  }

  @override
  Future<StudentModel> editStudent(StudentModel student) async {
    var deptRef = _firestore.collection('departments').doc(student.studentDepartment);
    var ref = deptRef.collection('students').doc(student.studentRollNo);
    var deptSnapshot = await deptRef.get();
    if (!deptSnapshot.exists) {
      throw Exception('Department not exists');
    }

    var snapshot = await ref.get();
    if (snapshot.exists) {
      await ref.set(student.toMap());
    } else {
      throw Exception('Student not exists');
    }

    return student;
  }

  @override
  Future<Map<String, List<StudentModel>>> allStudents() async {
    final querySnapshot = await _firestore.collectionGroup('students').get();

    final Map<String, List<StudentModel>> departmentWiseStudents = {};

    for (var doc in querySnapshot.docs) {
      final data = doc.data();

      // Extract department ID from the document path
      final pathSegments = doc.reference.path.split('/');
      final departmentId = pathSegments[pathSegments.indexOf('departments') + 1];

      final student = StudentModel.fromMap(data);

      // Group students by department
      if (departmentWiseStudents.containsKey(departmentId)) {
        departmentWiseStudents[departmentId]!.add(student);
      } else {
        departmentWiseStudents[departmentId] = [student];
      }
    }

    return departmentWiseStudents;
  }


  @override
  Future<List<StudentModel>> getStudentsByDepartment(String deptName) async {
    var deptRef = _firestore.collection('departments').doc(deptName);
    var studentRef = deptRef.collection('students');
    final querySnapshot = await studentRef.get();

    return querySnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<List<StudentModel>> getStudentsBySemester(String deptName, String semester) async {
    var deptRef = _firestore.collection('departments').doc(deptName);
    var studentRef = deptRef.collection('students');
    final querySnapshot = await studentRef
        .where('studentSemester', isEqualTo: semester)
        .get();

    return querySnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> setSectionLimit(String deptName, String semester, int limit) async {
    final ref = _firestore.collection('departments').doc(deptName).collection('semesters').doc(semester);
    ref.set({
      'sectionLimit': limit
    }, SetOptions(merge: true));

    if (kDebugMode) {
      print('limit set');
    }
  }

}