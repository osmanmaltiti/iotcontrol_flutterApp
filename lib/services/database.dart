import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iotcontrol/models/recordmodel.dart';
import '../models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({
    this.uid,
  });

  //collection reference
  final CollectionReference recordCollection =
      FirebaseFirestore.instance.collection('Records');

  Future setUserData(
      String date, int numberOfEggs, int unhatched, int hatchRate) async {
    return await recordCollection.doc(uid).set({
      'date': date,
      'numberOfEggs': numberOfEggs,
      'unhatched': unhatched,
      'hatchRate': hatchRate,
    }, SetOptions(merge: true));
  }

  Future setDuration(Timestamp daysFromNow, int today, int duratin) async {
    return await recordCollection.doc("Duration").set({
      'daysFromNow': daysFromNow,
      'today': today,
      'duratin': duratin,
    }, SetOptions(merge: true));
  }

  //record list from snapshot
  List<Record> _recordListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Record(
        date: doc.get('date') ?? '',
        numberOfEggs: doc.get('numberOfEggs') ?? 0,
        unhatched: doc.get('unhatched') ?? 0,
        hatchRate: doc.get('hatchRate') ?? 0,
      );
    }).toList();
  }

  // newbatch data from snapshot
  NewBatchData _newBatchDataFromSnapshot(DocumentSnapshot snapshot) {
    return NewBatchData(
      uid: uid,
      date: snapshot.get('date'),
      numberOfEggs: snapshot.get('numberOfEggs'),
      unhatched: snapshot.get('unhatched'),
      hatchRate: snapshot.get('hatchRate'),
    );
  }

  // currentbatch data from snapshot
  CurrentBatchData _currentBatchDataFromSnapshot(DocumentSnapshot snapshot) {
    return CurrentBatchData(
      uid: uid,
      date: snapshot.get('date'),
      numberOfEggs: snapshot.get('numberOfEggs'),
      unhatched: snapshot.get('unhatched'),
      hatchRate: snapshot.get('hatchRate'),
    );
  }

  // duration data from snapshot
  Durations _durationDataFromSnapshot(DocumentSnapshot snapshot) {
    return Durations(
      daysFromNow: snapshot.get('daysFromNow'),
      today: snapshot.get('today'),
      duratin: snapshot.get('duratin'),
    );
  }

  //get records stream
  Stream<List<Record>> get records {
    return recordCollection
        .orderBy("date", descending: true)
        .snapshots()
        .map(_recordListFromSnapshot);
  }

  //stream for newbatch
  Stream<NewBatchData> get newBatchData {
    return recordCollection.doc(uid).snapshots().map(_newBatchDataFromSnapshot);
  }

  //stream for current batch
  Stream<CurrentBatchData> get currentBatchData {
    return recordCollection
        .doc(uid)
        .snapshots()
        .map(_currentBatchDataFromSnapshot);
  }

  //stream for duration
  Stream<Durations> get durations {
    return recordCollection
        .doc("Duration")
        .snapshots()
        .map(_durationDataFromSnapshot);
  }
}
