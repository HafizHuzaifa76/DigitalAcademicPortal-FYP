
class Semester{
  final String semesterName;
  int sectionLimit;
  final int totalCourses;
  int numOfCourses;
  final int numOfElectiveCourses;
  final int numOfStudents;
  final int numOfTeachers;

  Semester({required this.semesterName, required this.sectionLimit, required this.totalCourses, required this.numOfCourses, required this.numOfElectiveCourses, required this.numOfStudents, required this.numOfTeachers});

  addCourse(){
    numOfCourses++;
  }
}