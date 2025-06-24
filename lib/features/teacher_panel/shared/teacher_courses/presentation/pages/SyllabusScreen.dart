import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class SyllabusScreen extends StatefulWidget {
  final dynamic course;

  const SyllabusScreen({
    super.key,
    required this.course,
  });

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  Map<String, dynamic>? syllabusFile;

  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        // Here you would typically upload the file to your server
        // For now, we'll just update the local state
        setState(() {
          syllabusFile = {
            'name': path.basename(result.files.single.name),
            'size': result.files.single.size,
            'date': DateTime.now(),
            'path': result.files.single.path,
          };
        });

        Get.snackbar(
          'Success',
          'Syllabus uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload syllabus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _deleteFile() {
    setState(() {
      syllabusFile = null;
    });
    Get.snackbar(
      'Success',
      'Syllabus deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          '${widget.course.courseCode} Syllabus',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _pickAndUploadFile,
            tooltip: 'Upload Syllabus',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Get.theme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Upload course syllabus for ${widget.course.courseName}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: syllabusFile == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No syllabus uploaded yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click the upload button to add syllabus',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          syllabusFile!['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${(syllabusFile!['size'] / 1024 / 1024).toStringAsFixed(2)} MB • ${_formatDate(syllabusFile!['date'])}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, size: 20),
                                  SizedBox(width: 8),
                                  Text('View'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteFile();
                            } else if (value == 'view') {
                              // Implement PDF viewer
                              Get.snackbar(
                                'Coming Soon',
                                'PDF viewer will be implemented soon',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUploadFile,
        child: const Icon(Icons.upload_file),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 