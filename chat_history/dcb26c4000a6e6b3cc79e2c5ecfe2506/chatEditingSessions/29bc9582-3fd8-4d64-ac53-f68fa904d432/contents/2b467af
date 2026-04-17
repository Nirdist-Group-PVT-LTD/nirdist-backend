import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FileUploadService {
  static const String baseUrl = 'http://localhost:3000/api';
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Future<String> uploadPostMedia(File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/posts/upload'),
      );

      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      request.files.add(
        await http.MultipartFile.fromPath('media', file.path),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        return data['url'];
      } else {
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> uploadProfileImage(File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/users/upload-avatar'),
      );

      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      request.files.add(
        await http.MultipartFile.fromPath('avatar', file.path),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        return data['url'];
      } else {
        throw Exception('Failed to upload avatar');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> uploadAudio(File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/sounds/upload'),
      );

      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      request.files.add(
        await http.MultipartFile.fromPath('audio', file.path),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        return data['url'];
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      rethrow;
    }
  }
}
