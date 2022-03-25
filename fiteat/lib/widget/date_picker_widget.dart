import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {

  Color color;
  String userDate;
  Color buttonColor;

  DatePickerWidget({Key? key ,required this.color,required this.userDate,required this.buttonColor}): super(key: key);
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState(color : color, userDate: userDate,buttonColor: buttonColor);
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime date = DateTime(0);
  Color color;
  String userDate;
  Color buttonColor;
  _DatePickerWidgetState({required this.color,required this.userDate,required this.buttonColor});

  String getText() {
    if (date.year == 0) {
      return userDate ;
    } else {
      return DateFormat('dd-MMMM-yyyy').format(date);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
      return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Date of Birth',
          style: TextStyle(
            color: color,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
      Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: buttonColor,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: color)),
        minWidth: MediaQuery.of(context).size.width / 2  ,
        onPressed: () => pickDate(context),
        child: FittedBox(
            child: Text(
              getText(),
              style: TextStyle(fontSize:16, color: color),
            ),
          ),
        ),
      ),
    
      ],
    );
  }

  Future pickDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();

    if(date.year !=0)
    {
      currentDate = date;
    }

    final newDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }
}
