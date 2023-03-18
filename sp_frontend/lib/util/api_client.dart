import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

final client = APIClient('https://splitee-backend.onrender.com/api/');

class APIClient {
  final String baseUrl;
  late final Client httpClient;

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  APIClient(this.baseUrl) {
    httpClient = Client();
  }

  void setToken(String token) {
    _headers["Authorization"] = "Bearer $token";
  }

  Map _decodeResponse(Response response) {
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print(response.body);
      }
    }

    if (response.body.isEmpty) return {};

    try {
      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print(response.body);
      }

      return {"error": "An error occurred. Please try again later."};
    }
  }

  Future<Map> get(String path) async {
    final response =
        await httpClient.get(Uri.parse(baseUrl + path), headers: _headers);

    return _decodeResponse(response);
  }

  Future<Map> post(String path, Map<String, dynamic> body) async {
    final response = await httpClient.post(Uri.parse(baseUrl + path),
        headers: _headers, body: jsonEncode(body));

    return _decodeResponse(response);
  }

  Future<Map> put(String path, Map<String, dynamic> body) async {
    final response = await httpClient.put(Uri.parse(baseUrl + path),
        headers: _headers, body: jsonEncode(body));

    return _decodeResponse(response);
  }

  Future<Map> delete(String path, Map<String, dynamic> body) async {
    final response = await httpClient.delete(Uri.parse(baseUrl + path),
        headers: _headers, body: jsonEncode(body));

    return _decodeResponse(response);
  }
}
