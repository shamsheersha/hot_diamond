import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ImageCloudinaryService {
  final Cloudinary cloudinary;

  ImageCloudinaryService()
      : cloudinary = Cloudinary.signedConfig(
            apiKey: dotenv.env['CLOUDINARY_API_KEY'] ?? '831846349287297',
            apiSecret: dotenv.env['CLOUDINARY_API_SECRET'] ??
                'TNXG1e_cSzCx1B0DvnOs7Njjk_I',
            cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? 'dxityv8dk');

  // CREATE - Upload a single image
  Future<String> uploadImage(String imagePath) async {
    try {
      String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      if (cloudName.isEmpty) {
        throw Exception('Cloudinary cloud name is not set');
      }

      final String cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
      final String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';
      if (uploadPreset.isEmpty) {
        throw Exception('Cloudinary upload preset is not set');
      }

      final File imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();

      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: imagePath.split('/').last,
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        return data['secure_url'];
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // READ - Get image details
  Future<Map<String, dynamic>> getImageDetails(String imageUrl) async {
    try {
      final publicId = extractPublicId(imageUrl);
      if (publicId == null) {
        throw Exception('Invalid image URL');
      }

      final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      final String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
      final String apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String toSign = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
      var signature = sha1.convert(utf8.encode(toSign)).toString();

      final response = await http.get(
        Uri.parse(
            'https://api.cloudinary.com/v1_1/$cloudName/image/details')
            .replace(queryParameters: {
          'public_id': publicId,
          'timestamp': timestamp.toString(),
          'api_key': apiKey,
          'signature': signature,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get image details');
      }
    } catch (e) {
      throw Exception('Failed to get image details: $e');
    }
  }

  // UPDATE - Update an existing image
  Future<String> updateImage(String oldImageUrl, String newImagePath) async {
    try {
      // First delete the old image
      if (oldImageUrl.isNotEmpty) {
        await deleteImage(oldImageUrl);
      }
      
      // Then upload the new image
      return await uploadImage(newImagePath);
    } catch (e) {
      throw Exception('Failed to update image: $e');
    }
  }

  // DELETE - Delete an image
  Future<bool> deleteImage(String imageUrl) async {
    try {
      final publicId = extractPublicId(imageUrl);
      if (publicId == null) {
        throw Exception('Invalid image URL');
      }

      final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      final String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
      final String apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String toSign = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
      var signature = sha1.convert(utf8.encode(toSign)).toString();

      final response = await http.post(
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy'),
        body: {
          'public_id': publicId,
          'timestamp': timestamp.toString(),
          'api_key': apiKey,
          'signature': signature,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['result'] == 'ok';
      } else {
        throw Exception('Failed to delete image');
      }
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Helper method to extract public ID from URL
  String? extractPublicId(String imageUrl) {
    try {
      final Uri uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final uploadIndex = pathSegments.indexOf('upload');
      
      if (uploadIndex != -1 && uploadIndex < pathSegments.length - 1) {
        final String fullPath = pathSegments
            .sublist(uploadIndex + 1)
            .join('/')
            .split('.')
            .first;
        return fullPath.replaceFirst(RegExp(r'v\d+/'), '');
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}