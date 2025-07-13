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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create PDF from Text',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2C5D3B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!isGeneratingPdf && !isUploading)
            TextButton(
              onPressed: _generateAndUploadPdf,
              child: Text(
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
          // Assignment Info Card
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2C5D3B), Color(0xFF1B7660)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.assignment.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Write your assignment content below and generate a PDF',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Loading Indicator
          if (isGeneratingPdf || isUploading)
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF2C5D3B)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    isGeneratingPdf ? 'Generating PDF...' : 'Uploading PDF...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Success Message
          if (uploadedFileUrl != null)
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
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
                          'PDF Generated Successfully!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your PDF is ready for submission',
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
            ),

          // Quill Editor
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Toolbar
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: QuillToolbar.simple(
                      configurations: QuillSimpleToolbarConfigurations(
                        controller: _quillController,
                        showFontFamily: false,
                        showSearchButton: false,
                        showCodeBlock: false,
                        showInlineCode: false,
                        showQuote: true,
                        showListNumbers: true,
                        showListBullets: true,
                        showLink: false,
                        showDividers: true,
                        showIndent: true,
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

                  // Editor
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          controller: _quillController,
                          placeholder:
                              'Start writing your assignment here...\n\nYou can use the toolbar above to format your text.\n\n• Use bullet points for lists\n• Use bold and italic for emphasis\n• Add headings for structure\n• Use quotes for important information',
                          checkBoxReadOnly: false,
                          
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit Button
          if (uploadedFileUrl != null)
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _submitAssignment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2C5D3B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
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

  Future<void> _generateAndUploadPdf() async {
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
      // Generate PDF
      final pdf = pw.Document();

      // Add content to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Text(
                    widget.assignment.title,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Assignment content
                  ..._convertQuillToPdfWidgets(),
                ],
              ),
            );
          },
        ),
      );

      // Save PDF to temporary file
      final output = await getTemporaryDirectory();
      final file = File(
          '${output.path}/assignment_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      setState(() {
        isGeneratingPdf = false;
        isUploading = true;
      });

      // Upload to Cloudinary
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
      } else {
        Get.snackbar(
          'Success',
          'PDF generated and uploaded successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      // Clean up temporary file
      await file.delete();
    } catch (e) {
      setState(() {
        isGeneratingPdf = false;
        isUploading = false;
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

  List<pw.Widget> _convertQuillToPdfWidgets() {
    List<pw.Widget> widgets = [];

    for (final operation in _quillController.document.toDelta().toList()) {
      if (operation.data is Map) {
        final data = operation.data as Map;
        final text = operation.value.toString();

        if (text.trim().isEmpty) {
          widgets.add(pw.SizedBox(height: 8));
          continue;
        }

        pw.TextStyle textStyle = pw.TextStyle(fontSize: 12);

        // Apply formatting
        if (data.containsKey('bold') && data['bold'] == true) {
          textStyle = textStyle.copyWith(fontWeight: pw.FontWeight.bold);
        }
        if (data.containsKey('italic') && data['italic'] == true) {
          textStyle = textStyle.copyWith(fontStyle: pw.FontStyle.italic);
        }
        if (data.containsKey('underline') && data['underline'] == true) {
          // PDF doesn't support underline directly, we'll skip it
        }

        // Handle different block types
        if (data.containsKey('block')) {
          final block = data['block'];
          if (block == 'h1') {
            textStyle = textStyle.copyWith(
                fontSize: 20, fontWeight: pw.FontWeight.bold);
          } else if (block == 'h2') {
            textStyle = textStyle.copyWith(
                fontSize: 18, fontWeight: pw.FontWeight.bold);
          } else if (block == 'h3') {
            textStyle = textStyle.copyWith(
                fontSize: 16, fontWeight: pw.FontWeight.bold);
          } else if (block == 'quote') {
            widgets.add(
              pw.Container(
                margin: pw.EdgeInsets.only(left: 20, top: 8, bottom: 8),
                padding: pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    left: pw.BorderSide(color: PdfColors.grey, width: 3),
                  ),
                ),
                child: pw.Text(text,
                    style: textStyle.copyWith(fontStyle: pw.FontStyle.italic)),
              ),
            );
            continue;
          } else if (block == 'list') {
            widgets.add(
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('• ', style: textStyle),
                  pw.Expanded(child: pw.Text(text, style: textStyle)),
                ],
              ),
            );
            continue;
          }
        }

        widgets.add(pw.Text(text, style: textStyle));
      }
    }

    return widgets;
  }

  Future<void> _submitAssignment() async {
    if (uploadedFileUrl == null) {
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
}
