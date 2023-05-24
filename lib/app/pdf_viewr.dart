import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFPreview extends StatefulWidget {
  final String res, name;

  const PDFPreview({Key? key, required this.res, required this.name})
      : super(key: key);

  @override
  _PDFPreviewState createState() => _PDFPreviewState();
}

class _PDFPreviewState extends State<PDFPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: PRIMART_COLOR,
          title: Text('${widget.name}', style: TextStyle(color: Colors.white)),
          centerTitle: true),
      body: PDF().fromUrl(
        widget.res,
        placeholder: (double progress) => Center(
          child: Center(child: CircularLoadingWidget()),
        ),
        errorWidget: (dynamic error) =>
            Center(child: Text(error.toString())),
      ),
    );
  }
}
