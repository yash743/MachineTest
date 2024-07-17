import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiHelper {
  final String _baseUrl = 'https://mmfinfotech.co/machine_test/api/';

  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }
}
