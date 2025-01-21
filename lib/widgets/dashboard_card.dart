import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/button.dart';

class DashboardCard extends StatelessWidget {
  final String date;
  final String details;
  final String address;
  final String buttonText;
  final VoidCallback buttonAction;
  final String iconPath;
  final String status;

  const DashboardCard({
    super.key,
    required this.date,
    required this.details,
    required this.address,
    required this.buttonText,
    required this.buttonAction,
    required this.iconPath,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 12),
                Text(date, style: bold20),
              ],
            ),
            const SizedBox(height: 8),
            Text(details, style: regular14),
            const SizedBox(height: 20),
            Text(address, style: regular16),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Status', style: bold16),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        border: status == 'Pending'
                            ? Border.all(
                                color: grey3,
                                width: 2,
                              )
                            : null,
                        color: status == 'Cancel'
                            ? red
                            : status == 'Pending'
                                ? white
                                : green,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 24),
                      child: Text(status,
                          style: bold12.copyWith(
                              color:
                                  status == 'Cancel' ? Colors.white : black)),
                    ),
                  ],
                ),
                Button(
                  borderColor: grey3,
                  text: buttonText,
                  color: white,
                  textColor: grey1,
                  onPressed: buttonAction,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
