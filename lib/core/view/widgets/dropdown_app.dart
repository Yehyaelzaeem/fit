import 'package:flutter/material.dart';

class DropDownStringsList extends StatelessWidget {
  final updateFunction;
  final validateFunction;
  final String? value;
  final String? label;
  final String hint;
  final List<dynamic> items;

  DropDownStringsList(
      {required this.updateFunction,
      required this.value,
      required this.hint,
      required this.label,
      required this.validateFunction,
      required this.items});

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> _dropDownMenuItems = items.map((item) {
      late String id, title;
      if (item is String) {
        id = item;
        title = item;
      }
      // if (item is SingleSubject) {
      //   id = '${item.id!}';
      //   title = item.title!;
      // }

      // Echo('dropDownMenu  id $id , title $title');
      return DropdownMenuItem<String>(
        value: id,
        child: Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        )),
      );
    }).toList();

    return DropdownButtonFormField<String>(
      isDense: true,
      autovalidateMode: /*  autoValidate ? AutovalidateMode.always :  */ AutovalidateMode
          .disabled,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: TextStyle(color: Colors.redAccent),
          hintStyle: TextStyle(fontSize: 12),
//        suffixIcon: Icon(Icons.done, color: Colors.green),
          labelText: label,
          labelStyle: TextStyle(fontSize: 12),
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)
          // prefixIcon: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Material(
          //     child: Icon(
          //       Icons.subject_outlined,
          //     ),
          //   ),
          // ),
          ),
      items: _dropDownMenuItems,
      value: value,
      onChanged: updateFunction,
      onSaved: updateFunction,
      validator: validateFunction,
    );
  }
}
