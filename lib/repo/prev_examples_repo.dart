import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locie/helper/firestore_storage.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/store.dart';

class PreviousExamplesRepo {
  LocalStorage localStorage = LocalStorage();
  FirebaseFirestore instance = FirebaseFirestore.instance;
  CollectionReference workRef;

  PreviousExamplesRepo() {
    workRef = instance.collection("works");
  }

  Future<PreviousExamples> fetchWorks({String id}) async {
    var sid;
    if (id == null) {
      await localStorage.init();
      sid = localStorage.prefs.getString("sid");
    } else {
      sid = id;
    }
    QuerySnapshot snapshots = await workRef.where("sid", isEqualTo: sid).get();
    PreviousExamples examples = PreviousExamples(examples: []);
    // print(snapshots.docs.length);
    if (snapshots.docs.length > 0) {
      List<PreviousExamples> exampleSnaps = snapshots.docs.map((e) {
        // print(e.data());
        return PreviousExamples.fromJson(e.data());
      }).toList();
      if (exampleSnaps.isNotEmpty) {
        examples = exampleSnaps[0];
      }
    }
    // print('quad $examples');
    return examples;
  }

  Future<void> insertWork(PreviousExample example) async {
    await localStorage.init();
    var sid = localStorage.prefs.getString("sid");
    if (example.imageFile != null) {
      CloudStorage cloudStorage = CloudStorage();
      var task = cloudStorage.uploadFile(example.imageFile);
      example.image = await cloudStorage.getDownloadUrl(task);
      example.imageFile = null;
    }
    workRef.doc(sid).update({
      "examples": FieldValue.arrayUnion([example.toJson()])
    });
  }

  Future<void> removeWork(PreviousExample example) async {
    await localStorage.init();
    var sid = localStorage.prefs.getString("sid");
    workRef.doc(sid).update({
      "examples": FieldValue.arrayRemove([example.toJson()])
    });
  }
}
