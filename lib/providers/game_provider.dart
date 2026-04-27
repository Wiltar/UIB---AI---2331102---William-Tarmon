import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameProvider extends ChangeNotifier {
  List<Game> games = [];
  bool isLoading = false;
  String error = "";

  final ApiService api = ApiService();

  // ================= FETCH =================
  Future<void> fetchGames() async {
    try {
      isLoading = true;
      error = "";
      notifyListeners();

      final data = await api.fetchGames();
      games = data;

      // SAVE FULL CACHE (bukan cuma nama)
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        'cache',
        jsonEncode(data.map((e) => {
              'id': e.id,
              'name': e.name,
              'image': e.image,
              'rating': e.rating,
              'genres': e.genres,
            }).toList()),
      );
    } catch (e) {
      error = "Failed to fetch data, loading cache...";

      final prefs = await SharedPreferences.getInstance();
      final cache = prefs.getString('cache');

      if (cache != null) {
        List data = jsonDecode(cache);
        games = data.map((e) {
          return Game(
            id: e['id'],
            name: e['name'],
            image: e['image'],
            rating: (e['rating'] ?? 0).toDouble(),
            genres: List<String>.from(e['genres'] ?? []),
          );
        }).toList();
      } else {
        games = [];
      }
    }

    isLoading = false;
    notifyListeners();
  }

  // ================= SEARCH =================
  Future<void> search(String query) async {
    try {
      isLoading = true;
      error = "";
      notifyListeners();

      if (query.isEmpty) {
        await fetchGames();
        return;
      }

      final result = await api.searchGames(query);
      games = result;
    } catch (e) {
      error = "Search failed";
    }

    isLoading = false;
    notifyListeners();
  }
}