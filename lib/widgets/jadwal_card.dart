import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../screens/detail_pickup.dart';

class JadwalCard extends StatelessWidget {
  final String time;
  final String date;
  final String wasteType;
  final String address;
  final String status;
  final String orderId;
  final bool isRevised;
  final String? rejectedReason;

  const JadwalCard({
    super.key,
    required this.time,
    required this.date,
    required this.wasteType,
    required this.address,
    required this.status,
    required this.orderId,
    required this.isRevised,
    required this.rejectedReason,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    time,
                    style: bold16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: status == 'Success'
                          ? green
                          : status == 'Pending'
                              ? grey3
                              : red,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Text(status, style: bold12.copyWith(color: black)),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('$date - ', style: regular14),
                  Text(
                    wasteType,
                    style: regular14,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                address,
                style: regular14,
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Selengkapnya',
                color: white,
                borderColor: grey3,
                textColor: black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPickup(
                        status: status,
                        time: time,
                        date: date,
                        wasteType: wasteType,
                        address: address,
                        orderId: orderId,
                        isRevised: isRevised,
                        rejectedReason: rejectedReason,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
