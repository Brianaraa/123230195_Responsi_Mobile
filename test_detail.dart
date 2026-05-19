import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/data/models/tv_show_model.dart';

void main() async {
  final uri = Uri.parse('https://www.freetogame.com/api/game?id=540');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    try {
      final show = TvShow.fromJson(json.decode(response.body));
      print("Detail ID: ${show.id}");
      print("Screenshots: ${show.screenshots}");
    } catch (e) {
      print("Error: $e");
    }
  } else {
    print("Failed: ${response.statusCode}");
  }
}
