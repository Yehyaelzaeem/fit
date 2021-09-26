import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class CustomImageViewer extends StatelessWidget {
  final String image ;
  const CustomImageViewer({Key? key,required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
          imageProvider: NetworkImage(image),
        )
    );
  }
}