import 'package:app/app/utils/translations/strings.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:flutter/material.dart';

class EmptyErrorWidget extends StatelessWidget {
  final Function refresh;

  EmptyErrorWidget({required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 8),
          Image.asset(
            'assets/img/ic_empty.png',
            width: MediaQuery.of(context).size.width / 1.4,
          ),
          SizedBox(height: 20),
          kTextHeader(Strings().emptyMessage),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
