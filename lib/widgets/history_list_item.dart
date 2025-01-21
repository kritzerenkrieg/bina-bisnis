import 'package:flutter/material.dart';

class HistoryListItem extends StatelessWidget {
  final String date;
  final String details;
  final String address;
  final String status;
  final String buttonText;

  const HistoryListItem({
    super.key,
    required this.date,
    required this.details,
    required this.address,
    required this.status,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
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
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            date,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(details),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
