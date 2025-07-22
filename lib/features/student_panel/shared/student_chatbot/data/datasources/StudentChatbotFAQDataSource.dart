import '../../domain/entities/StudentFAQ.dart';

class StudentChatbotFAQDataSource {
  List<StudentFAQ> getFAQs() {
    return [
      StudentFAQ(
          question: 'How do I check my attendance?',
          answer:
              'You can check your attendance by navigating to the Attendance section in your student portal dashboard by selecting a specific course.'),
      StudentFAQ(
          question: 'How can I view my grades?',
          answer:
              'Student Dashboard -> Grades -> Current Semester Grades, Previous Semester Grades, (user can view his grades here)'),
      StudentFAQ(
          question: 'Where is my timetable?',
          answer:
              'Your timetable is available in the Timetable section of the student portal. It shows your class schedule for the semester.'),
      StudentFAQ(
          question: 'How do I submit assignments?',
          answer:
              'Assignments can be submitted through the Assignments section. Select your course and upload your assignment file or you can create assignment there by selecting different methods like generate pdf from images, generate pdf from text, scan document and edit etc..'),
      StudentFAQ(
          question: 'How do I contact my teacher?',
          answer:
              'Student Dashboard -> Courses -> Select a course -> Ask Query (You can ask query from your course teacher here)'),
      StudentFAQ(
          question: 'How do I view my courses?',
          answer:
              'Student Dashboard -> Courses -> All your enrolled courses are listed in the Courses section of the portal.'),
      StudentFAQ(
          question: 'How do I access the noticeboard?',
          answer:
              'The Noticeboard section contains all important announcements and notices for students.'),
      StudentFAQ(
          question: 'How do I check my exam schedule?',
          answer:
              'Exam schedules are posted in the Exam Schedule section. Check there for dates and times.'),
      StudentFAQ(
          question: 'How do I update my profile?',
          answer:
              'You can update your profile information in the Profile section of the portal.'),
      StudentFAQ(
          question: 'How do I reset my password?',
          answer:
              'To reset your password, go to the Account Settings and select Reset Password.'),
      StudentFAQ(
          question: 'How do I report an issue?',
          answer:
              'Student Dashboard -> Drawer -> Report (here user ;ncan report any issue).'),
      StudentFAQ(
          question: 'What if I forgot my password?',
          answer:
              'If you forgot your password, use the "Forgot Password" link on the login page to reset it. Follow the instructions sent to your registered email.'),
    ];
  }
}
