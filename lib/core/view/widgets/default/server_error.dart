
import 'package:flutter/material.dart';

import '../../../utils/strings.dart';
import 'app_buttons.dart';

class ServerErrorWidget extends StatelessWidget {
  final refresh;

  ServerErrorWidget({required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 8),
          Icon(
            Icons.error,
            color: Colors.red,
            size: 120,
          ),
          SizedBox(height: 8),
          Text(Strings().serverError),
          SizedBox(height: 8),
          kButtonDefault(Strings().retry, func: refresh),
        ],
      ),
    );
  }
}
