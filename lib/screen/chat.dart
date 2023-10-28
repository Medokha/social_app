import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socail_app/network/firebse_utils.dart';
import 'package:socail_app/screen/chat_detailes.dart';

import '../models/User.dart';

class chat extends StatelessWidget {
  const chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? email_user = FirebaseAuth.instance.currentUser?.email;
    return StreamBuilder<QuerySnapshot<taskedate>>(
        stream: gettaskFirebaseFirestore(email_user!),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text("Something Went Wronge"));
          }
          var user_singin = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
          if(user_singin.isEmpty){
            return Center(child: Text("No Data"));
          }
          return StreamBuilder<QuerySnapshot<taskedate>>(
              stream: gettaskFirebaseFirestorebuidnotequal(email_user!),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError){
                  return Center(child: Text("Something Went Wronge"));
                }
                var users = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                if(users.isEmpty){
                  return Center(child: Text("No Users"));
                }
                return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => chat_detailes(users[index],user_singin[0])));
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:NetworkImage(users[index].image),
                                  radius: 30,
                                ),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("${users[index].name}",style: TextStyle(color: Colors.black,fontSize:  25),),
                                            ],
                                          ),
                                          SizedBox(height: 3,),
                                          Text("${users[index].bio}",style:  TextStyle(color: Colors.black,fontSize:  20),)
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: Colors.grey,thickness: 1,indent: 10,endIndent: 10,);
                  },
                  itemCount: users.length,
                );
              });
        });
  }
}




