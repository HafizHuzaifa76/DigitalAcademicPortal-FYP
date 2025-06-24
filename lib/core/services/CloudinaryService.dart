import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

Future<String?> uploadFileToCloudinary(File file) async {
  const cloudName = "dazoeikop";
  const uploadPreset = "digital_academic_portal";
  const uploadFolder = "assets";

  final url =
      Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/auto/upload");

  final mimeType = lookupMimeType(file.path) ?? "application/octet-stream";
  final mediaType = MediaType.parse(mimeType);

  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = uploadPreset
    ..fields['folder'] = uploadFolder
    ..files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: mediaType,
        filename: file.path.split('/').last, // Use original filename
      ),
    );

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final jsonResponse = json.decode(resStr);
      return jsonResponse['secure_url']; // Publicly accessible URL
    } else {
      final errorBody = await response.stream.bytesToString();
      print("Cloudinary upload failed: ${response.statusCode}, $errorBody");
      return null;
    }
  } catch (e) {
    print("Error uploading to Cloudinary: $e");
    return null;
  }
}
