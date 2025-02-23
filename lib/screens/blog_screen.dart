import 'package:flutter/material.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Blog',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logomini.png', // Placeholder for the logo
              height: 50,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  BlogCard(
                    title: 'Strategi Sukses untuk Mengembangkan UMKM di Era Modern',
                    content:
                    'Usaha Mikro, Kecil, dan Menengah (UMKM) adalah pilar penting perekonomian Indonesia. Namun, untuk mencapai kesuksesan, UMKM harus mampu beradaptasi dengan perubahan zaman dan...',
                  ),
                  BlogCard(
                    title:
                    'Meningkatkan Daya Saing UMKM di Era Digital: Strategi dan Peluang',
                    content:
                    'Usaha Mikro, Kecil, dan Menengah (UMKM) memainkan peran vital dalam perekonomian Indonesia, menyumbang sekitar 60% dari PDB dan menyerap lebih dari 90% tenaga kerja nasional. Namun...',
                  ),
                  BlogCard(
                    title:
                    'Investasi pada UMKM: Peluang Emas dengan Potensi Keuntungan Tinggi',
                    content:
                    'Investasi ke Usaha Mikro, Kecil, dan Menengah (UMKM) merupakan peluang emas yang sering kali diabaikan oleh banyak investor. Padahal, UMKM memiliki potensi besar untuk memberikan keuntungan yang menarik serta...',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'UMKM'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Blog'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) {
          String routeName;
          switch (index) {
            case 0:
              routeName = '/';
              break;
            case 1:
              routeName = '/umkm';
              break;
            case 2:
              routeName = '/blog';
              break;
            case 3:
              routeName = '/portfolio';
              break;
            case 4:
              routeName = '/profil-saya';
              break;
            default:
              routeName = '/';
          }
          Navigator.pushReplacementNamed(context, routeName);
        },
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final String title;
  final String content;

  const BlogCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(content, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Baca Artikel →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
