import 'package:flutter/material.dart';
import 'package:html/parser.dart'; // Untuk menghapus format HTML
import 'package:seni/models/artwork_model.dart';
import 'package:seni/services/api_service.dart';

class ArtworkDetailPage extends StatelessWidget {
  final int artworkId;

  ArtworkDetailPage({super.key, required this.artworkId});

  final ApiService apiService = ApiService();

  // Fungsi untuk menghapus tag HTML
  String parseHtmlToPlainText(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Artwork Detail'),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: FutureBuilder<Artwork>(
        future: apiService.fetchArtworkDetail(artworkId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Artwork not found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final artwork = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bagian Gambar Artwork
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      image: artwork.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(artwork.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: artwork.imageUrl == null
                        ? const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                  ),

                  // Bagian Informasi Artwork
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.deepPurple.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul Artwork
                            Text(
                              artwork.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Nama Artis
                            Text(
                              artwork.artist ?? 'Unknown Artist',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const Divider(height: 32, color: Colors.grey),

                            // Deskripsi
                            if (artwork.description != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  parseHtmlToPlainText(artwork.description!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                              ),

                            // Informasi Tambahan
                            const SizedBox(height: 16),
                            _buildInfoRow(
                              icon: Icons.color_lens_outlined,
                              label: 'Medium',
                              value: artwork.medium,
                            ),
                            _buildInfoRow(
                              icon: Icons.straighten,
                              label: 'Dimensions',
                              value: artwork.dimensions,
                            ),
                            _buildInfoRow(
                              icon: Icons.museum_outlined,
                              label: 'Credit Line',
                              value: artwork.creditLine,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Widget untuk Baris Informasi
  Widget _buildInfoRow({IconData? icon, required String label, String? value}) {
    if (value == null || value.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple.shade300),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
