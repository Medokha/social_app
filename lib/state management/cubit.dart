import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socail_app/state%20management/states.dart';

import '../models/modeluser.dart';

class regcubit extends Cubit<regeststates> {
  regcubit() :super(regestintialstate());

  static regcubit get(context) => BlocProvider.of(context);


  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
      emit(regestsuccesstate());
      })
          .catchError((onError){
        emit(regestfailstate(
            onError.toString()
        ));
      });

  }
  Future<User?> signInWithEmailAndPassword(String email, String password) async {


      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        emit(loginsuccesstate(
            value.user!.uid
        ));
      })
          .catchError((onError){
        emit(loginfailstate(
            onError.toString()

        ));
      });

  }

  // Future create(UserModel user) async {
  //   final userCollection = FirebaseFirestore.instance.collection("users");
  //   final uid = userCollection.doc().id;
  //   final docRef = userCollection.doc(uid);
  //   final newUser = UserModel(
  //       id: uid,
  //       username: user.username,
  //       email :user.email,
  //       phone: user.phone,
  //       isvereviction: user.isvereviction,
  //     image:"https://img.freepik.com/free-photo/two-funny-smiling-sisters-making-selfie-smaptphone-listening-music-posing-street-vacation-mood-crazy-positive-feeling-summer-bright-clothes-sunglasses_291650-201.jpg?t=st=1697827300~exp=1697827900~hmac=defdbe323c3688917ad3306d7e76cf5b8458e8d3bf76a3fe95504ed222679a25",
  //     cover: "https://img.freepik.com/free-photo/person-enjoying-warm-nostalgic-sunset_52683-100695.jpg?w=996&t=st=1697799101~exp=1697799701~hmac=ad255372917a7011fec57c188e75627462330b6f64ff9b652c11eac02a3ad12a",
  //     bio: "Write bio .... ",
  //
  //   ).toJson();
  //   await docRef.set(newUser)
  //       .then((value) {
  //     emit(crudsuccesstate());
  //   })
  //       .catchError((onError){
  //     emit(crudfailstate(
  //         onError.toString()
  //     ));
  //   });
  //
  // }

  // Future get(String ID) async {
  //   final userCollection = FirebaseFirestore.instance.collection("users");
  //   final uid = userCollection.doc(ID);
  //   final docRef = userCollection.doc(uid as String?);
  //   await docRef.get()
  //       .then((value) {
  //     emit(crudsuccesstate());
  //   })
  //       .catchError((onError){
  //     emit(crudfailstate(
  //         onError.toString()
  //     ));
  //   });
  //
  // }
}