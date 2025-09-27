import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wellwait_app/utils/colors.dart';

class DatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await selectDate();
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
          widget.onDateSelected(pickedDate);
        }
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
        decoration: BoxDecoration(
          color: Color(0xffECECEC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset("assets/icons/date_picker_icon.svg",height: 12,width: 12),
            SizedBox(width: 12),
            Text(
              _selectedDate != null
                  ? DateFormat('dd/MM/yy').format(_selectedDate!)
                  : "Select Date",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Color(0xff7E7E7E)),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens the Date Picker Dialog with green theme
  Future<DateTime?> selectDate() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
