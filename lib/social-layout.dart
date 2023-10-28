import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socail_app/home_page.dart';
import 'package:socail_app/network/cachehelper.dart';
import 'package:socail_app/screen/user.dart';
import 'package:socail_app/state%20management/cubit.dart';
import 'package:socail_app/state%20management/get_cubit.dart';
import 'package:socail_app/state%20management/get_states.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'models/modeluser.dart';

class sociallayout extends StatelessWidget {
  static const String routname = 'sociallayout';
  TextEditingController text_search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<getcubit>(create:(BuildContext context) =>getcubit()),
          BlocProvider<regcubit>(create:(BuildContext context) => regcubit()),
        ],
      child:BlocConsumer<getcubit,getstates>(
          listener: (BuildContext context, Object? state) {  },
          builder: (BuildContext context, state){
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, search.routname);
                  }, icon: Icon(Icons.search,color: Colors.grey,size: 30,)),

                ],
                backgroundColor: Colors.white,
                foregroundColor: Colors.transparent,
                elevation: 0,
                title: Text("${getcubit.get(context).titels[getcubit.get(context).n]}",style: TextStyle(color: Colors.blue,fontSize: 25),),
              ),
              body: getcubit.get(context).screen[getcubit.get(context).n],
              bottomNavigationBar: BottomNavigationBar(
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.blue,
                currentIndex: getcubit.get(context).n,
                onTap: (index){
                  getcubit.get(context).appp(index);
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.home),label: "Home"),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble),label: "Chats"),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.plus_square_on_square),label: "Post"),
                  BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings),label: "Setting"),

                ],
              ),
            );
          }

      ),
    );
  }
}

// ElevatedButton(onPressed: () async {
// await cache_helper.deleteid().
// then((value) {
// Navigator.pushNamed(context, homepage.routname);
// });
// }, child: Text("LOGOUT")),