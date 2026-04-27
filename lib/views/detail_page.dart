import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/api_service.dart';

class DetailPage extends StatefulWidget {
  final Game game;

  const DetailPage({super.key, required this.game});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? detail;
  bool isLoading = true;

  final api = ApiService();

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  void loadDetail() async {
    try {
      final response = await api.fetchGameDetail(widget.game.id);
      detail = {
        "description": response.description,
        "os": response.os,
        "processor": response.processor,
        "memory": response.memory,
        "graphics": response.graphics,
      };
    } catch (e) {}

    setState(() {
      isLoading = false;
    });
  }

  // 🔥 WIDGET CARD REUSABLE
  Widget buildSection({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900], // background gelap
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        
        backgroundColor: const Color.fromARGB(255, 102, 63, 4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 IMAGE
            buildSection(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(widget.game.image),
              ),
            ),

            // 📝 TITLE
            buildSection(
              child: Text(
                widget.game.name,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // 📖 DESCRIPTION
            buildSection(
              child: Text(
                detail?['description'] ?? "-",
                textAlign: TextAlign.justify,
                style: const TextStyle(color: Colors.white),
              ),
            ),

            // 💻 MINIMUM SPEC
            buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Minimum Requirements",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "OS: ${detail?['os'] ?? '-'}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Processor: ${detail?['processor'] ?? '-'}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Memory: ${detail?['memory'] ?? '-'}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Graphics: ${detail?['graphics'] ?? '-'}",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}