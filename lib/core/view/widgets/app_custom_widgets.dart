import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/navigation/navigation_services.dart';

Widget backAppBarNoTitle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            NavigationService.goBack(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 2),
      ],
    ),
  );
}
