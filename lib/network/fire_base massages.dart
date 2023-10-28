
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socail_app/models/comment.dart';
import 'package:socail_app/models/lieks.dart';
import 'package:socail_app/models/massage.dart';
import 'package:socail_app/models/post.dart';


CollectionReference<massages> gettaskcollectionmassage(String user_id,String rec_id){
  return   FirebaseFirestore.instance.collection('taske').doc(user_id).collection("chats").doc(rec_id).collection("massages").
  withConverter<massages>(
      fromFirestore: (Snapshot,_)=>massages.fromFirestoremassage(Snapshot.data()!),
      toFirestore: (massages,_)=>massages.toFirestoremassage());
}

Future<void> addmassageFirebaseFirestore(massages massages,String user_id,String rec_id){
  var collection =gettaskcollectionmassage(user_id,rec_id);
  var dcoref =collection.doc();
  massages.id= dcoref.id;
  return dcoref.set(massages);

}


/////////////////////////////////////

CollectionReference<massages> gettaskcollectionmassagerec(String user_id,String send_id){
  return   FirebaseFirestore.instance.collection('taske').doc(user_id).collection("chats").doc(send_id).collection("massages").
  withConverter<massages>(
      fromFirestore: (Snapshot,_)=>massages.fromFirestoremassage(Snapshot.data()!),
      toFirestore: (massages,_)=>massages.toFirestoremassage());
}

Future<void> addmassageFirebaseFirestorerecev(massages massages,String user_id,String send_id){
  var collection =gettaskcollectionmassagerec(user_id,send_id);
  var dcoref =collection.doc();
  massages.id= dcoref.id;
  return dcoref.set(massages);

}
///////////////////////////////////////
// Stream<QuerySnapshot<massages>> getmassagesFirebaseFirestore(bool like,String user_id,String rec_id){
//   return gettaskcollectionmassage(user_id,rec_id).where('like', isEqualTo: like).snapshots();
// }

Stream<QuerySnapshot<massages>> getallmassagesFirebaseFirestore_send(String user_id,String send_id){
  return gettaskcollectionmassage(user_id,send_id).orderBy("date").snapshots();
}
//////////////////////
Stream<QuerySnapshot<massages>> getallmassagesFirebaseFirestore_rec(String user_id,String rec_id){
  return gettaskcollectionmassagerec(user_id,rec_id).snapshots();
}


// Future<void> deletemassagesFirebase(String id,String post_id,String rec_id){
//   return gettaskcollectionmassage(post_id,rec_id).doc(id).delete();
// }
// Future<void> updateimagemassagesFirebase(String id,String image,String post_id,String rec_id) {
//   return gettaskcollectionmassage(post_id,rec_id).doc(id).update({
//     "image": image
//   });
// }
// Future<void> updatemassagesFirebase(String id,post post,String post_id,String rec_id){
//   var taskmap = post.toFirestorepost();
//   return gettaskcollectionmassage(post_id,rec_id).doc(id).update(taskmap);
// }