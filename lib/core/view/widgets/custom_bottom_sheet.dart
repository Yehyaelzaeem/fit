import 'package:flutter/material.dart';

void CustomSheet(
    {required BuildContext context, required Widget widget, double? hight}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          child: Container(
            height: hight ?? MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )),
            child: widget,
          ),
        );
      });
}
