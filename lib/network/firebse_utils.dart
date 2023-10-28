
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';

CollectionReference<taskedate> gettaskcollection(){
  return   FirebaseFirestore.instance.collection('taske').
  withConverter<taskedate>(
      fromFirestore: (Snapshot,_)=>taskedate.fromFirestore(Snapshot.data()!),
      toFirestore: (task,_)=>task.toFirestore());
}

Future<void> addtaskFirebaseFirestore(taskedate taskedate){
  var collection =gettaskcollection();
  var dcoref =collection.doc();
  taskedate.id= dcoref.id;
  return dcoref.set(taskedate);

}

Stream<QuerySnapshot<taskedate>> gettaskFirebaseFirestore(String email){
  return gettaskcollection().where('email', isEqualTo: email).snapshots();
}
Stream<QuerySnapshot<taskedate>> gettaskFirebaseFirestorename(String name){
  return gettaskcollection().where(
    'name',
    isGreaterThanOrEqualTo: name.isEmpty ? 0 : name,
    isLessThan: name.isEmpty
        ? null
        : name.substring(0, name.length - 1) +
        String.fromCharCode(
          name.codeUnitAt(name.length - 1) + 1,
        ),
  )
      .snapshots();
}

Stream<QuerySnapshot<taskedate>> gettaskFirebaseFirestorebuid(String id){
  return gettaskcollection().where('id', isEqualTo: id).snapshots();
}

Stream<QuerySnapshot<taskedate>> gettaskFirebaseFirestorebuidnotequal(String email){
  return gettaskcollection().where('email',isNotEqualTo: email).snapshots();
}

Stream<QuerySnapshot<taskedate>> getalltaskFirebaseFirestore(){
  return gettaskcollection().snapshots();
}


Future<void> deletetaskFirebase(String id){
  return gettaskcollection().doc(id).delete();
}
Future<void> updateimageFirebase(String id,String image){
  return gettaskcollection().doc(id).update({
    "image" : image
  });
}
Future<void> updatecoverFirebase(String id,String cover){
  return gettaskcollection().doc(id).update({
    "cover" : cover
  });
}Future<void> updatenameFirebase(String id,String name){
  return gettaskcollection().doc(id).update({
    "name" : name
  });
}Future<void> updatebioFirebase(String id,String bio){
  return gettaskcollection().doc(id).update({
    "bio" : bio
  });
}Future<void> updatephoneFirebase(String id,String phone){
  return gettaskcollection().doc(id).update({
    "phone" : phone
  });
}
Future<void> updatedataFirebase(String id,taskedate taskedate){
  var taskmap = taskedate.toFirestore();
  return gettaskcollection().doc(id).update(taskmap);
}