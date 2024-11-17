// // //
// // // import 'package:flutter/material.dart';
// // // import 'dart:math' as math;
// // //
// // // class ClockTimePicker extends StatefulWidget {
// // //   @override
// // //   _ClockTimePickerState createState() => _ClockTimePickerState();
// // // }
// // //
// // // class _ClockTimePickerState extends State<ClockTimePicker> {
// // //   TimeOfDay _selectedTime = TimeOfDay.now();
// // //
// // //   void _selectTime(BuildContext context) async {
// // //     final TimeOfDay? picked = await showTimePicker(
// // //       context: context,
// // //       initialTime: _selectedTime,
// // //     );
// // //     if (picked != null && picked != _selectedTime) {
// // //       setState(() {
// // //         _selectedTime = picked;
// // //       });
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("Clock Time Picker")),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: <Widget>[
// // //             Text(
// // //               "Selected Time: ${_selectedTime.format(context)}",
// // //               style: TextStyle(fontSize: 24),
// // //             ),
// // //             const SizedBox(height: 16),
// // //             GestureDetector(
// // //               onTap: () => _selectTime(context),
// // //               child: CustomPaint(
// // //                 size: Size(200, 200), // Custom clock size
// // //                 painter: ClockPainter(time: _selectedTime),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 24),
// // //             ElevatedButton(
// // //               onPressed: () => _selectTime(context),
// // //               child: Text("Select Time"),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class ClockPainter extends CustomPainter {
// // //   final TimeOfDay time;
// // //   ClockPainter({required this.time});
// // //
// // //   @override
// // //   void paint(Canvas canvas, Size size) {
// // //     final double radius = size.width / 2;
// // //     final Paint clockOutline = Paint()..color = Colors.grey.shade300;
// // //     final Paint clockCenter = Paint()..color = Colors.black;
// // //
// // //     // Draw clock circle
// // //     canvas.drawCircle(Offset(radius, radius), radius, clockOutline);
// // //
// // //     // Draw clock center
// // //     canvas.drawCircle(Offset(radius, radius), 5, clockCenter);
// // //
// // //     // Hour Hand
// // //     double hourRadians = (time.hour % 12) * math.pi / 6 + (time.minute * math.pi / 360);
// // //     final Paint hourHandPaint = Paint()
// // //       ..color = Colors.blue
// // //       ..strokeWidth = 6
// // //       ..strokeCap = StrokeCap.round;
// // //     Offset hourHandOffset = Offset(
// // //       radius + math.cos(hourRadians) * radius * 0.5,
// // //       radius + math.sin(hourRadians) * radius * 0.5,
// // //     );
// // //     canvas.drawLine(Offset(radius, radius), hourHandOffset, hourHandPaint);
// // //
// // //     // Minute Hand
// // //     double minuteRadians = time.minute * math.pi / 30;
// // //     final Paint minuteHandPaint = Paint()
// // //       ..color = Colors.red
// // //       ..strokeWidth = 4
// // //       ..strokeCap = StrokeCap.round;
// // //     Offset minuteHandOffset = Offset(
// // //       radius + math.cos(minuteRadians) * radius * 0.8,
// // //       radius + math.sin(minuteRadians) * radius * 0.8,
// // //     );
// // //     canvas.drawLine(Offset(radius, radius), minuteHandOffset, minuteHandPaint);
// // //
// // //     // Draw numbers around the clock
// // //     for (int i = 1; i <= 12; i++) {
// // //       double angle = (i * math.pi / 6) - math.pi / 2;
// // //       double x = radius + math.cos(angle) * (radius - 20);
// // //       double y = radius + math.sin(angle) * (radius - 20);
// // //       TextPainter textPainter = TextPainter(
// // //         text: TextSpan(text: i.toString(), style: TextStyle(fontSize: 20, color: Colors.black)),
// // //         textDirection: TextDirection.ltr,
// // //       );
// // //       textPainter.layout();
// // //       textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
// // //     }
// // //   }
// // //
// // //   @override
// // //   bool shouldRepaint(CustomPainter oldDelegate) => true;
// // // }
// //
// // // Widget to Display Selected Time
import 'package:flutter/material.dart';

class ClockTimeDisplay extends StatelessWidget {
  final TimeOfDay? time;
  final String label;

  const ClockTimeDisplay({
    Key? key,
    required this.time,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.access_time,
                size: 160,
                color: Colors.grey[300],
              ),
              Text(
                time != null
                    ? time!.format(context)
                    : 'Set $label Time',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// import 'package:app/core/resources/app_values.dart';
// import 'package:flutter/material.dart';
//
// class CustomTimePickerDialog extends StatefulWidget {
//   @override
//   _CustomTimePickerDialogState createState() => _CustomTimePickerDialogState();
// }
//
// class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
//   TimeOfDay selectedTime = TimeOfDay.now();
//   bool isAM = true;
//
//   // Method to update time
//   void _updateTime(TimeOfDay newTime) {
//     setState(() {
//       selectedTime = newTime;
//     });
//   }
//
//   // Toggle AM/PM
//   void _toggleAmPm() {
//     setState(() {
//       isAM = !isAM;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         height: deviceHeight*2/3,
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // Tabs (From/To)
//             DefaultTabController(
//               length: 2,
//               child: Column(
//                 children: [
//                   TabBar(
//                     indicatorColor: Colors.green,
//                     labelColor: Colors.green,
//                     unselectedLabelColor: Colors.grey,
//                     tabs: [
//                       Tab(text: 'From'),
//                       Tab(text: 'To'),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   // TabBarView to handle different times
//                   Container(
//                     height: 200,
//                     child: TabBarView(
//                       children: [
//                         _buildClock(),
//                         _buildClock(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Buttons (Cancel/OK)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('CANCEL'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Save logic here
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Custom Clock Widget
//   Widget _buildClock() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Clock face
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               height: 130,
//               width: 130,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.green[50],
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // Clock numbers
//                   for (int i = 1; i <= 12; i++)
//                     Positioned(
//                       top: 70 - 60 * (i % 6 == 0 ? 1 : 0.9),
//                       left: 70 - 60 * (i % 6 == 0 ? 1 : 0.9),
//                       child: Text(
//                         '$i',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   // Clock Hand
//                   Transform.rotate(
//                     angle: (selectedTime.hour % 12) * 30 * 3.14 / 180,
//                     child: Container(
//                       height: 60,
//                       width: 4,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 20,
//               child: Text(
//                 "${selectedTime.format(context)}",
//                 style: TextStyle(fontSize: 24),
//               ),
//             )
//           ],
//         ),
//         // Time and AM/PM Input
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Hours
//             _timeInput(
//               label: "Hour",
//               value: selectedTime.hourOfPeriod,
//               max: 12,
//               onChanged: (newValue) {
//                 _updateTime(TimeOfDay(hour: newValue, minute: selectedTime.minute));
//               },
//             ),
//             Text(':', style: TextStyle(fontSize: 24)),
//             // Minutes
//             _timeInput(
//               label: "Minute",
//               value: selectedTime.minute,
//               max: 59,
//               onChanged: (newValue) {
//                 _updateTime(TimeOfDay(hour: selectedTime.hour, minute: newValue));
//               },
//             ),
//             SizedBox(width: 20),
//             // AM/PM toggle
//             GestureDetector(
//               onTap: _toggleAmPm,
//               child: Text(
//                 isAM ? 'AM' : 'PM',
//                 style: TextStyle(fontSize: 24, color: Colors.green),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // Time input (hours and minutes)
//   Widget _timeInput({
//     required String label,
//     required int value,
//     required int max,
//     required Function(int) onChanged,
//   }) {
//     return Column(
//       children: [
//         Text(label),
//         Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.arrow_drop_up),
//               onPressed: () {
//                 if (value < max) onChanged(value + 1);
//               },
//             ),
//             Text(
//               value.toString().padLeft(2, '0'),
//               style: TextStyle(fontSize: 24),
//             ),
//             IconButton(
//               icon: Icon(Icons.arrow_drop_down),
//               onPressed: () {
//                 if (value > 0) onChanged(value - 1);
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }