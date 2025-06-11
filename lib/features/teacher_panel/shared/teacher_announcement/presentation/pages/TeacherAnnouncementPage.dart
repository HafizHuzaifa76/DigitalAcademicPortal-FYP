import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Announcement {
  final String id;
  final String courseId;
  final String courseName;
  final String courseSection;
  final String title;
  final String content;
  final DateTime dateTime;
  final bool isPublished;

  Announcement({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.courseSection,
    required this.title,
    required this.content,
    required this.dateTime,
    this.isPublished = true,
  });
}

class TeacherAnnouncementPage extends StatefulWidget {
  const TeacherAnnouncementPage({super.key});

  @override
  State<TeacherAnnouncementPage> createState() => _TeacherAnnouncementPageState();
}

class _TeacherAnnouncementPageState extends State<TeacherAnnouncementPage> {
  // Sample data - Replace with actual data from your backend
  final List<Announcement> _announcements = [
    Announcement(
      id: '1',
      courseId: '1',
      courseName: 'Mobile App Development',
      courseSection: 'A1',
      title: 'Project Submission Deadline',
      content: 'Final project submission deadline has been extended to next week.',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Announcement(
      id: '2',
      courseId: '2',
      courseName: 'Software Quality Assurance',
      courseSection: 'B2',
      title: 'Quiz Announcement',
      content: 'Quiz will be conducted next Monday on Unit Testing.',
      dateTime: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  String? _selectedCourseId;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Get.theme.primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Get.theme.primaryColor,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _createNewAnnouncement() {
    _titleController.clear();
    _contentController.clear();
    _selectedCourseId = null;
    _selectedDateTime = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Create Announcement',
                  style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedCourseId,
                              decoration: InputDecoration(
                                labelText: 'Select Course',
                                labelStyle: TextStyle(color: Get.theme.primaryColor),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Get.theme.primaryColor),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: '1', child: Text('Mobile App Development - A1')),
                                DropdownMenuItem(value: '2', child: Text('Software Quality Assurance - B2')),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedCourseId = value);
                              },
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () => _selectDateTime(context),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Date & Time',
                                  labelStyle: TextStyle(color: Get.theme.primaryColor),
                                  border: const OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Get.theme.primaryColor),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_today,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                child: Text(
                                  DateFormat('MMM d, yyyy - h:mm a').format(_selectedDateTime),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Get.theme.primaryColor),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          labelStyle: TextStyle(color: Get.theme.primaryColor),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.primaryColor,
                      ),
                      onPressed: () {
                        if (_selectedCourseId == null || 
                            _titleController.text.isEmpty || 
                            _contentController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final courseName = _selectedCourseId == '1' 
                            ? 'Mobile App Development' 
                            : 'Software Quality Assurance';
                        final courseSection = _selectedCourseId == '1' ? 'A1' : 'B2';

                        setState(() {
                          _announcements.insert(0, Announcement(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            courseId: _selectedCourseId!,
                            courseName: courseName,
                            courseSection: courseSection,
                            title: _titleController.text,
                            content: _contentController.text,
                            dateTime: _selectedDateTime,
                          ));
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Create', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(Announcement announcement) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Get.theme.primaryColor),
              title: Text('Edit', style: TextStyle(color: Get.theme.primaryColor)),
              onTap: () {
                Navigator.pop(context);
                _editAnnouncement(announcement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(announcement);
              },
            ),
          ],
        );
      },
    );
  }

  void _editAnnouncement(Announcement announcement) {
    _titleController.text = announcement.title;
    _contentController.text = announcement.content;
    _selectedDateTime = announcement.dateTime;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Edit Announcement',
                  style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${announcement.courseName} - ${announcement.courseSection}',
                        style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      StatefulBuilder(
                        builder: (context, setState) => InkWell(
                          onTap: () => _selectDateTime(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date & Time',
                              labelStyle: TextStyle(color: Get.theme.primaryColor),
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Get.theme.primaryColor),
                              ),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                            child: Text(
                              DateFormat('MMM d, yyyy - h:mm a').format(_selectedDateTime),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Get.theme.primaryColor),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          labelStyle: TextStyle(color: Get.theme.primaryColor),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.primaryColor,
                      ),
                      onPressed: () {
                        if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          final index = _announcements.indexWhere((a) => a.id == announcement.id);
                          if (index != -1) {
                            _announcements[index] = Announcement(
                              id: announcement.id,
                              courseId: announcement.courseId,
                              courseName: announcement.courseName,
                              courseSection: announcement.courseSection,
                              title: _titleController.text,
                              content: _contentController.text,
                              dateTime: _selectedDateTime,
                            );
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Update', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Announcement',
          style: TextStyle(color: Get.theme.primaryColor),
        ),
        content: Text(
          'Are you sure you want to delete this announcement?',
          style: TextStyle(color: Get.theme.primaryColorDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Get.theme.primaryColor)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _announcements.removeWhere((a) => a.id == announcement.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Announcement deleted'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Announcements",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _announcements.isEmpty
            ? Center(
                child: Text(
                  'No announcements yet',
                  style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 16,
                  ),
                ),
              )
            : ListView(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 2.3,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = _announcements[index];
                      return _buildAnnouncementCard(announcement);
                    },
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewAnnouncement,
        backgroundColor: Get.theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${announcement.courseName} - ${announcement.courseSection}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () => _showOptions(announcement),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    announcement.content,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    DateFormat('MMM d, h:mm a').format(announcement.dateTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
