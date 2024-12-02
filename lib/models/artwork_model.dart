class Artwork {
  final int id;
  final String title;
  final String? altTitles;
  final String? artist;
  final String? description;
  final String? dimensions;
  final String? medium;
  final String? creditLine;
  final String? imageUrl;

  Artwork({
    required this.id,
    required this.title,
    this.altTitles,
    this.artist,
    this.description,
    this.dimensions,
    this.medium,
    this.creditLine,
    this.imageUrl,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      altTitles: json['alt_titles'],
      artist: json['artist_display'] ?? 'Unknown Artist',
      description: json['description'],
      dimensions: json['dimensions'],
      medium: json['medium_display'],
      creditLine: json['credit_line'],
      imageUrl: json['image_id'] != null
          ? 'https://www.artic.edu/iiif/2/${json['image_id']}/full/843,/0/default.jpg'
          : null,
    );
  }
}
