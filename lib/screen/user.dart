import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socail_app/models/post.dart';
import 'package:socail_app/screen/search_details.dart';
import 'package:socail_app/social-layout.dart';

import '../models/User.dart';
import '../network/firebase_post.dart';
import '../network/firebse_utils.dart';

class search extends StatefulWidget {
  static const String routname = 'search';

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController text_search = TextEditingController();

  String text_searchh='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, sociallayout.routname);
        },
        child: Icon(
          CupertinoIcons.back,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SafeArea(child: Container()),
            TextFormField(
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search,size: 30,color: Colors.blue,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18)
                  ),
                  hintStyle: TextStyle(fontSize: 20),
                  hintText: "Inter search"),
              controller: text_search,
              onChanged: ( value){
                setState(() {
                  text_searchh =value;
                  print(text_searchh);
                });

              },
            ),
      StreamBuilder<QuerySnapshot<taskedate>>(
          stream: gettaskFirebaseFirestorename(text_searchh),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Something Went Wronge"));
            }
            var users =
                snapshot.data?.docs.map((doc) => doc.data()).toList() ??
                    [];
            print(users);
            if (users.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: Text("No Search",style: TextStyle(fontSize: 25,color: Colors.blue),)),
              );
            }
            return Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, search_details.routname,
                            arguments: users[index]);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                            NetworkImage(users[index].image),
                            radius: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${users[index].name}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${users[index].bio}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 2,
                    );
                  },
                  itemCount: users.length),
            );
          }),
          ],
        ),
      ),
    );
  }

  Widget item_search(context, taskedate user) => Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.image),
            radius: 30,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${user.name}",
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "${user.bio}",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
