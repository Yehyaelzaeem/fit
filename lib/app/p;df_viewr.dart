import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFPreview extends StatefulWidget {
  final String res;

  const PDFPreview({Key? key, required this.res}) : super(key: key);

  @override
  _PDFPreviewState createState() => _PDFPreviewState();
}

class _PDFPreviewState extends State<PDFPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Recourse', style: TextStyle(color: Colors.white)), centerTitle: true),
      body: Stack(
        children: [
          PDF().fromUrl(
            widget.res,
            placeholder: (double progress) => Center(child: Text("Loading PDF  ... "),),
            errorWidget: (dynamic error) => Center(child: Text(error.toString())),
          ),
        ],
      ),
    );
  }
}
