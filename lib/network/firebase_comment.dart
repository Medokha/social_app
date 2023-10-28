
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socail_app/models/comment.dart';
import 'package:socail_app/models/lieks.dart';
import 'package:socail_app/models/post.dart';


CollectionReference<comment> gettaskcollectioncomment(String post_id){
  return   FirebaseFirestore.instance.collection('posts').doc(post_id).collection("comment").
  withConverter<comment>(
      fromFirestore: (Snapshot,_)=>comment.fromFirestorecomment(Snapshot.data()!),
      toFirestore: (comment,_)=>comment.toFirestorecomment());
}

Future<void> addcommentFirebaseFirestore(comment comment,String post_id){
  var collection =gettaskcollectioncomment(post_id);
  var dcoref =collection.doc();
  comment.id= dcoref.id;
  return dcoref.set(comment);

}

Stream<QuerySnapshot<comment>> getcommentFirebaseFirestore(bool like,String post_id){
  return gettaskcollectioncomment(post_id).where('like', isEqualTo: like).snapshots();
}

Stream<QuerySnapshot<comment>> getallcommentFirebaseFirestore(String post_id){
  return gettaskcollectioncomment(post_id).snapshots();
}


Future<void> deletecommentFirebase(String id,String post_id){
  return gettaskcollectioncomment(post_id).doc(id).delete();
}
Future<void> updateimagecommentFirebase(String id,String image,String post_id) {
  return gettaskcollectioncomment(post_id).doc(id).update({
    "image": image
  });
}
Future<void> updatecommentFirebase(String id,post post,String post_id){
  var taskmap = post.toFirestorepost();
  return gettaskcollectioncomment(post_id).doc(id).update(taskmap);
}