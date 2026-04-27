import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> get(String endpoint) async{
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      return _handleResponse(response);
    } catch(e){
      throw Exception(e);
    }
  }

    Future<dynamic> post(String endpoint, Map<String, dynamic> data) async{
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data)
        );
      return _handleResponse(response);
    } catch(e){
      throw Exception(e);
    }
  }

    Future<dynamic> put(String endpoint, Map<String, dynamic> data) async{
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data)
        );
      return _handleResponse(response);
    } catch(e){
      throw Exception(e);
    }
  }

    Future<void> delete(String endpoint) async{
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
      return _handleResponse(response);
    } catch(e){
      throw Exception(e);
    }
  }

  dynamic _handleResponse(http.Response response){
    if (response.statusCode >= 200 && response.statusCode < 300){
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else{
      throw Exception('Server error : ${response.statusCode}');
    }
  }

}