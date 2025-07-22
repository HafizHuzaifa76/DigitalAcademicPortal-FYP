import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:async';

import '../../../../../../core/services/CloudinaryService.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class ImageToPdfPage extends StatefulWidget {
  final dynamic controller;
  final dynamic assignment;

  const ImageToPdfPage({
    Key? key,
    required this.controller,
    required this.assignment,
  }) : super(key: key);

  @override
  State<ImageToPdfPage> createState() => _ImageToPdfPageState();
}

class _ImageToPdfPageState extends State<ImageToPdfPage> {
  List<XFile>? selectedImages;
  String? generatedPdfPath;
  bool isUploading = false;
  String? uploadedFileUrl;

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        if (selectedImages == null) {
          selectedImages = List<XFile>.from(picked);
        } else {
          selectedImages!.addAll(picked);
        }
      });
    }
  }

  Future<void> scanDocument() async {
    try {
      final List<String> scannedPaths =
          await CunningDocumentScanner.getPictures(
                  isGalleryImportAllowed: true) ??
              [];
      if (scannedPaths.isNotEmpty) {
        setState(() {
          if (selectedImages == null) {
            selectedImages = scannedPaths.map((path) => XFile(path)).toList();
          } else {
            selectedImages!.addAll(scannedPaths.map((path) => XFile(path)));
          }
        });
      }
    } catch (e) {
      Get.snackbar(
        'Scan Failed',
        'Could not scan document: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearAllImages() {
    setState(() {
      selectedImages = [];
    });
  }

  Future<void> generatePdf() async {
    if (selectedImages == null || selectedImages!.isEmpty) return;

    final pdf = pw.Document();

    for (var image in selectedImages!) {
      final imageData = File(image.path).readAsBytesSync();
      final pdfImage = pw.MemoryImage(imageData);
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Center(child: pw.Image(pdfImage)),
      ));
    }

    final outputDir = await getTemporaryDirectory();
    final file = File('${outputDir.path}/assignment.pdf');
    await file.writeAsBytes(await pdf.save());

    setState(() {
      generatedPdfPath = file.path;
    });

    Get.snackbar(
      'PDF Created',
      'Your PDF has been generated successfully.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
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
      String? fileUrl =
          await uploadFileToCloudinary(file); // You must define this

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

      await widget.controller.submitAssignment(widget.assignment.id, fileUrl);

      Get.snackbar(
        'Success',
        'Assignment submitted successfully!',
        backgroundColor: Theme.of(context).primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Pop two pages to return to StudentAssignmentPage
      Get.back();
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

  void _viewPdf() {
    if (generatedPdfPath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text("View PDF")),
            body: PdfPreview(
              build: (format) => File(generatedPdfPath!).readAsBytesSync(),
            ),
          ),
        ),
      );
    } else {
      Get.snackbar(
        'No PDF Found',
        'Please generate a PDF first.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedImages?.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Image to PDF')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedImages != null && selectedImages!.isNotEmpty)
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Selected Images",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                label: const Text("Clear All",
                                    style: TextStyle(color: Colors.red)),
                                onPressed: clearAllImages,
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedImages!.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(selectedImages![index].path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Material(
                                        color: Colors.black54,
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: () => removeImage(index),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(Icons.close,
                                                color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text("Pick Images"),
                        onPressed: pickImages,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Expanded(
                    //   child: FilledButton.icon(
                    //     icon: const Icon(Icons.document_scanner_outlined),
                    //     label: const Text("Scan Document"),
                    //     onPressed: scanDocument,
                    //     style: FilledButton.styleFrom(
                    //       padding: const EdgeInsets.symmetric(vertical: 16),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(12)),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text("Generate PDF"),
                        onPressed: generatePdf,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.visibility),
                        label: const Text("View PDF"),
                        onPressed: _viewPdf,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (generatedPdfPath != null) {
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PdfPreview(
                              build: (format) =>
                                  File(generatedPdfPath!).readAsBytesSync(),
                            ),
                          ),
                        );
                      } else if (selectedImages != null &&
                          selectedImages!.isNotEmpty) {
                        return Center(
                          child: Text(
                            "Ready to generate PDF from ${selectedImages!.length} image(s).",
                            style: theme.textTheme.titleMedium,
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined,
                                  size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                "No images selected.\nPick images to start.",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  icon: isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.upload_file),
                  label: const Text("Submit Assignment"),
                  onPressed: isUploading ? null : _submitAssignment,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isUploading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Uploading... Please wait"),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
