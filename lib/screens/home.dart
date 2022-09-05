import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iotcontrol/screens/allrecords.dart';
import 'package:iotcontrol/screens/control.dart';
import 'package:iotcontrol/screens/newbatch.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final rtdbRef = FirebaseDatabase.instance;
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateTime today = DateTime.now();
  DateTime twentyOneDaysFromNow = DateTime.now().add(new Duration(days: 22));
  int currentDuratin;
  String _timeUntil;
  Timer _timer;
  String _retrievedTemp;
  String _retrievedHumidity;

  @override
  void initState() {
    super.initState();
    startTimer();
    retrieveTempReading();
    retrieveHumidReading();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      Timestamp duration = (await FirebaseFirestore.instance
              .collection('Records')
              .doc('Duration')
              .get())
          .data()['daysFromNow'];

      Duration _timeUntilDue = duration.toDate().difference(DateTime.now());
      int _daysUntil = _timeUntilDue.inDays;

      setState(() {
        if (_daysUntil > 0) {
          _timeUntil = _daysUntil.toString();
        } else {
          _timeUntil = 'Time!!';
        }
      });
    });
  }

  void retrieveTempReading() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final reference = rtdbRef.reference();
      await reference
          .child('FirebaseIOT')
          .child('temperature')
          .once()
          .then((DataSnapshot data) {
        setState(() {
          var temp = data.value;
          _retrievedTemp = temp.toString() + '  ';
        });
      });
    });
  }

  void retrieveHumidReading() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final reference = rtdbRef.reference();
      await reference
          .child('FirebaseIOT')
          .child('humidity')
          .once()
          .then((DataSnapshot data) {
        setState(() {
          var humid = data.value;
          _retrievedHumidity = humid.toString() + '  ';
        });
      });
    });
  }

  void logOut() async {
    await _auth.signOut();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        elevation: 0,
        title: Text("MONITORING SYSTEM",
            style: TextStyle(
              fontFamily: 'customFonts2',
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 0.2,
            )),
        actions: <Widget>[
          TextButton.icon(
              label: Text('Log Out',
                  style: TextStyle(
                    fontFamily: 'customFonts2',
                    fontSize: 15,
                    color: Colors.red,
                  )),
              icon: Icon(Icons.person, color: Colors.red),
              onPressed: () {
                logOut();
              }),
        ],
        backgroundColor: Colors.grey[900],
      ),
      body: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: new AssetImage("assets/images/chick.jpeg"),
            fit: BoxFit.cover,
          )),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Icon(Icons.timer, color: Colors.black),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Duration",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'customFonts2',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 90),
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(_timeUntil ?? '---',
                                style: TextStyle(
                                    fontFamily: 'customFonts',
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            Text('days left',
                                style: TextStyle(
                                    fontFamily: 'customFonts',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                    height: 310,
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                    decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(width: 15),
                          Icon(Icons.waves, color: Colors.black),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Temperature",
                              style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.black,
                                  fontFamily: 'customFonts2')),
                          SizedBox(width: 85),
                          Icon(Icons.cloud, color: Colors.grey[800]),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Humidity",
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.black,
                                fontFamily: 'customFonts2'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              height: 170,
                              width: 170,
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(_retrievedTemp ?? '---',
                                      style: TextStyle(
                                          fontFamily: 'customFonts3',
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                  Text('°C',
                                      style: TextStyle(
                                          fontFamily: 'customFonts3',
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                ],
                              )),
                          SizedBox(
                            width: 33,
                          ),
                          Container(
                              height: 170,
                              width: 170,
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(_retrievedHumidity ?? '---',
                                      style: TextStyle(
                                          fontFamily: 'customFonts3',
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                  Text('%',
                                      style: TextStyle(
                                          fontFamily: 'customFonts3',
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                ],
                              ))
                        ],
                      )
                    ])),
                SizedBox(height: 81.4),
                Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.only(
                            topLeft: (Radius.circular(10)),
                            topRight: (Radius.circular(10)))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            backgroundColor: Colors.grey[800],
                                            content: Container(
                                              height: 200,
                                              child: Column(children: <Widget>[
                                                SizedBox(height: 25),
                                                Container(
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: TextButton.icon(
                                                      onPressed: () async {
                                                        await firestoreInstance
                                                            .collection(
                                                                "Records")
                                                            .doc("Duration")
                                                            .set({
                                                          'daysFromNow':
                                                              Timestamp.fromDate(
                                                                  twentyOneDaysFromNow),
                                                          'today': Timestamp
                                                              .fromDate(today),
                                                        });

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      icon: Icon(
                                                          Icons.arrow_upward,
                                                          color: Colors.black),
                                                      label: Text('Start',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'customFonts',
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 22))),
                                                ),
                                                SizedBox(height: 50),
                                                Container(
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: TextButton.icon(
                                                    onPressed: () async {
                                                      await firestoreInstance
                                                          .collection("Records")
                                                          .doc("Duration")
                                                          .update({
                                                        'daysFromNow':
                                                            Timestamp.fromDate(
                                                                twentyOneDaysFromNow),
                                                        'today':
                                                            Timestamp.fromDate(
                                                                today),
                                                      });
                                                      final reference =
                                                          rtdbRef.reference();
                                                      await reference
                                                          .child('FirebaseIOT')
                                                          .update({
                                                        'temperature': 30,
                                                        'humidity': 90
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: Icon(
                                                      Icons.refresh,
                                                      color: Colors.black,
                                                    ),
                                                    label: Text('Reset',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'customFonts',
                                                            color: Colors.black,
                                                            fontSize: 22)),
                                                  ),
                                                )
                                              ]),
                                            )));
                                  },
                                  icon: Icon(Icons.timer,
                                      color: Colors.white, size: 28)),
                              Text('Timer',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (c, a1, a2) => Power(),
                                          transitionsBuilder:
                                              (c, anim, a2, child) =>
                                                  FadeTransition(
                                                      opacity: anim,
                                                      child: child),
                                          transitionDuration:
                                              Duration(milliseconds: 200)),
                                    );
                                  },
                                  icon: Icon(Icons.power_settings_new,
                                      color: Colors.white, size: 28)),
                              Text('Control',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                              height: 200,
                                              color: Colors.grey[700],
                                              child: Column(children: <Widget>[
                                                SizedBox(height: 25),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[800],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: TextButton.icon(
                                                      onPressed: () async {
                                                        return showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                AlertDialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .amber,
                                                                    title: Text(
                                                                        "Batch Created",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'customFonts',
                                                                            fontSize:
                                                                                33,
                                                                            fontWeight: FontWeight
                                                                                .bold)),
                                                                    content: Text(
                                                                        "Proceed to Enter Records                           ",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                22)),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.of(context).pop();
                                                                            User
                                                                                user =
                                                                                _auth.currentUser;
                                                                            firestoreInstance.collection('Records').doc(user.uid).set(
                                                                              {
                                                                                'duration': 1,
                                                                                'date': '$now',
                                                                                'numberOfEggs': 0,
                                                                                'unhatched': 0,
                                                                                'hatchRate': 0,
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text('OK'))
                                                                    ]));
                                                      },
                                                      icon: Icon(
                                                        Icons.note_add,
                                                        color: Colors.black,
                                                        size: 26,
                                                      ),
                                                      label: Text(
                                                          "Start New Batch",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'customFonts',
                                                              fontSize: 25,
                                                              color: Colors
                                                                  .amber))),
                                                  width: 350,
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[800],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: TextButton.icon(
                                                      onPressed: () async {
                                                        Navigator.push(
                                                            context,
                                                            PageRouteBuilder(
                                                                pageBuilder: (c,
                                                                        a1,
                                                                        a2) =>
                                                                    NewBatch(),
                                                                transitionsBuilder: (c,
                                                                        anim,
                                                                        a2,
                                                                        child) =>
                                                                    FadeTransition(
                                                                        opacity:
                                                                            anim,
                                                                        child:
                                                                            child),
                                                                transitionDuration:
                                                                    Duration(
                                                                        milliseconds:
                                                                            200)));
                                                      },
                                                      icon: Icon(Icons.note_add,
                                                          size: 26,
                                                          color: Colors.black),
                                                      label: Text(
                                                          "Enter Records",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'customFonts',
                                                              fontSize: 25,
                                                              color: Colors
                                                                  .amber))),
                                                  width: 350,
                                                ),
                                              ]));
                                        });
                                  },
                                  icon: Icon(
                                    Icons.note_add,
                                    color: Colors.white,
                                    size: 26,
                                  )),
                              Text('Batch',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) =>
                                                AllRecords(),
                                            transitionsBuilder:
                                                (c, anim, a2, child) =>
                                                    FadeTransition(
                                                        opacity: anim,
                                                        child: child),
                                            transitionDuration:
                                                Duration(milliseconds: 200)));
                                  },
                                  icon: Icon(
                                    Icons.archive,
                                    color: Colors.white,
                                    size: 26,
                                  )),
                              Text('Records',
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ]))
              ]),
        ),
      ),
    );
  }
}
