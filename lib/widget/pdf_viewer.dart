import 'dart:io';

import 'package:c2c/enums/text_color_type.dart' show TextColorType;
import 'package:c2c/widget/app_scaffold.dart';
import 'package:c2c/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatelessWidget {
  final File file;
  const PdfViewerPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        titleText: 'PDF Viewer',
        backgroundColor: TextColorType.bgColor.resolve(context),
        showBottomDivider: true,
      ),
      body: PDFView(
        filePath: file.path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        backgroundColor: TextColorType.bgColor.resolve(context),
        onError: (error) {
          debugPrint(error.toString());
        },
        onPageError: (page, error) {
          debugPrint('$page: ${error.toString()}');
        },
      ),
    );
  }
}