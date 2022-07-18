import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:aks/function/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _isDoneReading = false;
  PDFDocument document;
  int _pagesChanged = 1;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.asset);

    setState(() => _isLoading = false);
  }

  SnackBar createSnackBar(String message) {
    return SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge.color))),
      body: Center(
        child: _isLoading ?
          CircularProgressIndicator() :
          PDFViewer(
            document: document,
            zoomSteps: 1,
            pickerButtonColor: Colors.black,
            onPageChanged: (page) {
              _pagesChanged++;
              if(_pagesChanged == document.count) {
                _isDoneReading = true;
                AuthService.addUserPoints(_auth.currentUser.uid);
                final snackbar = createSnackBar("Terima kasih sudah membaca (+50 Poin)");

                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
          )
      )
    );
  }
}
