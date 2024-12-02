import 'package:flutter/material.dart';
import '../models/artwork_model.dart';
import '../services/api_service.dart';
import 'artwork_detail_page.dart';
import 'about_page.dart';
import 'HomePage.dart';

class ArtworksListPage extends StatefulWidget {
  @override
  _ArtworksListPageState createState() => _ArtworksListPageState();
}

class _ArtworksListPageState extends State<ArtworksListPage> {
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seni',
          style: TextStyle(fontSize: 28),
        ),
        elevation: 10,
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade900,
        foregroundColor: Colors.white,
        actions: [
          // Search Icon
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ArtworkSearchDelegate(),
              );
            },
          ),
          // Menu Options
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Home') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              } else if (value == 'About') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutPage(),
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
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.deepPurple.shade800,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search artworks...",
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
            ),
            const SizedBox(height: 16),
            // Artwork List
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

                        return Card(
                          color: Colors.deepPurple.shade800,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: artwork.imageUrl != null
                                  ? Image.network(
                                      artwork.imageUrl!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Icon(Icons.image_not_supported,
                                              color: Colors.white70),
                                    )
                                  : const Icon(Icons.image,
                                      size: 50, color: Colors.white70),
                            ),
                            title: Text(
                              artwork.title ?? 'Untitled',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              artwork.artist ?? 'Unknown Artist',
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
                          ),
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
