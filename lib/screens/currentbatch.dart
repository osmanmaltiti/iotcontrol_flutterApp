import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iotcontrol/services/database.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/database.dart';
import 'loading.dart';

class CurrentBatch extends StatefulWidget {
  @override
  _CurrentBatchState createState() => _CurrentBatchState();
}

class _CurrentBatchState extends State<CurrentBatch> {
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  bool loading = false;
  int count = 3;

  String _currentDate;
  int _currentEggs;
  int _currentUnhatched;
  int _currentHatchRate;
  int total;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return StreamBuilder<CurrentBatchData>(
        stream: DatabaseService(uid: user.uid).currentBatchData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.grey[700],
              body: Center(
                  child: SpinKitWave(
                color: Colors.white,
                size: 50,
              )),
            );
          }
          CurrentBatchData currentBatchData = snapshot.data;
          return loading
              ? Loading()
              : Scaffold(
                  backgroundColor: Colors.grey[600],
                  appBar: AppBar(
                      elevation: 0,
                      title: Text('Current Batch',
                          style: TextStyle(
                            fontFamily: 'customFonts2',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            letterSpacing: 0.2,
                          )),
                      backgroundColor: Colors.grey[900]),
                  body: Form(
                    key: _formKey,
                    child: Center(
                        child: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints.expand(
                            width: double.infinity, height: 310),
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                        ),
                        child: Column(children: <Widget>[
                          Row(children: <Widget>[
                            SizedBox(
                              height: 70,
                              width: 20,
                            ),
                            Text(
                              "Start Date: ",
                              style: TextStyle(
                                  fontFamily: 'customFonts2',
                                  fontSize: 27,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              width: 230,
                              child: TextFormField(
                                  readOnly: true,
                                  initialValue: currentBatchData.date,
                                  style: TextStyle(fontSize: 20),
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                        borderSide: new BorderSide()),
                                    fillColor: Colors.white,
                                  )),
                            )
                          ]),
                          Row(children: <Widget>[
                            SizedBox(
                              height: 70,
                              width: 20,
                            ),
                            Text(
                              "Number Of Eggs: ",
                              style: TextStyle(
                                  fontFamily: 'customFonts2',
                                  fontSize: 27,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              width: 170,
                              child: TextFormField(
                                  readOnly: true,
                                  initialValue:
                                      currentBatchData.numberOfEggs.toString(),
                                  style: TextStyle(fontSize: 20),
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                        borderSide: new BorderSide()),
                                    fillColor: Colors.white,
                                    labelText: '',
                                  )),
                            )
                          ]),
                          Row(children: <Widget>[
                            SizedBox(
                              height: 70,
                              width: 20,
                            ),
                            Text(
                              "Unhatched: ",
                              style: TextStyle(
                                  fontFamily: 'customFonts2',
                                  fontSize: 27,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              width: 188,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25),
                                      borderSide: new BorderSide()),
                                  fillColor: Colors.white,
                                  labelText: 'Enter No.',
                                ),
                                onChanged: (val) {
                                  setState(
                                      () => _currentUnhatched = int.parse(val));
                                },
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.check_circle,
                                    size: 30, color: Colors.black),
                                onPressed: () {
                                  _currentHatchRate = (((currentBatchData
                                                      .numberOfEggs -
                                                  _currentUnhatched) /
                                              currentBatchData.numberOfEggs) *
                                          100)
                                      .round();

                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                        backgroundColor: Colors.grey[700],
                                        content: Container(
                                          height: 150,
                                          width: 400,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Center(
                                              child: SpinKitWave(
                                            color: Colors.white,
                                            size: 50,
                                          )),
                                        )),
                                  );

                                  Timer(
                                    Duration(seconds: 1),
                                    () => Navigator.pop(context),
                                  );
                                })
                          ]),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });

                              firestoreInstance
                                  .collection("Records")
                                  .doc()
                                  .set({
                                'date': _currentDate ?? currentBatchData.date,
                                'numberOfEggs': _currentEggs ??
                                    currentBatchData.numberOfEggs,
                                'unhatched': _currentUnhatched ??
                                    currentBatchData.unhatched,
                                'hatchRate': _currentHatchRate ??
                                    currentBatchData.hatchRate,
                              });
                              Navigator.of(context)
                                  .popUntil((_) => count-- <= 0);
                              await FirebaseFirestore.instance
                                  .collection('Records')
                                  .doc(user.uid)
                                  .delete();
                            },
                            icon: Icon(Icons.save_alt,
                                size: 27, color: Colors.white),
                            label: Text('Save',
                                style: TextStyle(
                                    fontFamily: 'customFonts2',
                                    color: Colors.white,
                                    fontSize: 27)),
                          )
                        ]),
                      ),
                    )),
                  ));
        });
  }
}
