import 'package:flutter/material.dart';
import '../theme.dart';

class CustomDropdown extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    String? value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: bold16),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text(
            selectedValue ?? "Pilih $title", // Show selected value or fallback to default hint
            style: regular14.copyWith(color: grey2),
          ),
          isExpanded: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: grey3, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: grey3, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: grey3, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: grey3, width: 2),
            ),
          ),
          dropdownColor: white,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: regular14.copyWith(color: grey2),
              ), // Style for dropdown items
            );
          }).toList(),
        ),
      ],
    );
  }
}
