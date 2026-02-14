import 'package:digital_academic_portal/features/student_panel/shared/student_assignment/presentation/pages/ImageToPdfPage.dart';
import 'package:digital_academic_portal/features/student_panel/shared/student_assignment/presentation/pages/TextToPdfPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../../../../../core/services/CloudinaryService.dart';
import '../controllers/StudentAssignmentController.dart';
import '../../domain/entities/StudentAssignment.dart';
import '../../../student_courses/domain/entities/StudentCourse.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'OcrToPdfPage.dart';

class SubmitAssignmentPage extends StatefulWidget {
  final StudentAssignment assignment;
  final StudentAssignmentController controller;

  const SubmitAssignmentPage({
    Key? key,
    required this.assignment,
    required this.controller,
  }) : super(key: key);

  @override
  State<SubmitAssignmentPage> createState() => _SubmitAssignmentPageState();
}

class _SubmitAssignmentPageState extends State<SubmitAssignmentPage> {
  File? selectedFile;
  bool isUploading = false;
  String? uploadedFileUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Submit Assignment',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2C5D3B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Assignment Details Card
            _buildAssignmentDetailsCard(),

            SizedBox(height: 30),

            // Submission Options
            Text(
              'Choose Submission Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C5D3B),
              ),
            ),

            SizedBox(height: 20),

            // Direct File Upload Option
            _buildSubmissionOption(
              icon: Icons.upload_file,
              title: 'Upload File Directly',
              subtitle: 'Select and upload a file from your device',
              color: Color(0xFF2C5D3B),
              onTap: _showFileUploadDialog,
            ),

            SizedBox(height: 16),

            // Create PDF from Images Option
            _buildSubmissionOption(
              icon: Icons.image,
              title: 'Create PDF from Images',
              subtitle: 'Convert multiple images to a single PDF document',
              color: Colors.blue,
              onTap: _navigateToImageToPdfPage,
            ),

            SizedBox(height: 16),

            // Text to PDF Option
            _buildSubmissionOption(
              icon: Icons.text_fields,
              title: 'Create PDF from Text',
              subtitle: 'Write text and convert it to PDF format',
              color: Colors.orange,
              onTap: _navigateToTextToPdfPage,
            ),

            SizedBox(height: 16),

            // OCR Text Extraction Option
            _buildSubmissionOption(
              icon: Icons.document_scanner,
              title: 'Extract Text from Image',
              subtitle: 'Scan image text and create PDF from extracted text',
              color: Colors.purple,
              onTap: _navigateToOcrPage,
            ),

            SizedBox(height: 30),

            // Selected File Display
            if (selectedFile != null || uploadedFileUrl != null)
              _buildSelectedFileCard(),

            SizedBox(height: 30),

            // Submit Button
            if (uploadedFileUrl != null) _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentDetailsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C5D3B), Color(0xFF1B7660)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.assignment.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            widget.assignment.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.schedule, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                'Due: ${_formatDate(widget.assignment.dueDate)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C5D3B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFileCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File Ready for Submission',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  selectedFile?.path.split('/').last ??
                      'File uploaded successfully',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isUploading ? null : _submitAssignment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2C5D3B),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isUploading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Submitting...'),
                ],
              )
            : Text(
                'Submit Assignment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _showFileUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload File'),
        content: Text('Select a file to upload for this assignment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pickAndUploadFile();
            },
            child: Text('Select File'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
          isUploading = true;
        });

        // Upload to Cloudinary
        String? fileUrl = await uploadFileToCloudinary(selectedFile!);

        setState(() {
          isUploading = false;
          uploadedFileUrl = fileUrl;
        });

        if (fileUrl == null) {
          Get.snackbar(
            'Error',
            'Failed to upload file to Cloudinary.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Success',
            'File uploaded successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to pick file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _navigateToImageToPdfPage() {
    Get.to(() => ImageToPdfPage(
          assignment: widget.assignment,
          controller: widget.controller,
        ));
  }

  void _navigateToTextToPdfPage() {
    Get.to(() => TextToPdfPage(
          assignment: widget.assignment,
          controller: widget.controller,
        ));
  }

  void _navigateToOcrPage() async {
    try {
      final List<String> scannedPaths =
          await CunningDocumentScanner.getPictures(
                  isGalleryImportAllowed: true) ??
              [];
      if (scannedPaths.isNotEmpty) {
        final inputImage = InputImage.fromFilePath(scannedPaths.first);
        final textRecognizer = TextRecognizer();
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        await textRecognizer.close();
        final extractedText = recognizedText.text;
        Get.to(() => OcrToPdfPage(
              assignment: widget.assignment,
              controller: widget.controller,
              initialText: extractedText,
            ));
      } else {
        Get.snackbar('No Image', 'No image was scanned.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to scan or extract text: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _submitAssignment() async {
    if (uploadedFileUrl == null) {
      Get.snackbar(
        'Error',
        'Please upload a file first.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      setState(() {
        isUploading = true;
      });

      await widget.controller.submitAssignment(
        widget.assignment.id,
        uploadedFileUrl!,
      );

      Get.snackbar(
        'Success',
        'Assignment submitted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back to assignments page
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit assignment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
