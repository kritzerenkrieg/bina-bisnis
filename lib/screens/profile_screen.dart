import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 60,
          ),
          const SizedBox(height: 16),
          const Text('Nama Pengguna', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          const Text('Email: pengguna@example.com'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement logout
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
