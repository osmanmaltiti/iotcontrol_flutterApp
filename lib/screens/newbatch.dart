import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iotcontrol/screens/currentbatch.dart';
import 'package:iotcontrol/services/database.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/database.dart';
import 'loading.dart';

class NewBatch extends StatefulWidget {
  @override
  _NewBatchState createState() => _NewBatchState();
}

class _NewBatchState extends State<NewBatch> {
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  //form value
  String _currentDate;
  int _currentEggs;
  int _currentUnhatched;
  int _currentHatchRate;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return StreamBuilder<NewBatchData>(
        stream: DatabaseService(uid: user.uid).newBatchData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.grey[700],
                body: Column(children: [
                  SizedBox(height: 280, width: 500),
                  SpinKitWave(
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Go to Start New Batch",
                    style: TextStyle(
                        fontFamily: 'customFonts2',
                        fontSize: 30,
                        color: Colors.white),
                  ),
                  SizedBox(height: 301),
                  Container(
                    width: 500,
                    color: Colors.grey[800],
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Back",
                          style: TextStyle(
                              fontFamily: 'customFonts2',
                              fontSize: 20,
                              color: Colors.white)),
                    ),
                  )
                ]));
          }
          NewBatchData newBatchData = snapshot.data;
          return loading
              ? Loading()
              : Scaffold(
                  backgroundColor: Colors.grey[600],
                  appBar: AppBar(
                    elevation: 0,
                    title: Text('Start New Batch',
                        style: TextStyle(
                          fontFamily: 'customFonts2',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          letterSpacing: 0.2,
                        )),
                    backgroundColor: Colors.grey[900],
                  ),
                  body: Form(
                      key: _formKey,
                      child: Center(
                          child: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints.expand(
                              width: double.infinity, height: 370),
                          decoration: BoxDecoration(
                            color: Colors.grey[350],
                          ),
                          child: Column(children: <Widget>[
                            Row(children: <Widget>[
                              SizedBox(
                                height: 100,
                                width: 20,
                              ),
                              Text(
                                "Start Date: ",
                                style: TextStyle(
                                    fontFamily: 'customFonts2',
                                    fontSize: 29,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 40,
                                width: 224,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                        borderSide: new BorderSide()),
                                    labelText: newBatchData.date,
                                  ),
                                  onChanged: (val) {
                                    setState(() => _currentDate = val);
                                  },
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              SizedBox(
                                height: 40,
                                width: 20,
                              ),
                              Text(
                                "Number Of Eggs: ",
                                style: TextStyle(
                                    fontFamily: 'customFonts2',
                                    fontSize: 28,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 40,
                                width: 167,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10),
                                          borderSide: new BorderSide()),
                                      labelText:
                                          newBatchData.numberOfEggs.toString()),
                                  onChanged: (val) {
                                    setState(
                                        () => _currentEggs = int.parse(val));
                                  },
                                ),
                              )
                            ]),
                            SizedBox(
                              height: 60,
                            ),

                            ElevatedButton.icon(
                              onPressed: () async {
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
                                User user = _auth.currentUser;
                                await DatabaseService(uid: user.uid)
                                    .setUserData(
                                  _currentDate ?? newBatchData.date,
                                  _currentEggs ?? newBatchData.numberOfEggs,
                                  _currentUnhatched ?? newBatchData.unhatched,
                                  _currentHatchRate ?? newBatchData.hatchRate,
                                );

                                Timer(
                                  Duration(milliseconds: 5),
                                  () => Navigator.pop(context),
                                );
                              },
                              icon: Icon(
                                Icons.save_alt,
                                size: 27,
                              ),
                              label: Text('Save',
                                  style: TextStyle(
                                      fontFamily: 'customFonts2',
                                      fontSize: 30)),
                            ),

                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextButton.icon(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) =>
                                                CurrentBatch(),
                                            transitionsBuilder:
                                                (c, anim, a2, child) =>
                                                    FadeTransition(
                                                        opacity: anim,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 200))
                                        // MaterialPageRoute(
                                        //     builder: (context) => CurrentBatch()),
                                        );
                                  },
                                  icon: Icon(Icons.note, size: 30),
                                  label: Text(
                                    "Update Current Batch",
                                    style: TextStyle(
                                        fontFamily: 'customFonts',
                                        fontSize: 25,
                                        color: Colors.white),
                                  )),
                              width: 350,
                            ), //FlatButton.icon(onPressed: () async {await DatabaseService()},icon: Icon(Icons.new_releases),label: Text('New Batch')),
                          ]),
                        ),
                      ))));
        });
  }
}
