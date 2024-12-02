import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gambar Pembuat
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                    'assets/akbar_bimantara.jpg'), // Ganti dengan path gambar
                backgroundColor: Colors.grey.shade800,
              ),
              const SizedBox(height: 16),
              // Nama Pembuat
              const Text(
                'Akbar Bimantara',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mobile App Developer',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Divider(
                height: 32,
                color: Colors.deepPurple,
                thickness: 1,
              ),
              // Deskripsi Aplikasi
              const Text(
                'This app connects users to the Art Institute of Chicago\'s vast collection of masterpieces. '
                'It allows users to browse artworks, view detailed information, and appreciate the stories behind each creation. '
                'With a sleek and user-friendly design, the app aims to bring art closer to enthusiasts and learners. '
                '\n\nFeatures include: '
                '\n- Browsing artworks by category.'
                '\n- Viewing high-quality images of artworks.'
                '\n- Detailed descriptions including the artist, medium, and dimensions.'
                '\n- A seamless and visually appealing interface.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              // Pesan dari Pembuat
              Card(
                color: Colors.deepPurple.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'A Message from the Creator',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hello! I\'m Akbar Bimantara, the creator of this app. My goal is to make art accessible to everyone, regardless of their location. '
                        'By leveraging the power of modern technology, we can explore art collections from the comfort of our homes. I hope this app enhances your appreciation of art and inspires you to learn more about the world of creativity. Thank you for using this app!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
