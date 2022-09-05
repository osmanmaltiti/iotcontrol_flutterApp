import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Power extends StatefulWidget {
  @override
  _PowerState createState() => _PowerState();
}

class _PowerState extends State<Power> {
  final firestoreInstance = FirebaseFirestore.instance;
  String status;
  String value;
  Timer _timer;
  int upTemp;
  int downTemp;
  int upHumid;
  final rtdbRef = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
      currentStatus();
    });
  }

  void currentStatus() async {
    final reference = rtdbRef.reference();
    await reference
        .child('FirebaseIOT')
        .child('powerToggle')
        .once()
        .then((DataSnapshot data) {
      setState(() {
        var onoroff = data.value;
        int retval = onoroff as int;
        if (retval == 1) {
          setState(() {
            status = "ON";
          });
        }
        if (retval == 0) {
          setState(() {
            status = "OFF";
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[600],
        appBar: AppBar(
          elevation: 0,
          title: Text('Control',
              style: TextStyle(
                fontFamily: 'customFonts2',
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 0.2,
              )),
          backgroundColor: Colors.grey[900],
          actions: <Widget>[
            TextButton(
                child: Text('Motor Rotation',
                    style: TextStyle(
                      fontFamily: 'customFonts2',
                      fontSize: 22,
                      color: Colors.red,
                    )),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      builder: (context) {
                        return Container(
                          height: 300,
                          color: Colors.black45,
                          child: Column(
                            children: [
                              Text('Manual Motor Rotation',
                                  style: TextStyle(
                                      fontFamily: 'customFonts2',
                                      fontSize: 35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text('Backward',
                                          style: TextStyle(
                                            fontFamily: 'customFonts2',
                                            fontSize: 25,
                                            color: Colors.black,
                                          )),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                          alignment: Alignment.topLeft,
                                          icon: FaIcon(
                                              FontAwesomeIcons.chevronUp,
                                              size: 50,
                                              color: Colors.redAccent),
                                          onPressed: () async {
                                            final reference =
                                                rtdbRef.reference();
                                            await reference
                                                .child('FirebaseIOT')
                                                .update({'motorPosition': 0});
                                            Navigator.pop(context);
                                          }),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                          alignment: Alignment.topLeft,
                                          icon: FaIcon(
                                              FontAwesomeIcons.chevronDown,
                                              size: 50,
                                              color: Colors.green),
                                          onPressed: () async {
                                            final reference =
                                                rtdbRef.reference();
                                            await reference
                                                .child('FirebaseIOT')
                                                .update({'motorPosition': 1});

                                            Navigator.pop(context);
                                          }),
                                    ),
                                    SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('Forward',
                                          style: TextStyle(
                                            fontFamily: 'customFonts2',
                                            fontSize: 25,
                                            color: Colors.black,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }),
          ],
        ),
        body: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: new AssetImage("assets/images/control.jpeg"),
              fit: BoxFit.cover,
            )),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    width: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                        height: 150,
                        width: 370,
                        padding: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Current Status:',
                                style: TextStyle(
                                    fontFamily: 'customFonts2',
                                    fontSize: 30,
                                    color: Colors.white,
                                    letterSpacing: 1),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                status ?? "...",
                                style: TextStyle(
                                    fontFamily: 'customFonts2',
                                    fontSize: 50,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber),
                              )
                            ])),
                  ),
                  SizedBox(
                    height: 20,
                    width: 340,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      status = "ON";
                                    });

                                    final reference = rtdbRef.reference();
                                    await reference
                                        .child('FirebaseIOT')
                                        .update({'powerToggle': 1});
                                  },
                                  child: Text(
                                    "On",
                                    style: TextStyle(
                                        fontFamily: 'customFonts2',
                                        fontSize: 30,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      status = "OFF";
                                    });

                                    final reference = rtdbRef.reference();
                                    await reference
                                        .child('FirebaseIOT')
                                        .update({'powerToggle': 0});
                                  },
                                  child: Text(
                                    "Off",
                                    style: TextStyle(
                                        fontFamily: 'customFonts2',
                                        fontSize: 30,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ])),
                  Container(
                      height: 338.4,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.only(
                              topLeft: (Radius.circular(10)),
                              topRight: (Radius.circular(10)))),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text("UPDATE",
                              style: TextStyle(
                                  fontFamily: 'customFonts2',
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(right: 230, top: 20),
                            child: Text("Temperature",
                                style: TextStyle(
                                  fontFamily: 'customFonts2',
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 130,
                                decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'CustomFonts2',
                                      fontSize: 20),
                                  decoration: new InputDecoration(
                                    labelText: "Max",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                        borderSide: new BorderSide(
                                            color: Colors.white)),
                                    enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                        borderSide: new BorderSide(
                                            color: Colors.white)),
                                  ),
                                  onChanged: (val) {
                                    setState(() => upTemp = int.parse(val));
                                  },
                                ),
                              ),
                              Container(
                                width: 130,
                                decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'CustomFonts2',
                                      fontSize: 20),
                                  decoration: new InputDecoration(
                                    labelText: "Min",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                        borderSide: new BorderSide(
                                            color: Colors.white)),
                                    enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                        borderSide: new BorderSide(
                                            color: Colors.white)),
                                  ),
                                  onChanged: (val) {
                                    setState(() => downTemp = int.parse(val));
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 9, bottom: 20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: IconButton(
                                      icon: Icon(Icons.check_circle,
                                          size: 45, color: Colors.white30),
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              backgroundColor: Colors.grey[700],
                                              content: Container(
                                                height: 150,
                                                width: 400,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Center(
                                                    child: SpinKitWave(
                                                  color: Colors.white,
                                                  size: 50,
                                                )),
                                              )),
                                        );
                                        final reference = rtdbRef.reference();
                                        await reference
                                            .child('FirebaseIOT')
                                            .update({
                                          'tempMax': upTemp,
                                          'tempMin': downTemp
                                        });
                                        Timer(
                                          Duration(milliseconds: 5),
                                          () => Navigator.pop(context),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 255, top: 20),
                            child: Text("Humidity",
                                style: TextStyle(
                                  fontFamily: 'customFonts2',
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 0, 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  width: 270,
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'CustomFonts2',
                                        fontSize: 20),
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      labelText: "Min",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10),
                                          borderSide: new BorderSide(
                                              color: Colors.white)),
                                      enabledBorder: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10),
                                          borderSide: new BorderSide(
                                              color: Colors.white)),
                                    ),
                                    onChanged: (val) {
                                      setState(() => upHumid = int.parse(val));
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: IconButton(
                                      icon: Icon(Icons.check_circle,
                                          size: 45, color: Colors.white30),
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                              backgroundColor: Colors.grey[700],
                                              content: Container(
                                                height: 150,
                                                width: 400,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Center(
                                                    child: SpinKitWave(
                                                  color: Colors.white,
                                                  size: 50,
                                                )),
                                              )),
                                        );
                                        final reference = rtdbRef.reference();
                                        await reference
                                            .child('FirebaseIOT')
                                            .update({'humidMin': upHumid});
                                        Timer(
                                          Duration(milliseconds: 5),
                                          () => Navigator.pop(context),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                        ],
                      ))
                ]),
          ),
        ));
  }
}
