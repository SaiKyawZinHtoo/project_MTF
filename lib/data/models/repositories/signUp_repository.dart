import 'dart:convert';
import 'package:http/http.dart' as http;

class CoachRepository {
  final String baseUrl = 'http://172.16.0.205:5500';

  Future<Map<String, dynamic>> registerCoach(
      Map<String, dynamic> coachData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/coach/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(coachData),
    );

    if (response.statusCode == 200) {
      // Successful response
      return json.decode(response.body);
    } else {
      // Handle error response
      throw Exception('Failed to register coach');
    }
  }
}
