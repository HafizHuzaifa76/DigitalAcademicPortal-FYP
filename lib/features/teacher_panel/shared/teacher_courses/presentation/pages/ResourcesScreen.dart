import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/UploadedFileController.dart';
import '../../domain/entities/UploadedFile.dart' as domain;
import '../../../teacher_courses/domain/entities/TeacherCourse.dart';

class ResourcesScreen extends StatelessWidget {
  final TeacherCourse course;

  const ResourcesScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UploadedFileController>();

    // Load files when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFiles(course, domain.FileType.resource);
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          '${course.courseCode} Resources',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.isUploading.value) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.folder,
                    color: Get.theme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Upload additional resources for ${course.courseName}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.files.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.folder,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No resources uploaded yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Click the upload button to add resources',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.files.length,
                itemBuilder: (context, index) {
                  final file = controller.files[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: controller
                              .getFileExtensionColor(file.fileName)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          controller.getFileExtensionIcon(file.fileName),
                          color:
                              controller.getFileExtensionColor(file.fileName),
                          size: 24,
                        ),
                      ),
                      title: Text(
                        file.fileName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.storage,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${(file.fileSize / 1024 / 1024).toStringAsFixed(2)} MB',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(file.uploadDate),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: PopupMenuButton(
                          icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'download',
                              child: Row(
                                children: [
                                  Icon(Icons.download,
                                      size: 18, color: Get.theme.primaryColor),
                                  const SizedBox(width: 12),
                                  const Text('Download',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      size: 18, color: Colors.red[400]),
                                  const SizedBox(width: 12),
                                  Text('Delete',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red[400])),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'delete') {
                              _showDeleteConfirmation(
                                  context, controller, file);
                            } else if (value == 'download') {
                              controller.downloadAndOpenFile(file.fileUrl);
                              // _downloadFile(file.fileUrl, file.fileName);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if (controller.isUploading.value) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          backgroundColor: Get.theme.primaryColor,
          onPressed: () =>
              controller.uploadFile(course, domain.FileType.resource),
          child: const Icon(Icons.upload_file, color: Colors.white),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _downloadFile(String fileUrl, String fileName) async {
    try {
      final Uri url = Uri.parse(fileUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open file',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context,
      UploadedFileController controller, domain.UploadedFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[400], size: 24),
            const SizedBox(width: 12),
            const Text('Delete Resource',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text('Are you sure you want to delete "${file.fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              controller.deleteFile(file.id, course, domain.FileType.resource);
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
