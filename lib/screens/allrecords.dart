import 'package:flutter/material.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import '../models/allrecords_list.dart';
import '../models/recordmodel.dart';

class AllRecords extends StatefulWidget {
  @override
  _AllRecordsState createState() => _AllRecordsState();
}

class _AllRecordsState extends State<AllRecords> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Record>>.value(
        value: DatabaseService().records,
        initialData: [],
        child: Scaffold(
          backgroundColor: Colors.grey[600],
          appBar: AppBar(
            elevation: 0,
            title: Text('All Records',
                style: TextStyle(
                  fontFamily: 'customFonts2',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  letterSpacing: 0.2,
                )),
            backgroundColor: Colors.grey[900],
          ),
          body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: new AssetImage("assets/images/chick.jpeg"),
                fit: BoxFit.cover,
              )),
              child: RecordList()),
        ));
  }
}
