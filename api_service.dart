import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final List<String> _candidateBaseUrls = [
    'http://127.0.0.1:5000',
    'http://172.20.10.4:5000',
    'http://192.168.31.51:5000',
    'http://10.38.74.8:5000',
    'http://10.0.2.2:5000',
    'http://localhost:5000',
  ];

  static String _activeBaseUrl = 'http://127.0.0.1:5000';
  static String get baseUrl => _activeBaseUrl;
  static Future<String> resolveServerUrl() async {
    for (final base in _candidateBaseUrls) {
      try {
        final response = await http
            .get(Uri.parse('$base/health'))
            .timeout(const Duration(milliseconds: 1200));
        if (response.statusCode == 200) {
          _activeBaseUrl = base;
          debugPrint('Connected to Skin Cancer Backend at: $_activeBaseUrl');
          return _activeBaseUrl;
        }
      } catch (_) {
      }
    }
    return _activeBaseUrl;
  }

  static Future<Map<String, dynamic>> analyzeSkinWithPythonServer(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final filename = imageFile.path.split(Platform.pathSeparator).last;
    return analyzeSkinWithPythonServerBytes(bytes, filename: filename);
  }
  static Future<Map<String, dynamic>> analyzeSkinWithPythonServerBytes(
    Uint8List imageBytes, {
    String filename = 'skin_scan.jpg',
  }) async {
    await resolveServerUrl();
    final uri = Uri.parse('$_activeBaseUrl/predict-skin');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      ),
    );

    final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 422) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Server returned ${response.statusCode}: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> analyzeLungWithPythonServer(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final filename = imageFile.path.split(Platform.pathSeparator).last;
    return analyzeLungWithPythonServerBytes(bytes, filename: filename);
  }

  static Future<Map<String, dynamic>> analyzeLungWithPythonServerBytes(
    Uint8List imageBytes, {
    String filename = 'lung_scan.jpg',
  }) async {
    await resolveServerUrl();

    final uri = Uri.parse('$_activeBaseUrl/predict-lung');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      ),
    );

    final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 422) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Server returned ${response.statusCode}: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> analyzeBreastWithPythonServer(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final filename = imageFile.path.split(Platform.pathSeparator).last;
    return analyzeBreastWithPythonServerBytes(bytes, filename: filename);
  }

  static Future<Map<String, dynamic>> analyzeBreastWithPythonServerBytes(
    Uint8List imageBytes, {
    String filename = 'breast_scan.jpg',
  }) async {
    await resolveServerUrl();
    final uri = Uri.parse('$_activeBaseUrl/predict-breast');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      ),
    );

    final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 422) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Server returned ${response.statusCode}: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> analyzeUterineWithPythonServer(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final filename = imageFile.path.split(Platform.pathSeparator).last;
    return analyzeUterineWithPythonServerBytes(bytes, filename: filename);
  }

  static Future<Map<String, dynamic>> analyzeUterineWithPythonServerBytes(
    Uint8List imageBytes, {
    String filename = 'uterine_scan.jpg',
  }) async {
    await resolveServerUrl();
    final uri = Uri.parse('$_activeBaseUrl/predict-uterine');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      ),
    );

    final streamedResponse = await request.send().timeout(const Duration(seconds: 15));
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200 || response.statusCode == 422) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Server returned ${response.statusCode}: ${response.body}');
    }
  }
}
