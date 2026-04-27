import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<GameProvider>(context, listen: false)
            .fetchGames());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game List App",
          style: TextStyle(
          fontWeight: FontWeight.bold)
          ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 102, 63, 4), //
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (val) => provider.search(val),
              decoration: const InputDecoration(
                hintText: "Search game...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // 📦 CONTENT
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error.isNotEmpty
                    ? Center(
                        child: Text(
                          provider.error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : provider.games.isEmpty
                        ? const Center(child: Text("No games found"))
                        : GridView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: provider.games.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (_, i) {
                              final game = provider.games[i];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DetailPage(game: game),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900], // 🔥 DARK BG
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey, // 🔥 BORDER LINE
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 🖼 IMAGE
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top:
                                                      Radius.circular(12)),
                                          child: Image.network(
                                            game.image,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      // 📝 NAME ONLY
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          game.name,
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          )
        ],
      ),
    );
  }
}