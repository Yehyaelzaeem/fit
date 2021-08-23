import 'package:flutter/material.dart';
class PageLable extends StatelessWidget {
  final String name ;
  const PageLable({Key? key,required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(

      alignment: Alignment(0.01, -1.0),
      width: MediaQuery.of(context).size.width / 1.9,
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(15.0),
        ),
        color: const Color(0xFF414042),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              '${name}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2,),

          ],
        ),
      ),
    );
  }
}
