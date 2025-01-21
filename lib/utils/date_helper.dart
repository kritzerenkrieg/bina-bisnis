import 'package:intl/intl.dart';

// String formatPickupDate(DateTime timestamp) {
//   final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(timestamp);
//   final dayName = _getDayName(timestamp.weekday);

//   return '$dayName, $formattedDate';
// }

// String _getDayName(int weekday) {
//   const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
//   return days[weekday - 1];
// }

String formatPickupDate(DateTime timestamp) {
  final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(timestamp);

  return formattedDate;
}
