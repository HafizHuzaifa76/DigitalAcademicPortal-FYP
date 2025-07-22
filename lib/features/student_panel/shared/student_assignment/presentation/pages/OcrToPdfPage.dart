import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../../../core/services/CloudinaryService.dart';
import '../controllers/StudentAssignmentController.dart';
import '../../domain/entities/StudentAssignment.dart';
import 'package:open_file/open_file.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrToPdfPage extends StatefulWidget {
  final StudentAssignment assignment;
  final StudentAssignmentController controller;
  final String? initialText;

  const OcrToPdfPage({
    Key? key,
    required this.assignment,
    required this.controller,
    this.initialText,
  }) : super(key: key);

  @override
  State<OcrToPdfPage> createState() => _OcrToPdfPageState();
}

class _OcrToPdfPageState extends State<OcrToPdfPage> {
  late QuillController _quillController;
  bool isGeneratingPdf = false;
  bool isUploading = false;
  String? generatedPdfPath;
  String? uploadedFileUrl;
  String? scannedImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      final doc = Document()..insert(0, widget.initialText!);
      _quillController = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    } else {
      _quillController = QuillController.basic();
      _scanAndExtractText();
    }
  }

  Future<void> _scanAndExtractText() async {
    try {
      final List<String> scannedPaths =
          await CunningDocumentScanner.getPictures(
                  isGalleryImportAllowed: true) ??
              [];
      if (scannedPaths.isNotEmpty) {
        setState(() {
          scannedImagePath = scannedPaths.first;
        });
        final inputImage = InputImage.fromFilePath(scannedImagePath!);
        final textRecognizer = TextRecognizer();
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        await textRecognizer.close();
        final extractedText = recognizedText.text;
        setState(() {
          _quillController = QuillController(
            document: Document()..insert(0, extractedText),
            selection: const TextSelection.collapsed(offset: 0),
          );
        });
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
          'Extract Text from Image',
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
                                configurations:
                                    QuillSimpleToolbarConfigurations(
                                  controller: _quillController,
                                  showListNumbers: true,
                                  showListBullets: true,
                                  showAlignmentButtons: true,
                                  showColorButton: true,
                                  showClearFormat: true,
                                  showBoldButton: true,
                                  showItalicButton: true,
                                  showUnderLineButton: true,
                                  showStrikeThrough: true,
                                  showFontFamily: false,
                                  showSearchButton: false,
                                  showCodeBlock: false,
                                  showInlineCode: false,
                                  showQuote: false,
                                  showLink: false,
                                  showDirection: false,
                                  showIndent: false,
                                  showDividers: false,
                                  showBackgroundColorButton: false,
                                  showHeaderStyle: false,
                                  showListCheck: false,
                                  showSuperscript: false,
                                  showSubscript: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          controller: _quillController,
                          placeholder:
                              'Scanned text will appear here. You can edit before generating PDF...',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        'Please write or scan some content before generating PDF.',
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
      final pdf = pw.Document();
      final delta = _quillController.document.toDelta();
      final ops = delta.toList();
      List<pw.Widget> children = [];
      int listIndex = 1;
      String? bufferText;
      pw.TextStyle? bufferStyle;
      pw.TextAlign? bufferAlign;
      PdfColor? getColor(Map? attrs) {
        if (attrs?['color'] != null) {
          final hex = attrs!['color'].toString().replaceFirst('FF', '');
          return PdfColor.fromHex(hex);
        }
        return null;
      }

      PdfColor? getBgColor(Map? attrs) {
        if (attrs?['background'] != null) {
          final hex = attrs!['background'].toString().replaceFirst('FF', '');
          return PdfColor.fromHex(hex);
        }
        return null;
      }

      pw.TextAlign getAlign(Map? attrs) {
        switch (attrs?['align']) {
          case 'center':
            return pw.TextAlign.center;
          case 'right':
            return pw.TextAlign.right;
          case 'justify':
            return pw.TextAlign.justify;
          default:
            return pw.TextAlign.left;
        }
      }

      double getFontSize(Map? attrs) {
        switch (attrs?['size']) {
          case 'small':
            return 10;
          case 'large':
            return 18;
          case 'huge':
            return 24;
          default:
            return 14;
        }
      }

      for (int i = 0; i < ops.length; i++) {
        final op = ops[i];
        final attrs = op.attributes ?? {};
        pw.TextStyle style = pw.TextStyle(
          fontSize: getFontSize(attrs),
          fontWeight:
              attrs['bold'] == true ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontStyle: attrs['italic'] == true
              ? pw.FontStyle.italic
              : pw.FontStyle.normal,
          decoration: (attrs['underline'] == true && attrs['strike'] == true)
              ? pw.TextDecoration.combine(
                  [pw.TextDecoration.underline, pw.TextDecoration.lineThrough])
              : (attrs['underline'] == true)
                  ? pw.TextDecoration.underline
                  : (attrs['strike'] == true)
                      ? pw.TextDecoration.lineThrough
                      : pw.TextDecoration.none,
          color: getColor(attrs),
        );
        if (op.data is String && op.data != '\n') {
          bufferText = (op.data as String).replaceAll('\n', '');
          bufferStyle = style;
          bufferAlign = null;
          continue;
        }
        if (op.data == '\n') {
          final align = getAlign(attrs);
          if (attrs['list'] == 'bullet' &&
              bufferText != null &&
              bufferStyle != null) {
            children.add(pw.Bullet(text: bufferText, style: bufferStyle));
            bufferText = null;
            bufferStyle = null;
            bufferAlign = null;
            continue;
          } else if (attrs['list'] == 'ordered' &&
              bufferText != null &&
              bufferStyle != null) {
            children.add(pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('${listIndex++}. ', style: bufferStyle),
                pw.Expanded(
                  child: pw.Text(
                    bufferText,
                    style: bufferStyle,
                    textAlign: align,
                  ),
                ),
              ],
            ));
            bufferText = null;
            bufferStyle = null;
            bufferAlign = null;
            continue;
          }
          if (bufferText != null && bufferStyle != null) {
            final bgColor = getBgColor(attrs);
            final textWidget = pw.Text(
              bufferText,
              style: bufferStyle,
              textAlign: align,
            );
            if (bgColor != null) {
              children.add(pw.Container(
                color: bgColor,
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                child: textWidget,
              ));
            } else {
              children.add(textWidget);
            }
            bufferText = null;
            bufferStyle = null;
            bufferAlign = null;
          }
        }
      }
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: children,
            );
          },
        ),
      );
      final output = await getExternalStorageDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file =
          File("${output?.path}/${widget.assignment.title}_$timestamp.pdf");
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
      setState(() {
        isGeneratingPdf = false;
        generatedPdfPath = file.path;
      });
      Get.snackbar(
        'Success',
        'PDF generated successfully! You can now submit your assignment.',
        backgroundColor: Theme.of(context).primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
      Get.back();
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
