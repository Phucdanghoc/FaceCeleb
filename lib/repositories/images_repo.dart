import 'dart:io';
import 'package:face_celeb/models/ImageResponse.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert'; // For jsonDecode

class ImageRepository {
  final String baseUrl;

  ImageRepository(this.baseUrl);

  Future<ImageUploadResponse?> uploadImage(File imageFile) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);

    final mimeType =
        lookupMimeType(imageFile.path) ?? 'application/octet-stream';
    final mediaType = MediaType.parse(mimeType);
    final image = await http.MultipartFile.fromPath('image', imageFile.path,
        contentType: mediaType);
    request.files.add(image);

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // Decode the JSON string to a Map
      final Map<String, dynamic> data = jsonDecode(responseBody);
      // Return the ImageUploadResponse object
      return ImageUploadResponse.fromJson(data);
    } else {
      print('Failed to upload image: ${response.statusCode}');
      return null;
    }
  }
}
