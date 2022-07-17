import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class Pdf extends StatefulWidget {
  const Pdf(this.title, this.asset);

  final title;
  final asset;

  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.asset);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge.color))),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(),)
            : PDFViewer(document: document, zoomSteps: 1, pickerButtonColor: Colors.black),
      ),
    );
  }
}