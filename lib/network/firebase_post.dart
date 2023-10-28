
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socail_app/models/post.dart';


CollectionReference<post> gettaskcollectionpost(){
  return   FirebaseFirestore.instance.collection('posts').
  withConverter<post>(
      fromFirestore: (Snapshot,_)=>post.fromFirestorepost(Snapshot.data()!),
      toFirestore: (post,_)=>post.toFirestorepost());
}

Future<void> addpostFirebaseFirestore(post post){
  var collection =gettaskcollectionpost();
  var dcoref =collection.doc();
  post.id= dcoref.id;
  return dcoref.set(post);

}

Stream<QuerySnapshot<post>> getpostFirebaseFirestore(String user_id){
  return gettaskcollectionpost().where('uid', isEqualTo: user_id).snapshots();
}

Stream<QuerySnapshot<post>> getallpostFirebaseFirestore(){
  return gettaskcollectionpost().snapshots();
}


Future<void> deletepostFirebase(String id){
  return gettaskcollectionpost().doc(id).delete();
}
Future<void> updateimagepostFirebase(String id,String image) {
  return gettaskcollectionpost().doc(id).update({
    "image": image
  });
}
Future<void> updatepostFirebase(String id,post post){
  var taskmap = post.toFirestorepost();
  return gettaskcollectionpost().doc(id).update(taskmap);
}