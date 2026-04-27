class Game {
  final int id;
  final String name;
  final String image;
  final double rating;
  final List<String> genres;

  Game({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.genres,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      name: json['title'] ?? '',
      image: json['thumbnail'] ?? '',
      rating: 0.0, // API ini tidak ada rating
      genres: json['genre'] != null
          ? [json['genre'].toString()]
          : [],
    );
  }
}

class GameDetail {
  final String description;
  final String? os;
  final String? processor;
  final String? memory;
  final String? graphics;

  GameDetail({
    required this.description,
    this.os,
    this.processor,
    this.memory,
    this.graphics,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    final req = json['minimum_system_requirements'];

    return GameDetail(
      description: json['description'] ?? '',
      os: req?['os'],
      processor: req?['processor'],
      memory: req?['memory'],
      graphics: req?['graphics'],
    );
  }
}