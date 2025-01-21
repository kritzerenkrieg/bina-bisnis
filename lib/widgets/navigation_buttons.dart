// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:buang_bijak/data/landing_page.dart';
import 'package:buang_bijak/theme.dart';

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mengarahkan kembali ke route utama '/'
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return false;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: iconNavFeature.map((route) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, route['route']);
            },
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: grey3),
                    boxShadow: [
                      BoxShadow(
                        color: grey2.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Icon(
                    route['icon'],
                    size: 30,
                    color: black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(route['title'], style: bold12.copyWith(color: grey2)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
