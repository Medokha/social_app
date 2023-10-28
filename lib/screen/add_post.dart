import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socail_app/models/post.dart';
import 'package:socail_app/network/firebase_post.dart';
import 'package:socail_app/state%20management/get_cubit.dart';
import 'package:socail_app/state%20management/get_states.dart';

import '../models/User.dart';
import '../network/firebse_utils.dart';

class addpost extends StatelessWidget {
  static const String routname ='addpost';
  String image ="";
  TextEditingController text =TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? id = FirebaseAuth.instance.currentUser?.email;
    print(id);
    return  BlocProvider(
      create: (BuildContext context) =>getcubit(),
      child: BlocConsumer<getcubit,getstates>(
        listener: (BuildContext context, Object? state) {
          if(state is postimagesuccesstate){
            image = getcubit.get(context).imageposturl;
          }
          if(state is removeimagesuccesstate){
            image =getcubit.get(context).imageposturl;
          }
        },
        builder: (BuildContext context, state) {
          return StreamBuilder<QuerySnapshot<taskedate>>(
              stream: gettaskFirebaseFirestore(id!),
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
                  body: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:NetworkImage("${taskes.single.image}"),
                              radius: 30,
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("${taskes.single.name}",style: TextStyle(color: Colors.black,fontSize:  20),),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            TextButton(onPressed: (){

                              post newpost =post(
                                  text: text.text,
                                  data: DateTime.now().toString(),
                                  photo:image ,
                                  uid: taskes.single.id);
                              addpostFirebaseFirestore(newpost);


                            }, child: Text("POST",style: TextStyle(fontSize: 25),))
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            controller:text ,
                            decoration: InputDecoration(
                              label: Text("What is on your mind .... "),
                              border: InputBorder.none,
                            ),
                            validator: (value){
                              if(value!.isEmpty || value == null){
                                return "Write post";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        if(image != "")
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children : [
                                Image(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                ),
                                CircleAvatar(
                                  radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(onPressed: (){
                                      getcubit.get(context).removeimagepost();
                                    }, icon: Icon(CupertinoIcons.clear,color: Colors.blue,size: 20,)))
                              ]
                          ),
                          margin: EdgeInsets.all(8),
                          elevation: 0,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  getcubit.get(context).uploodprofileimagepost();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image,color: Colors.blue,size: 30,),
                                    Text("  add photo",style: TextStyle(color: Colors.blue,fontSize: 18),)
                                  ],
                                ),
                              ),
                            ),
                            Expanded(child: TextButton(onPressed: (){}, child: Text("# tags",style: TextStyle(color: Colors.blue,fontSize: 18),)))
                          ],
                        )
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




