import 'package:flutter/material.dart';
import '../models/game_model.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          game.image.isNotEmpty
              ? Image.network(game.image,
                  height: 120, width: double.infinity, fit: BoxFit.cover)
              : Container(height: 120, color: Colors.grey),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              game.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("⭐ ${game.rating}"),
          ),
        ],
      ),
    );
  }
}