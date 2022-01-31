import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  Users({this.uid});
}

class Durations {
  final Timestamp daysFromNow;
  final int today;
  final int duratin;

  Durations({this.daysFromNow, this.today, this.duratin});
}

class NewBatchData {
  final String uid;
  final String date;
  final int numberOfEggs;
  final int unhatched;
  final int hatchRate;

  NewBatchData({
    this.uid,
    this.date,
    this.numberOfEggs,
    this.unhatched,
    this.hatchRate,
  });
}

class CurrentBatchData {
  final String uid;
  final String date;
  final int numberOfEggs;
  final int unhatched;
  final int hatchRate;

  CurrentBatchData({
    this.uid,
    this.date,
    this.numberOfEggs,
    this.unhatched,
    this.hatchRate,
  });
}
