import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_model.dart';

class ApiService {
  static const String baseUrl =
      "https://www.freetogame.com/api/games";

  Future<List<Game>> fetchGames() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) {
        return Game(
          id: e['id'],
          name: e['title'],
          image: e['thumbnail'],
          rating: 0.0, // API ini tidak ada rating
          genres: [e['genre']],
        );
      }).toList();
    } else {
      throw Exception("Failed to load games");
    }
  }

  Future<List<Game>> searchGames(String query) async {
    final allGames = await fetchGames();

    return allGames
        .where((game) =>
            game.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  Future<GameDetail> fetchGameDetail(int id) async {
  final response = await http.get(
    Uri.parse("https://www.freetogame.com/api/game?id=$id"),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return GameDetail.fromJson(data);
  } else {
    throw Exception("Failed detail");
  }
}
}


