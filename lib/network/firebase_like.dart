
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socail_app/models/lieks.dart';
import 'package:socail_app/models/post.dart';


CollectionReference<likes> gettaskcollectionlike(String post_id){
  return   FirebaseFirestore.instance.collection('posts').doc(post_id).collection("likes").
  withConverter<likes>(
      fromFirestore: (Snapshot,_)=>likes.fromFirestorelike(Snapshot.data()!),
      toFirestore: (like,_)=>like.toFirestorelike());
}

Future<void> addlikeFirebaseFirestore(likes like,String post_id){
  var collection =gettaskcollectionlike(post_id);
  var dcoref =collection.doc();
  like.id= dcoref.id;
  return dcoref.set(like);

}

Stream<QuerySnapshot<likes>> getlikeFirebaseFirestore(bool like,String post_id){
  return gettaskcollectionlike(post_id).where('like', isEqualTo: like).snapshots();
}

Stream<QuerySnapshot<likes>> getalllikeFirebaseFirestore(String post_id){
  return gettaskcollectionlike(post_id).snapshots();
}


Future<void> deletelikeFirebase(String id,String post_id){
  return gettaskcollectionlike(post_id).doc(id).delete();
}
Future<void> updateimagelikeFirebase(String id,String image,String post_id) {
  return gettaskcollectionlike(post_id).doc(id).update({
    "image": image
  });
}
Future<void> updatelikeFirebase(String id,post post,String post_id){
  var taskmap = post.toFirestorepost();
  return gettaskcollectionlike(post_id).doc(id).update(taskmap);
}