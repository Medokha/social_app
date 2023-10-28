import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socail_app/home_page.dart';
import 'package:socail_app/regesration.dart';
import 'package:socail_app/screen/add_post.dart';
import 'package:socail_app/screen/search_details.dart';
import 'package:socail_app/screen/update.dart';
import 'package:socail_app/screen/user.dart';
import 'package:socail_app/social-layout.dart';

import 'network/cachehelper.dart';

late String mainpage;
var id = cache_helper.getid(key: "uId");

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await cache_helper.init();
  var id =await cache_helper.getid(key: "uId");
  print("jjjjjjjjjjjjjjjjjjjjj");
  print("${id}");
  if(id != null){
    mainpage = sociallayout.routname;
  }else{
    mainpage = homepage.routname;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:mainpage ,
      routes: {
        homepage.routname: (context) => homepage(),
        regest.routname: (context) => regest(),
        sociallayout.routname: (context) => sociallayout(),
        addpost.routname: (context) => addpost(),
        update.routname: (context) => update(),
        search_details.routname: (context) => search_details(),
        search.routname: (context) => search(),




      }
    );
  }
}