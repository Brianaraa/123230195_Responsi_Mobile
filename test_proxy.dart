import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print("Testing thingproxy...");
  final uri = Uri.parse('https://thingproxy.freeboard.io/fetch/https://www.freetogame.com/api/games');
  try {
    final response = await http.get(uri).timeout(Duration(seconds: 10));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Success!");
    }
  } catch(e) {
    print("Error: $e");
  }
}
