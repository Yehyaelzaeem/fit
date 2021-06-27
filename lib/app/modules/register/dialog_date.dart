import 'package:app/app/utils/translations/strings.dart';
import 'package:flutter/material.dart';

class DialogDate extends StatefulWidget {
  final Function updateFunction;
  final String value;

  DialogDate({
    required this.updateFunction,
    required this.value,
  });

  @override
  _DialogDateState createState() => _DialogDateState();
}

class _DialogDateState extends State<DialogDate> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (DateTime.now().hour > 14)
      selectedDate = DateTime.now().add(Duration(days: 2));
    else
      selectedDate = DateTime.now().add(Duration(days: 1));
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime firstTimeCanCustomerOrder;
    if (DateTime.now().hour > 14)
      firstTimeCanCustomerOrder =
          DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 2));
    else
      firstTimeCanCustomerOrder =
          DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 1));

    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendar,
        context: context,
        locale: Locale('en'),
        initialDate: selectedDate!,
        firstDate: firstTimeCanCustomerOrder,
        lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 30)),


    );



    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formatDate = '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}';
        widget.updateFunction('$formatDate');
      });
    } else {
      String formatDate = '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}';
      widget.updateFunction('$formatDate');
    }
  }

  @override
  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: (){
//        _selectDate(context);
//      },
//      child: TextFormField(
//        enabled: false,
//        decoration: InputDecoration(
//          border: OutlineInputBorder(
//              borderSide: BorderSide(color: Colors.grey[700], width: 0.2)),
//          errorStyle: TextStyle(color: Colors.deepOrange),
//          hintStyle: TextStyle(fontSize: 9),
//          labelStyle: TextStyle(fontSize: 9),
//          labelText: YemString.date,
//          hintText: YemString.date,
//          prefixIcon: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Material(
//              child: Icon(
//                Icons.date_range,
//                color: YemColors().mainColor(1),
//              ),
//            ),
//          ),
//        ),
//        initialValue: widget.value,
//        onChanged: widget.updateFunction,
//        onSaved: widget.updateFunction,
//      ),
//    );

    return widget.value.isEmpty
        ? ListTile(
            onTap: () {
              _selectDate(context);
            },
            title: Text(Strings().birthdate, style: TextStyle(fontSize: 13)),
            leading: Icon(
              Icons.date_range,
              color: Colors.red,
            ),
//            trailing: Icon(Icons.keyboard_arrow_down),
          )
        : ListTile(
            onTap: () {
              _selectDate(context);
            },
            title: Text(widget.value, style: TextStyle(fontSize: 13)),
            leading: Icon(
              Icons.date_range,
              color: Colors.red,
            ),
//            trailing: Icon(Icons.keyboard_arrow_down),
          );
  }
}
