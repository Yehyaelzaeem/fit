import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomImageViewer extends StatelessWidget {
  final String image;
  final String tite;
  const CustomImageViewer({Key? key, required this.image, required this.tite})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: PRIMART_COLOR,
          title: Text("$tite", style: TextStyle(color: Colors.white)),
          centerTitle: true),
      body: Container(child: PhotoView(imageProvider: NetworkImage(image))),
    );
  }
}
