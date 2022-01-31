import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'recordmodel.dart';
import '../screens/record_tile.dart';

class RecordList extends StatefulWidget {
  @override
  _RecordListState createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  Widget build(BuildContext context) {
    final records = Provider.of<List<Record>>(context) ?? [];
    records.forEach((records) {
      print(records.date);
      print(records.numberOfEggs);
      print(records.unhatched);
      print(records.hatchRate);
    });

    return ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return RecordTile(records: records[index]);
        });
  }
}
