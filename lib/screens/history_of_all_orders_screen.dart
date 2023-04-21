import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l8_food/helpers/icon_helper.dart';
import 'package:l8_food/helpers/pdf_api.dart';
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
  late String firstDate;
  late String lastDate;

  @override
  void initState() {
    _getMeals();
    super.initState();
  }

  Future<void> _getMeals() async {
    firstDate = _convertDateTime().first;
    lastDate = _convertDateTime().last;
    await FirebaseFirestore.instance
        .collection('orders')
        .where('date', whereIn: _convertDateTime())
        .get()
        .then(
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

  List<String> _convertDateTime() {
    List<String> dayss = [];
    for (var day in generateDate(5)) {
      dayss.add('${DateFormat('EEEE').format(day)}' + ',' + '${day.day}.${day.month}.${day.year}');
    }
    return dayss;
  }

  List<DateTime> generateDate(int count) {
    int weekends = 0;
    return List.generate(
      count,
      (index) {
        DateTime tempDate =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday)).add(Duration(days: index + weekends));
        if (tempDate.weekday > 5) {
          int offset = 7 - tempDate.weekday + 1;
          tempDate = tempDate.add(Duration(days: offset));
          weekends += offset;
        }
        return tempDate;
      },
    );
  }

  String _buildString(){
    var str = '';
    for(var i in allMeals){
      for(var i1 in allDates){
        for(var i2 in allEmails){
          str = str + i.toString() + i1.toString() + i2.toString();
        }
      }
    }
    return str;
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    document.pages.add().graphics.drawString(_buildString(), PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)), bounds: const Rect.fromLTWH(0, 0, 500, 50));
    List<int> bytes = await document.save();
    document.dispose();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/Output.pdf');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/Output.pdf');
  }

  // Future<void> _pdf() async{
  //   final pdfFile = await PdfApi.generateCenteredText(_list());
  //   PdfApi.openFile(pdfFile);
  // }

  ListView _buildListView(){
    return ListView.builder(
      itemCount: allMeals.length,
      itemBuilder: (context, int index) {
        return ListTile(
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(allEmails[index]), Text(allDates[index])]),
          subtitle: Text(allMeals[index]),
        );
      },
    );
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
                child: _buildListView(),
              ),
            ),
            ElevatedButton(onPressed: _createPDF, child: const Text('Export in PDF')),
          ],
        ),
      ),
    );
  }
}
