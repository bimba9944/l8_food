import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/widgets/appbar_widget.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HistoryOfAllOrdersScreen extends StatefulWidget {
  const HistoryOfAllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<HistoryOfAllOrdersScreen> createState() => _HistoryOfAllOrdersScreenState();
}

class _HistoryOfAllOrdersScreenState extends State<HistoryOfAllOrdersScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> allMeals = [];
  List<String> allDates = [];
  List<String> allEmails = [];

  @override
  void initState() {
    _getMeals();
    super.initState();
  }

  Future<void> _getMeals() async {
    await FirebaseFirestore.instance.collection('orders').get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          allMeals.add('${docSnapshot.data().values.last}');
          allDates.add(docSnapshot.data().values.first);
          allEmails.add(docSnapshot.data().values.elementAt(4));
        }
      },
    );

    setState(() {});
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString('Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)), bounds: Rect.fromLTWH(0, 0, 500, 50));
    List<int> bytes = await document.save();
    document.dispose();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/Output.pdf');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/Output.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarWidget(
            iconButton: IconButton(
              icon: Icon(IconHelper.appbarbackIcon),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: allMeals.length,
                  itemBuilder: (context, int index) {
                    return ListTile(
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(allEmails[index]), Text(allDates[index])]),
                      subtitle: Text(allMeals[index]),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(onPressed: _createPDF, child: const Text('Export in PDF')),
          ],
        ),
      ),
    );
  }
}
