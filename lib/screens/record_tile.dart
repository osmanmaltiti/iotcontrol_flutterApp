import 'package:flutter/material.dart';
import '../models/recordmodel.dart';

class RecordTile extends StatelessWidget {
  final Record records;
  RecordTile({this.records});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Card(
            color: Colors.black54,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: ListTile(
                title: Row(
                  children: <Widget>[
                    Text("Date: ",
                        style: TextStyle(
                            fontFamily: 'customFonts2',
                            fontSize: 18,
                            color: Colors.white)),
                    SizedBox(
                      width: 230,
                    ),
                    Text(records.date,
                        style: TextStyle(
                            fontFamily: 'customFonts2',
                            fontSize: 18,
                            color: Colors.white)),
                  ],
                ),
                subtitle: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Total Eggs: ",
                          style: TextStyle(
                              fontFamily: 'customFonts2',
                              fontSize: 18,
                              color: Colors.white)),
                      SizedBox(
                        width: 227,
                      ),
                      Text('${records.numberOfEggs} ',
                          style: TextStyle(
                              fontFamily: 'customFonts2',
                              fontSize: 18,
                              color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Unhatched Eggs: ",
                          style: TextStyle(
                              fontFamily: 'customFonts2',
                              fontSize: 18,
                              color: Colors.white)),
                      SizedBox(
                        width: 190,
                      ),
                      Text('${records.unhatched} ',
                          style: TextStyle(
                              fontFamily: 'customFonts2',
                              fontSize: 18,
                              color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Hatch Rate: ",
                          style: TextStyle(
                              fontFamily: 'customFonts2',
                              fontSize: 18,
                              color: Colors.white)),
                      SizedBox(
                        width: 223,
                      ),
                      Text('${records.hatchRate} %',
                          style: TextStyle(
                              fontFamily: 'customFonts2',
                              fontSize: 18,
                              color: Colors.white)),
                    ],
                  )
                ]))));
  }
}
