import 'package:flutter/material.dart';
import 'package:buang_bijak/theme.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DatePickerWidget(
      {super.key,
      required this.onDateSelected,
      required InputDecoration decoration,
      DateTime? initialDate});

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _selectedDate = DateTime.now();

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      // Notify parent widget about the selected date
      widget.onDateSelected(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: grey3, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              '${_selectedDate.toLocal()}'
                  .split(' ')[0], // Display date in YYYY-MM-DD format
              style: const TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
