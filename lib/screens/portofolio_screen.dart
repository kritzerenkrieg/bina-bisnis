import 'package:flutter/material.dart';

class PortofolioScreen extends StatelessWidget {
  const PortofolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Portofolio',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total asetmu',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Rp 0 👁️',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Total profit Rp 0 (▲ 0%)',
              style: TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Mitra Pendanaan UMKM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('Mitra UMKM', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Sisa Pokok', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Bagi Hasil', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/nodata.png', // Placeholder for illustration
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Belum ada mitra yang Anda danai',
                    style: TextStyle(color: Colors.grey),
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
        currentIndex: 3,
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
