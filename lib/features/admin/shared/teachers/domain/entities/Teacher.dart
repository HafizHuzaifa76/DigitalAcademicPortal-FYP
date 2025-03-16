
class Teacher{
  final String teacherName;
  final String teacherDept;
  final String teacherEmail;
  final String teacherCNIC;
  final String teacherContact;
  final String teacherAddress;
  final String teacherType;
  final String teacherGender;

  Teacher({required this.teacherName, required this.teacherDept, required this.teacherEmail, required this.teacherCNIC, required this.teacherContact, required this.teacherAddress, required this.teacherType, required this.teacherGender});

  @override
  String toString() {
    return teacherName;
  }
}
