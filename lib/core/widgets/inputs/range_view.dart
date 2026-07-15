import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class MistRangeView extends StatelessWidget {
  final String label;
  final DateTime? date;
  final Function(DateTime time)? onDatePicked;
  const MistRangeView({
    super.key,
    required this.label,
    this.date,
    this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
          controller: TextEditingController(
            text: date == null
                ? "No date"
                : DateUtils.isSameDay(date, DateTime.now())
                ? "Today"
                : "${date!.day}/${date!.month}/${date!.year}",
          ),
          enabled: false,

          decoration: InputDecoration(
            label: label.text(),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            suffixIcon: IconButton(
              onPressed: () => _pickDate(context),
              icon: Iconify(Bx.calendar, color: Colors.grey),
            ),
          ),
        )
        .sizedBox(width: 130)
        .padding(EdgeInsets.all(8))
        .onTap(() => _pickDate(context));
  }

  void _pickDate(BuildContext context) async {
    final datePicker = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2001),
    );
    if (datePicker != null && onDatePicked != null) {
      onDatePicked!(datePicker);
    }
  }
}
