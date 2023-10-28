import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:socail_app/main.dart';
import 'package:socail_app/screen/add_post.dart';
import 'package:socail_app/screen/chat.dart';
import 'package:socail_app/screen/home.dart';
import 'package:socail_app/screen/user.dart';
import 'package:socail_app/state%20management/states.dart';
import '../models/modeluser.dart';
import '../screen/new_home.dart';
import '../screen/setting.dart';
import 'get_states.dart';


class getcubit extends Cubit<getstates> {
  getcubit() :super(getintialstate());

  static getcubit get(context) => BlocProvider.of(context);

  int n = 0;
  List<Widget> screen = [
    home(),
    chat(),
    addpost(),
    setting()
  ];
  List<String> titels = [
    "News",
    "Chats",
    "Add Post",
    "Setting",

  ];

  void appp(index) {
    n = index;
    emit(changestate());
  }


   File file= File("") ;
  var imagepiker = ImagePicker();
  String imageurl ="";
  Future<void> uploodprofileimage() async {
    var imgpicker =await imagepiker.pickImage(source: ImageSource.camera);
    if(imgpicker != null){
      file =File(imgpicker.path);
      var nameimage =basename(imgpicker.path);
      // stare uplood
      var randam =Random().nextInt(10000000);
      nameimage ="$randam+$nameimage";
      final storageRef = FirebaseStorage.instance.ref('images/${Uri.file(nameimage).pathSegments.last}');
      await storageRef.putFile(file);
      var url = await storageRef.getDownloadURL();
      // end uplood
      imageurl =url;
      print(url);
      emit(imagesuccesstate());
    }else{
      print("select image");
      emit(imagefailstate("No select image"));
    }



  }

  String coverurl ="";
  File filecover= File("") ;
  var imagepikercover = ImagePicker();
  Future<void> uploodprofileimagecover() async {
    var imgpicker = await imagepikercover.pickImage(source: ImageSource.camera);
    if (imgpicker != null) {
      filecover = File(imgpicker.path);
      var nameimage =basename(imgpicker.path);
      // stare uplood
      var randam =Random().nextInt(10000000);
      nameimage ="$randam+$nameimage";
      final storageRef = FirebaseStorage.instance.ref('covers/${Uri.file(nameimage).pathSegments.last}');
      await storageRef.putFile(filecover);
      var url = await storageRef.getDownloadURL();
      // end uplood
      coverurl =url;
      print(url);
      emit(coversuccesstate());
    } else {
      print("select image");
      emit(coverfailstate("No select image"));
    }
  }

  Future<void> read() async {
    await FirebaseFirestore.instance.collection("users").
    snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshots(e)).toList());
  }


   Future update({ required String phone ,required String username ,required String bio ,}) async {
    UserModel user = UserModel(
      phone: phone,
      username: username,
      bio: bio,
      cover: coverurl,
      image: imageurl,

    );
    final userCollection = FirebaseFirestore.instance.collection("users");
    final docRef = userCollection.doc(user.id);
    final newUser = UserModel(
        username: user.username,
      phone: user.phone,
      image: user.image,
      cover: user.cover,
      bio: user.bio
    ).toJson();

    try {
      await docRef.update(newUser);
      emit(updatesuccesstate());
    } catch (e) {
      print("Something went wrong$e");
      emit(imagefailstate("Fail update"));
    }
  }

  // UserModel? model;

  // void getUserData() {
  //   String? id =FirebaseAuth.instance.currentUser?.uid;
  //   FirebaseFirestore.instance.collection("user")
  //       .doc(id ).get().
  //   then((value) {
  //     print(id);
  //     print(value);
  //     // model = UserModel.fromSnapshots(value.data() as DocumentSnapshot<Object?>);
  //     // print(model);
  //     print("****************************************");
  //     emit(getsuccesstate());
  //   }).catchError((error){
  //     emit(getfailstate(error.toString()));
  //   });
  // }


  File filepost= File("") ;
  var imagepikerpost = ImagePicker();
  String imageposturl ="";
  Future<void> uploodprofileimagepost() async {
    var imgpicker =await imagepikerpost.pickImage(source: ImageSource.camera);
    if(imgpicker != null){
      filepost =File(imgpicker.path);
      var nameimage =basename(imgpicker.path);
      // stare uplood
      var randam =Random().nextInt(10000000);
      nameimage ="$randam+$nameimage";
      final storageRef = FirebaseStorage.instance.ref('post_image/${Uri.file(nameimage).pathSegments.last}');
      await storageRef.putFile(filepost);
      var url = await storageRef.getDownloadURL();
      // end uplood
      imageposturl =url;
      print(url);
      emit(postimagesuccesstate());
    }else{
      print("select image");
      emit(postimagefailstate("No select image"));
    }
  }

  void removeimagepost(){
    imageposturl ="";
    emit(removeimagesuccesstate());
  }


  File filechat= File("") ;
  var imagepikerchat = ImagePicker();
  String imagechaturl ="";
  Future<void> uploodprofileimagechat() async {
    var imgpicker =await imagepikerchat.pickImage(source: ImageSource.camera);
    if(imgpicker != null){
      filechat =File(imgpicker.path);
      var nameimage =basename(imgpicker.path);
      // stare uplood
      var randam =Random().nextInt(10000000);
      nameimage ="$randam+$nameimage";
      final storageRef = FirebaseStorage.instance.ref('chat_image/${Uri.file(nameimage).pathSegments.last}');
      await storageRef.putFile(filechat);
      var url = await storageRef.getDownloadURL();
      // end uplood
      imagechaturl =url;
      print(url);
      emit(chatimagesuccesstate());
    }else{
      print("select image");
      emit(chatimagefailstate("No select image"));
    }
  }
}