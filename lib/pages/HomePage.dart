import 'dart:math';
import 'package:flutter/material.dart';
import '../models/artwork_model.dart';
import '../services/api_service.dart';
import 'artwork_detail_page.dart';
import 'package:seni/pages/about_page.dart';
import 'artworklist_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seni', style: TextStyle(fontSize: 28)),
        elevation: 10,
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ArtworkSearchDelegate(),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Home') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigating to Home...')),
                );
              } else if (value == 'About') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutPage(),
                  ),
                );
              } else if (value == 'ArtworkList') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtworksListPage(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Home',
                child: Text('Home'),
              ),
              const PopupMenuItem(
                value: 'ArtworkList',
                child: Text('Artwork List'),
              ),
              const PopupMenuItem(
                value: 'About',
                child: Text('About'),
              ),
            ],
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.deepPurple.shade800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Seni!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore timeless artworks from around the world.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search Bar with button next to it
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search by name...",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.deepPurple.shade700,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.deepPurple.shade600,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value.trim();
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            searchQuery = searchController.text.trim();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RandomArtworksCarousel(apiService: apiService),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Artwork>>(
                future: apiService.fetchArtworks(),
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
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No artworks found.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final artworks = snapshot.data!
                        .where((artwork) =>
                            artwork.imageUrl != null &&
                            artwork.title != null &&
                            artwork.artist != null &&
                            (searchQuery.isEmpty ||
                                artwork.title!
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase())))
                        .toList();

                    return ListView.builder(
                      itemCount: artworks.length,
                      itemBuilder: (context, index) {
                        final artwork = artworks[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              artwork.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(
                            artwork.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            artwork.artist!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArtworkDetailPage(artworkId: artwork.id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RandomArtworksCarousel extends StatelessWidget {
  final ApiService apiService;
  RandomArtworksCarousel({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Artwork>>(
      future: apiService.fetchArtworks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No artworks found.',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          final artworks = snapshot.data!
              .where((artwork) =>
                  artwork.imageUrl != null &&
                  artwork.title != null &&
                  artwork.artist != null)
              .toList();

          final random = Random();
          final randomArtworks = (artworks..shuffle(random)).take(6).toList();

          return Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.deepPurple.shade700,
                  width: 1.0,
                ),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: randomArtworks.length,
              itemBuilder: (context, index) {
                final artwork = randomArtworks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArtworkDetailPage(artworkId: artwork.id),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(artwork.imageUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class ArtworkSearchDelegate extends SearchDelegate {
  final ApiService apiService = ApiService();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Artwork>>(
      future: apiService.fetchArtworks(),
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
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No artworks found.',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          final artworks = snapshot.data!
              .where((artwork) =>
                  artwork.title!.toLowerCase().contains(query.toLowerCase()) ||
                  artwork.artist!.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: artworks.length,
            itemBuilder: (context, index) {
              final artwork = artworks[index];
              return ListTile(
                title: Text(
                  artwork.title!,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  artwork.artist!,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArtworkDetailPage(artworkId: artwork.id),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
