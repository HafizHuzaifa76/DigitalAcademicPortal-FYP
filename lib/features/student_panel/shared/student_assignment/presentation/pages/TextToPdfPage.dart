import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../../../../../../core/services/CloudinaryService.dart';
import '../controllers/StudentAssignmentController.dart';
import '../../domain/entities/StudentAssignment.dart';
// import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';

class TextToPdfPage extends StatefulWidget {
  final StudentAssignment assignment;
  final StudentAssignmentController controller;

  const TextToPdfPage({
    Key? key,
    required this.assignment,
    required this.controller,
  }) : super(key: key);

  @override
  State<TextToPdfPage> createState() => _TextToPdfPageState();
}

class _TextToPdfPageState extends State<TextToPdfPage> {
  late QuillController _quillController;
  bool isGeneratingPdf = false;
  bool isUploading = false;
  String? generatedPdfPath;
  String? uploadedFileUrl;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create PDF from Text',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!isGeneratingPdf && !isUploading)
            TextButton(
              onPressed: _generatePdf,
              child: const Text(
                'Generate PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Loading Indicator
          if (isGeneratingPdf || isUploading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF2C5D3B)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isGeneratingPdf ? 'Generating PDF...' : 'Uploading PDF...',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Success Message
          if (generatedPdfPath != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: primaryColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PDF Generated Successfully!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your PDF is ready for submission',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          generatedPdfPath != null
                              ? generatedPdfPath!.split('/').last
                              : '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Quill Editor
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Toolbar
                  Row(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: QuillSimpleToolbar(
                                controller: _quillController,
                                config: const QuillSimpleToolbarConfig(
                                  showFontFamily: false,
                                  showSearchButton: false,
                                  showCodeBlock: false,
                                  showInlineCode: false,
                                  showQuote: false,
                                  showLink: false,
                                  showDirection: false,
                                  showIndent: false,
                                  showListNumbers: true,
                                  showListBullets: true,
                                  showDividers: true,
                                  showAlignmentButtons: true,
                                  showHeaderStyle: true,
                                  showColorButton: true,
                                  showBackgroundColorButton: true,
                                  showClearFormat: true,
                                  showBoldButton: true,
                                  showItalicButton: true,
                                  showUnderLineButton: true,
                                  showStrikeThrough: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Editor
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: QuillEditor.basic(
                        controller: _quillController,
                        config: const QuillEditorConfig(
                          placeholder:
                              'Start writing your assignment content here...',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit Button
          if (generatedPdfPath != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: isUploading ? null : _submitAssignment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Assignment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _generatePdf() async {
    if (_quillController.document.isEmpty()) {
      Get.snackbar(
        'Error',
        'Please write some content before generating PDF.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isGeneratingPdf = true;
    });

    try {
      // final pdfConverter = PDFConverter(
      //   document: _quillController.document.toDelta(),
      //   pageFormat: PDFPageFormat.a4,
      //   fallbacks: [],
      // );

      // // Generate the PDF bytes
      // final document = await pdfConverter.createDocument();
      // if (document == null) {
      //   Get.snackbar(
      //     'Error',
      //     'The file cannot be generated by an unknown error',
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white,
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
      //   return;
      // }

      // // Save PDF to temporary file
      // final output = await getTemporaryDirectory();
      // final file = File(
      //     '${output.path}/assignment_${DateTime.now().millisecondsSinceEpoch}.pdf');
      // await file.writeAsBytes(await document.save());

      // setState(() {
      //   isGeneratingPdf = false;
      //   generatedPdfPath = file.path;
      // });

      Get.snackbar(
        'Success',
        'PDF generated successfully! You can now submit your assignment.',
        backgroundColor: Theme.of(context).primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      setState(() {
        isGeneratingPdf = false;
      });
      Get.snackbar(
        'Error',
        'Failed to generate PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _submitAssignment() async {
    if (generatedPdfPath == null) {
      Get.snackbar(
        'Error',
        'Please generate a PDF first.',
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

      // Upload to Cloudinary
      final file = File(generatedPdfPath!);
      String? fileUrl = await uploadFileToCloudinary(file);

      setState(() {
        isUploading = false;
        uploadedFileUrl = fileUrl;
      });

      if (fileUrl == null) {
        Get.snackbar(
          'Error',
          'Failed to upload PDF to Cloudinary.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await widget.controller.submitAssignment(
        widget.assignment.id,
        fileUrl,
      );

      Get.snackbar(
        'Success',
        'Assignment submitted successfully!',
        backgroundColor: Theme.of(context).primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back to assignments page
      Get.back();
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to submit assignment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
