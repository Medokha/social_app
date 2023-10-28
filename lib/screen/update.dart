import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socail_app/models/User.dart';
import 'package:socail_app/screen/setting.dart';
import 'package:socail_app/state%20management/get_cubit.dart';
import 'package:socail_app/state%20management/get_states.dart';

import '../network/firebse_utils.dart';

class update extends StatelessWidget {
  static const String routname ='update';
  TextEditingController _name =TextEditingController();
  TextEditingController _bio =TextEditingController();
  TextEditingController _phone =TextEditingController();

  //  String url_image
  // ="https://img.freepik.com/free-photo/two-funny-smiling-sisters-making-selfie-smaptphone-listening-music-posing-street-vacation-mood-crazy-positive-feeling-summer-bright-clothes-sunglasses_291650-201.jpg?t=st=1697827300~exp=1697827900~hmac=defdbe323c3688917ad3306d7e76cf5b8458e8d3bf76a3fe95504ed222679a25";
  // String url_cover = "https://img.freepik.com/free-photo/person-enjoying-warm-nostalgic-sunset_52683-100695.jpg?w=996&t=st=1697799101~exp=1697799701~hmac=ad255372917a7011fec57c188e75627462330b6f64ff9b652c11eac02a3ad12a";
  ImageProvider image = NetworkImage(
      "https://img.freepik.com/free-photo/two-funny-smiling-sisters-making-selfie-smaptphone-listening-music-posing-street-vacation-mood-crazy-positive-feeling-summer-bright-clothes-sunglasses_291650-201.jpg?t=st=1697827300~exp=1697827900~hmac=defdbe323c3688917ad3306d7e76cf5b8458e8d3bf76a3fe95504ed222679a25");
  ImageProvider cover = NetworkImage(
      "https://img.freepik.com/free-photo/person-enjoying-warm-nostalgic-sunset_52683-100695.jpg?w=996&t=st=1697799101~exp=1697799701~hmac=ad255372917a7011fec57c188e75627462330b6f64ff9b652c11eac02a3ad12a");

  @override
  Widget build(BuildContext context) {
    ardssetting task =ModalRoute.of(context)?.settings.arguments as ardssetting;
    String url_image =task.image;
    String url_cover =task.cover;
    return BlocProvider(
      create: (BuildContext context) => getcubit(),
      child: BlocConsumer<getcubit,getstates>(
        listener: (BuildContext context, Object? state) {
          if (state is imagesuccesstate){
            image =FileImage(getcubit.get(context).file);
            url_image =getcubit.get(context).imageurl;
          }
          if (state is coversuccesstate){
            cover =FileImage(getcubit.get(context).filecover);
            url_cover =getcubit.get(context).coverurl;
          }
        },
        builder: (BuildContext context, state) {
          String? emailuser =FirebaseAuth.instance.currentUser?.email;

        return StreamBuilder<QuerySnapshot<taskedate>>(
            stream: gettaskFirebaseFirestore(emailuser!),
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              if(snapshot.hasError){
                return Center(child: Text("Something Went Wronge"));
              }
              var taskes = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
              print(taskes.single.bio);
              if(taskes.isEmpty){
                return Center(child: Text("No Data"));
              }
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  title: Text("Edite profile",style: TextStyle(color: Colors.black),),
                  actions: [
                    TextButton(
                        onPressed: ()  {
                          if(url_image != taskes.single.image) {
                            updateimageFirebase(taskes.single.id, url_image);
                          }
                          if(url_cover != taskes.single.cover) {
                            updatecoverFirebase(taskes.single.id, url_cover);
                          }
                          if(_name.text == "") {
                            updatenameFirebase(taskes.single.id, taskes.single.name);
                          }else{
                            updatenameFirebase(taskes.single.id, _name.text);
                          }
                          if(_bio.text == "") {
                            updatebioFirebase(taskes.single.id, taskes.single.bio);
                          }else{
                            updatebioFirebase(taskes.single.id, _bio.text);

                          }
                          if(_phone.text == "") {
                            updatephoneFirebase(taskes.single.id, taskes.single.phone);
                          }else{
                            updatephoneFirebase(taskes.single.id, _phone.text);
                          }
                          Navigator.pop(context);
                          // taskedate newtask =taskedate(
                          //   id: taskes.single.id,
                          //     name: _name.text ==null ?taskes.single.name :_name.text,
                          //     email: taskes.single.email,
                          //     phone: _phone.text ==null ?taskes.single.phone :_phone.text,
                          //     image: url_image ==null ? taskes.single.image:url_image,
                          //     cover: url_cover ==null ? taskes.single.cover :url_cover,
                          //     bio: _bio.text ==null ?taskes.single.bio :_bio.text,
                          // );
                          // updatedataFirebase(taskes.single.id, newtask);
                          // getcubit.get(context).update(phone: _phone.text, username: _name.text, bio: _bio.text);
                        }, child: Text("Update"))
                  ],

                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 190,
                        alignment: Alignment.topCenter,
                        child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Stack(
                                children:[
                                  Align(
                                    child: Card(
                                      clipBehavior: Clip
                                          .antiAliasWithSaveLayer,
                                      child: Image(
                                        image:NetworkImage("${url_cover}"),
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: double.infinity,
                                      ),
                                      margin: EdgeInsets.all(8),
                                      elevation: 0,
                                    ),
                                    alignment: Alignment.topCenter,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: CircleAvatar(
                                        child: IconButton(onPressed: (){
                                          getcubit.get(context).uploodprofileimagecover();
                                        }, icon:Icon(CupertinoIcons.camera,color: Colors.white,))),
                                  ),
                                ],
                                alignment: Alignment.topRight,
                              ),
                              Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children:[
                                    CircleAvatar(
                                      radius: 65,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage:NetworkImage("${url_image}") ,
                                      ),
                                    ),
                                    CircleAvatar(
                                        child: IconButton(onPressed: (){
                                          getcubit.get(context).uploodprofileimage();
                                        }, icon:Icon(CupertinoIcons.camera,color: Colors.white,))),
                                  ]
                              )
                            ]
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "${taskes.single.name}",
                            prefixIcon: Icon(CupertinoIcons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        controller: _name,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "${taskes.single.bio}",
                          prefixIcon: Icon(CupertinoIcons.info),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),

                        ),

                        controller: _bio,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "${taskes.single.phone}",
                          prefixIcon: Icon(CupertinoIcons.phone),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),

                        ),

                        controller: _phone,
                      ),
                    ],
                  ),
                ),
              );
            });
        },


      ),
    );
  }
}
