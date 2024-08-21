// import 'package:flutter/material.dart';

// import '../data/models/shop_info_response.dart';
// import '../utils/helper/echo.dart';

// class DropDownStringsList extends StatelessWidget {
//   final Function updateFunction;
//   final Function validateFunction;
//   final String value;
//   final String label;
//   final String hint;
//   final bool autoValidate;
//   final List<dynamic> items;

//   DropDownStringsList(
//       {@required this.updateFunction,
//       this.autoValidate = false,
//       @required this.value,
//       @required this.hint,
//       @required this.label,
//       @required this.validateFunction,
//       @required this.items});

//   @override
//   Widget build(BuildContext context) {
//     final List<DropdownMenuItem<String>> _dropDownMenuItems = items.map((item) {
//       String id, title;
//      if(item is String) {
//        id = item;
//        title = item;
//      }if(item is ShopTime) {
//        id = item.time;
//        title = item.time;
//      }

//      Echo('dropDownMenu  id $id , title $title');
//       return DropdownMenuItem<String>(
//         value: id,
//         child: Container(
//             child: Padding(
//           padding: const EdgeInsets.all(2.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         )),
//       );
//     }).toList();

//     return DropdownButtonFormField<String>(
//       isDense: true,
//       autovalidateMode: autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         errorStyle: TextStyle(color: Colors.redAccent),
//         hintStyle: TextStyle(fontSize: 12),
// //        suffixIcon: Icon(Icons.done, color: Colors.green),
//         labelText: label,
//         labelStyle: TextStyle(fontSize: 12),
//         hintText: hint,
//         prefixIcon: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Material(
//             child: Icon(
//               Icons.subject_outlined,
//             ),
//           ),
//         ),
//       ),
//       items: _dropDownMenuItems,
//       value: value,
//       onChanged: updateFunction,
//       onSaved: updateFunction,
//       validator: validateFunction,
//     );
//   }
// }
