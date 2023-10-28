
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socail_app/screen/update.dart';
import 'package:socail_app/screen/user.dart';
import 'package:socail_app/state%20management/get_cubit.dart';
import 'package:socail_app/state%20management/get_states.dart';

import '../models/User.dart';
import '../models/comment.dart';
import '../models/lieks.dart';
import '../models/post.dart';
import '../network/firebase_comment.dart';
import '../network/firebase_like.dart';
import '../network/firebase_post.dart';
import '../network/firebse_utils.dart';

import 'package:socail_app/home_page.dart';
import 'package:socail_app/network/cachehelper.dart';

class search_details extends StatelessWidget {
  static const String routname ='search_details';
  TextEditingController _comment =TextEditingController();
  @override
  Widget build(BuildContext context) {
    taskedate selected_user =ModalRoute.of(context)?.settings.arguments as taskedate;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, search.routname);
        },
        child: Icon(
          CupertinoIcons.back,
          size: 30,
        ),
      ),

      body: BlocProvider(
        create: (BuildContext context )=>getcubit(),
        child: BlocConsumer<getcubit,getstates>(
          listener: (BuildContext context, Object? state) {  },
          builder: (BuildContext context, state) {
            return  SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot<taskedate>>(
                  stream: gettaskFirebaseFirestore(selected_user.email!),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    if(snapshot.hasError){
                      return Center(child: Text("Something Went Wronge"));
                    }
                    var taskes = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                    if(taskes.isEmpty){
                      return Center(child: Text("No Data"));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 190,
                            alignment: Alignment.topCenter,
                            child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Align(
                                    child: Card(
                                      clipBehavior: Clip
                                          .antiAliasWithSaveLayer,
                                      child: Image(
                                        image: NetworkImage(taskes.single.cover),
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: double.infinity,
                                      ),
                                      margin: EdgeInsets.all(8),
                                      elevation: 0,
                                    ),
                                    alignment: Alignment.topCenter,
                                  ),
                                  CircleAvatar(
                                      radius: 65,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage: NetworkImage(taskes.single.image),
                                      )
                                  )
                                ]
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("${taskes.single.name}", style: TextStyle(
                              fontSize: 20, color: Colors.black),),
                          SizedBox(
                            height: 5,
                          ),
                          Text("${taskes.single.bio}", style: TextStyle(
                              fontSize: 18, color: Colors.grey),),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("100", style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black),),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Posts", style: TextStyle(
                                        fontSize: 18, color: Colors.blue),),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("120", style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black),),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Photos", style: TextStyle(
                                        fontSize: 18, color: Colors.blue),),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("10k", style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black),),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Followers", style: TextStyle(
                                        fontSize: 18, color: Colors.blue),),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("365", style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black),),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Following", style: TextStyle(
                                        fontSize: 18, color: Colors.blue),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          StreamBuilder<QuerySnapshot<taskedate>>(
                              stream:gettaskFirebaseFirestore(selected_user.email!),
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
                                return SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      StreamBuilder<QuerySnapshot<post>>(
                                          stream: getpostFirebaseFirestore(selected_user.id),
                                          builder: (context,snapshot){
                                            if(snapshot.connectionState==ConnectionState.waiting){
                                              return Center(child: CircularProgressIndicator());
                                            }
                                            if(snapshot.hasError){
                                              return Center(child: Text("Something Went Wronge"));
                                            }
                                            var posts = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                                            if(posts.isEmpty){
                                              return Center(child: Text("No Posts"));
                                            }
                                            return ListView.separated(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: posts.length,
                                              itemBuilder: (context,index) {
                                                String iduser = posts[index].uid;
                                                return StreamBuilder<QuerySnapshot<taskedate>>(
                                                    stream: gettaskFirebaseFirestorebuid(iduser),
                                                    builder: (context,snapshot){
                                                      if(snapshot.connectionState==ConnectionState.waiting){
                                                        return Center(child: CircularProgressIndicator());
                                                      }
                                                      if(snapshot.hasError){
                                                        return Center(child: Text("Something Went Wronge"));
                                                      }
                                                      var user_share_post = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                                                      if(user_share_post.isEmpty){
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
                                                            return StreamBuilder<QuerySnapshot<comment>>(
                                                                stream: getallcommentFirebaseFirestore(posts[index].id),
                                                                builder: (context,snapshot){
                                                                  if(snapshot.connectionState==ConnectionState.waiting){
                                                                    return Center(child: CircularProgressIndicator());
                                                                  }
                                                                  if(snapshot.hasError){
                                                                    return Center(child: Text("Something Went Wronge"));
                                                                  }
                                                                  var commentss = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                                                                  return buildpostitem(context,posts[index],user_share_post[0],likess,user_singin[0],commentss);
                                                                });
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
                              })

                        ],
                      ),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }

  Widget buildpostitem (context,post post,taskedate user,List<likes> likess ,taskedate user_singin,List<comment> commentss ) => Card(
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
                  backgroundImage:NetworkImage(user.image),
                  radius: 30,
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("${user.name}",style: TextStyle(color: Colors.black,fontSize:  20),),
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
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
            child: Row(
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
                                    return StreamBuilder<QuerySnapshot<taskedate>>(
                                        stream: gettaskFirebaseFirestorebuid(lik[index].id_user),
                                        builder: (context,snapshot){
                                          if(snapshot.connectionState==ConnectionState.waiting){
                                            return Center(child: CircularProgressIndicator());
                                          }
                                          if(snapshot.hasError){
                                            return Center(child: Text("Something Went Wronge"));
                                          }
                                          var user_likes = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                                          if(user_likes.isEmpty){
                                            return Center(child: Text("No Likes"));
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(user_likes.single.image),
                                                      radius: 30,
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Expanded(child: Text("${user.name}",style: TextStyle(fontSize: 25,color: Colors.black),)),
                                                    SizedBox(width: 30,),
                                                    Icon(CupertinoIcons.heart,color: Colors.red,size: 30,),
                                                    SizedBox(width: 30,),

                                                  ],
                                                )

                                              ],
                                            ),
                                          );
                                        });
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
                                  return StreamBuilder<QuerySnapshot<taskedate>>(
                                      stream: gettaskFirebaseFirestorebuid(commentss[index].id_user),
                                      builder: (context,snapshot){
                                        if(snapshot.connectionState==ConnectionState.waiting){
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        if(snapshot.hasError){
                                          return Center(child: Text("Something Went Wronge"));
                                        }
                                        var user_comment = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                                        if(user_comment.isEmpty){
                                          return Center(child: Text("No Data"));
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 12,left: 12,top: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(user_comment.single.image),
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
                                      });
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.chat_bubble,color: Colors.yellow,),
                        SizedBox(width: 4,),
                        Text("${commentss.length}",style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(CupertinoIcons.share,color: Colors.grey,size: 22,),
                        SizedBox(width: 4,),
                        Text("0",style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    ),

  );

}


