import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/data/models/tv_show_model.dart';

void main() async {
  final uri = Uri.parse('https://www.freetogame.com/api/games');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    final show = TvShow.fromJson(jsonList[0]);
    print("ID: ${show.id}");
    print("Name: ${show.name}");
    print("Image: ${show.displayImageUrl}");
    print("Release: ${show.displayRating}");
    print("Genres: ${show.genres}");
    print("Platform: ${show.status}");
    print("Publisher: ${show.publisher}");
    print("Developer: ${show.devaloper}");
    print("Summary: ${show.summary}");
  }
}
