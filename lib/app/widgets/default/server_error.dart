import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:flutter/material.dart';

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
