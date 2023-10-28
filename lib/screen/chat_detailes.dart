import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socail_app/models/User.dart';
import 'package:socail_app/models/massage.dart';
import 'package:socail_app/screen/user.dart';
import 'package:socail_app/state%20management/get_cubit.dart';
import 'package:socail_app/state%20management/get_states.dart';

import '../network/fire_base massages.dart';

class chat_detailes extends StatelessWidget {
  taskedate click_user ;
  taskedate singin_user ;
  chat_detailes(this.click_user,this.singin_user);
  String _image ="";
  TextEditingController _massage =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(click_user.image),
            ),
            SizedBox(width: 15,),
            Text("${click_user.name}",style: TextStyle(color: Colors.black,fontSize: 20),),
          ],
        ),
      ),
      body: BlocProvider(
        create: (BuildContext context) =>getcubit(),
        child: BlocConsumer<getcubit,getstates>(
          listener: (BuildContext context, Object? state) {
            if(state is chatimagesuccesstate){
              _image =getcubit.get(context).imagechaturl;
            }
          },
          builder: (BuildContext context, state) {
            return StreamBuilder<QuerySnapshot<massages>>(
                stream: getallmassagesFirebaseFirestore_send(singin_user.id,click_user.id),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.hasError){
                    return Center(child: Text("Something Went Wronge"));
                  }
                  var massage = snapshot.data?.docs.map((doc) => doc.data()).toList()??[];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              String id_rec =massage[index].id_send;
                              if(id_rec == click_user.id){
                                return build_rec_massage(context,massage[index]);
                              }else{
                                return build_send_massage(context,massage[index]);

                              }
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(height: 5,);
                            },
                            itemCount: massage.length,
                          ),
                        ),

                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border.all(color: Colors.blueGrey.shade300),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.height*.32,
                                  child: TextFormField(
                                    controller:_massage ,
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 18,color: Colors.grey),
                                        hintText: "   Write massage ... ",
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                                IconButton(onPressed: (){
                                 getcubit.get(context).uploodprofileimagechat();
                                }, icon: Icon(Icons.image,color: Colors.blue,size: 30,)),
                                IconButton(onPressed: (){
                                  massages send_massage =massages(
                                      id_send: singin_user.id,
                                      id_rec: click_user.id,
                                      massage: _massage.text,
                                      image: _image,
                                      date: DateTime.now().toString()
                                  );
                                  addmassageFirebaseFirestore(send_massage,singin_user.id,click_user.id);
                                  massages rec_massage =massages(
                                      id_send: singin_user.id,
                                      id_rec: click_user.id,
                                      massage: _massage.text,
                                      image: _image,
                                      date: DateTime.now().toString()
                                  );
                                  addmassageFirebaseFirestorerecev(rec_massage,click_user.id,singin_user.id);
                                }, icon: Icon(Icons.send,color: Colors.blue,size: 30,))

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                });
          },

        ),
      )
    );
  }
  Widget build_rec_massage (context,massages massage) =>Align(
    alignment: Alignment.topLeft,
    child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if(massage.massage != "")
              Text("${massage.massage}",style: TextStyle(fontSize: 20,color: Colors.black),),
              if(massage.image != "")
                Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image(
                  image: NetworkImage(massage.image),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
                elevation: 0,
              )
            ],
          ),
        )),
  );
  Widget build_send_massage (context,massages massage) =>Align(
    alignment: Alignment.topRight,
    child: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if(massage.massage != "")
                Text("${massage.massage}",style: TextStyle(fontSize: 20),),
              if(massage.image != "")
                Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image(
                  image: NetworkImage(massage.image),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),

                elevation: 0,
              )
            ],
          ),
        )),
  );



}
