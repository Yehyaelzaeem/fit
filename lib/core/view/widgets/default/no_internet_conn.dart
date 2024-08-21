
import 'package:flutter/material.dart';

import '../../../utils/strings.dart';
import 'app_buttons.dart';

class NoInternetConnection extends StatelessWidget {
  final Function refresh;

  NoInternetConnection({required this.refresh});

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
            Icons.warning,
            color: Colors.orange,
            size: 120,
          ),
          SizedBox(height: 8),
          Text(Strings().noInternetConnection),
          SizedBox(height: 8),
          kButtonDefault(Strings().retry, func: refresh),
        ],
      ),
    );
  }
}
