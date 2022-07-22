import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:aks/function/get_profiledata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Pdf extends StatefulWidget {
  const Pdf(this.title, this.asset, this.cover);

  final title;
  final asset;
  final cover;

  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  bool _isLoading = true;
  bool _isDoneReading = false;
  bool firstTime = false;

  PDFDocument document;
  int _pagesChanged = 1;
  int lastPage = 0;
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
              if(page <= lastPage) {
                lastPage = lastPage;
              }
              else {
                lastPage = page;
                _pagesChanged++;
              }

              if(_pagesChanged == document.count && !_isDoneReading) {
                _isDoneReading = true;
                ProfileData.addBookRead(_auth.currentUser.uid, widget.cover, widget.asset, widget.title);

                final snackbar = createSnackBar("Terima kasih sudah membaca");
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
          ),
      )
    );
  }
}
