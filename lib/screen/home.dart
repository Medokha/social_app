import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socail_app/models/comment.dart';
import 'package:socail_app/models/lieks.dart';
import 'package:socail_app/models/post.dart';
import 'package:socail_app/network/firebase_post.dart';

import '../models/User.dart';
import '../network/firebase_comment.dart';
import '../network/firebase_like.dart';
import '../network/firebse_utils.dart';

class h extends StatelessWidget {

  TextEditingController _comment =TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? email_user_singin =FirebaseAuth.instance.currentUser!.email;
    return StreamBuilder<QuerySnapshot<taskedate>>(
        stream:getalltaskFirebaseFirestore(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text("Something Went Wronge"));
          }
          var users = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
          if(users.isEmpty){
            return Center(child: Text("No Data"));
          }
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children : [
                        Image(
                          image: NetworkImage("${users.single.cover}"),
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Communicate with frindes",style: TextStyle(color: Colors.white,fontSize: 20),),
                        )
                      ]
                  ),
                  margin: EdgeInsets.all(8),
                  elevation: 0,
                ),
                StreamBuilder<QuerySnapshot<post>>(
                    stream: getallpostFirebaseFirestore(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }
                      if(snapshot.hasError){
                        return Center(child: Text("Something Went Wronge"));
                      }
                      var posts = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                      if(posts.isEmpty){
                        return Center(child: Text("No Data"));
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context,index) {
                          String iduser = posts[index].uid;
                          print("//////////////////////////////////////////////");
                          print(iduser);
                          print(posts[index].text);
                          print(posts[index].data);
                          print(posts[index].photo);
                          print("//////////////////////////////////////////////");

                          return StreamBuilder<QuerySnapshot<taskedate>>(
                              stream: gettaskFirebaseFirestorebuid(iduser),
                              builder: (context,snapshot){
                                if(snapshot.connectionState==ConnectionState.waiting){
                                  return Center(child: CircularProgressIndicator());
                                }
                                if(snapshot.hasError){
                                  return Center(child: Text("Something Went Wronge"));
                                }
                                var user = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                                print("//////////////////////////////////////////////");
                                print(user);
                                print("//////////////////////////////////////////////");
                                if(user.isEmpty){
                                  return Center(child: Text("No Data"));
                                }
                                return StreamBuilder<QuerySnapshot<likes>>(
                                    stream: getalllikeFirebaseFirestore(posts[index].id),
                                    builder: (context,snapshot){
                                      if(snapshot.connectionState==ConnectionState.waiting){
                                        return Center(child: CircularProgressIndicator());
                                      }
                                      if(snapshot.hasError){
                                        return Center(child: Text("error"));
                                      }
                                      var likess = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                                      print("??????????????????????????????");

                                      return buildpostitem(context,posts[index],user,likess);
                                    });

                              });
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 8,);
                        },);
                    }),
                SizedBox(
                  height: 8,
                )


              ],
            ),
          );
        });
  }


  Widget buildpostitem (context,post post,List<taskedate> user,List<likes> likess) => Card(
    margin: EdgeInsets.symmetric(horizontal: 8),
    elevation: 10,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:NetworkImage(user.single.image),
                  radius: 30,
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("${user.single.name}",style: TextStyle(color: Colors.black,fontSize:  20),),
                          SizedBox(width: 3,),
                          Icon(CupertinoIcons.check_mark_circled_solid,color: Colors.blue,)
                        ],
                      ),
                      SizedBox(height: 8,),
                      Text("${post.data}",style: TextStyle(fontSize: 12,color: Colors.grey),),

                    ],
                  ),
                ),
                IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.list_bullet))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Container(
            alignment: AlignmentDirectional.topStart,
            child: Text("${post.text}",
              style: TextStyle(fontSize: 15,color: Colors.black,height: 1.3),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: double.infinity,
              child: Wrap(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 10),
                    child: Container(

                      child: MaterialButton(
                        onPressed: (){},
                        child: Text("#software_developer",style: TextStyle(color: Colors.blue,fontSize: 15),),
                        padding: EdgeInsets.zero,
                        minWidth: 1,
                      ),
                      height: 25,
                    ),
                  ),

                ],
              ),
            ),
          ),
          if(post.photo != "")
          Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image:  NetworkImage("${post.photo}"),
                  fit: BoxFit.cover,

                ),

              )
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:10),
                  child: InkWell(
                    onTap: ()  {
                      showModalBottomSheet(context: context, builder: (context){
                        return StreamBuilder<QuerySnapshot<likes>>(
                            stream: getalllikeFirebaseFirestore(post.id),
                            builder: (context,snapshot){
                              if(snapshot.connectionState==ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator());
                              }
                              if(snapshot.hasError){
                                return Center(child: Text("Something Went Wronge"));
                              }
                              var lik = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                              if(lik.isEmpty){
                                return Center(child: Text("No Likes"));
                              }
                              return ListView.separated(
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(user.single.image),
                                              radius: 30,
                                            ),
                                            SizedBox(width: 20,),
                                            Expanded(child: Text("${user.single.name}",style: TextStyle(fontSize: 25,color: Colors.black),)),
                                            SizedBox(width: 30,),
                                            Icon(CupertinoIcons.heart,color: Colors.red,size: 30,),
                                            SizedBox(width: 30,),

                                          ],
                                        )

                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return Divider(color: Colors.grey,thickness: 1,);
                                },
                                itemCount: lik.length,
                              );
                            });
                      });
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(CupertinoIcons.heart,color: Colors.red,),
                        ),
                        Text("${likess.length}",style: TextStyle(fontSize: 15),),

                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: (){
                      showModalBottomSheet(context: context, builder: (context){
                        return StreamBuilder<QuerySnapshot<comment>>(
                            stream: getallcommentFirebaseFirestore(post.id),
                            builder: (context,snapshot){
                              if(snapshot.connectionState==ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator());
                              }
                              if(snapshot.hasError){
                                return Center(child: Text("Something Went Wronge"));
                              }
                              var commentss = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                              if(commentss.isEmpty){
                                return Center(child: Text("No Comments"));
                              }
                              return ListView.separated(
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12,left: 12,top: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(user.single.image),
                                              radius: 30,
                                            ),
                                            SizedBox(width: 20,),
                                            Expanded(
                                              child: Text("${commentss[index].text}",style: TextStyle(fontSize: 20,color: Colors.black),),
                                            ),

                                          ],
                                        )

                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return Divider(color: Colors.grey,thickness: 1,);
                                },
                                itemCount: commentss.length,
                              );
                            });
                      });
                    },
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.chat_bubble,color: Colors.yellow,),
                        SizedBox(width: 2,),
                        Text("12 comments",style: TextStyle(fontSize: 15),),

                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(CupertinoIcons.share,color: Colors.grey,size: 22,),
                      ),
                      Text("Share",style: TextStyle(fontSize: 15),),

                    ],
                  ),
                ),
              ),


            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage("${user.single.image}"),
                      radius: 20,
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 50,
                      width: 180,
                      child: TextFormField(
                      controller: _comment,
                      decoration: InputDecoration(
                        hintText: "Write commet ... ",
                        hintStyle: TextStyle(fontSize: 18,color: Colors.grey),
                        border: InputBorder.none
                      ),
                    ),
                    ),
                    IconButton(onPressed: (){
                        comment comments =comment(text: _comment.text, id_user: user.single.id,  id_post:  post.id);
                        addcommentFirebaseFirestore(comments , post.id );
                    }, icon: Icon(Icons.comment), )
                  ],
                ),
              ),
              InkWell(
                onTap: (){

                  likes mylike =likes(id_user: user.single.id, like: true, id_post: post.id);
                  String post_id =post.id;
                  addlikeFirebaseFirestore(mylike,post_id);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(CupertinoIcons.heart,color: Colors.red,),
                    ),
                    Text("Like",style: TextStyle(fontSize: 15),),

                  ],
                ),
              ),
              SizedBox(width: 8,),

            ],
          ),
        ],
      ),
    ),

  );

}



