import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';

import 'app_buttons.dart';

class MessageErrorWidget extends StatelessWidget {
  final Function refresh;
  final String message;

  MessageErrorWidget({required this.message, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          kTextHeader(message),
          SizedBox(height: 8),
          kButtonDefault(Strings().retry, func: refresh),
        ],
      ),
    );
  }
}
