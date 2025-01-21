import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String address;
  final String buttonText;

  const HomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.address,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(subtitle),
          const SizedBox(height: 16),
          Text(
            address,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
