import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socail_app/home_page.dart';
import 'package:socail_app/models/User.dart';
import 'package:socail_app/network/firebse_utils.dart';
import 'package:socail_app/state%20management/cubit.dart';
import 'package:socail_app/state%20management/states.dart';

import 'models/modeluser.dart';

class regest extends StatelessWidget {
  static const String routname ='regest';
  final _key = GlobalKey<FormState>();
  TextEditingController phone =TextEditingController();
  TextEditingController email =TextEditingController();
  TextEditingController  passworde =TextEditingController();
  TextEditingController name=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context )=>regcubit(),
      child: BlocConsumer<regcubit,regeststates>(
        listener: (BuildContext context, regeststates state) {  },
        builder: (BuildContext context, regeststates state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key:_key ,
                child: ListView(
                  children: [
                    SafeArea(child: Container()),
                    SizedBox(
                      height: 50,
                    ),
                    Text("REGESTRION ",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller:name,
                      keyboardType: TextInputType.name,
                      validator: (value){
                        if(value == null || value.isEmpty  ){
                          return 'Enter User Name';
                        }
                      },
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          borderSide: new BorderSide(),
                        ),
                        prefixIcon:  Icon(Icons.person),
                        hintText: "Enter Name",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller:email,
                      keyboardType: TextInputType.emailAddress,

                      validator: (value){
                        if(value == null || value.isEmpty || !value.contains('@') ){
                          return 'Invalid Email';
                        }
                      },
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          borderSide: new BorderSide(),
                        ),
                        prefixIcon:  Icon(Icons.email_outlined),
                        hintText: "Enter Email",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passworde,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value){
                        if(value == null || value.isEmpty || value.length < 6){
                          return 'Invalid Password ';
                        }
                      },
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                            borderSide: new BorderSide(),
                          ),
                          prefixIcon:  Icon(Icons.lock_person_outlined),
                          hintText: "Enter Password",
                          suffixIcon: Icon(Icons.visibility)

                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      validator: (value){
                        if(value == null || value.isEmpty || value.length != 11){
                          return 'Invalid phone';
                        }
                      },
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          borderSide: new BorderSide(),
                        ),
                        prefixIcon:  Icon(Icons.mobile_friendly_outlined),
                        hintText: "Enter Phone Numbrer",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(onPressed: ()  async {
                      String _email=email.text;
                      String _password = passworde.text;
                      String _name = name.text;
                      String _phone = phone.text;


                      if(_key.currentState!.validate()){
                        User? user = await regcubit.get(context).signUpWithEmailAndPassword(_email, _password);
                        if (user == null){
                          print("User is successfully created");
                          taskedate task =taskedate(
                              name: _name,
                              email: _email,
                              phone: _phone,
                              image: "https://img.freepik.com/free-photo/two-funny-smiling-sisters-making-selfie-smaptphone-listening-music-posing-street-vacation-mood-crazy-positive-feeling-summer-bright-clothes-sunglasses_291650-201.jpg?t=st=1697827300~exp=1697827900~hmac=defdbe323c3688917ad3306d7e76cf5b8458e8d3bf76a3fe95504ed222679a25",
                              cover: "https://img.freepik.com/free-photo/person-enjoying-warm-nostalgic-sunset_52683-100695.jpg?w=996&t=st=1697799101~exp=1697799701~hmac=ad255372917a7011fec57c188e75627462330b6f64ff9b652c11eac02a3ad12a",
                              bio: "write bio ... ");
                          addtaskFirebaseFirestore(task);
                          // await regcubit.get(context).create(UserModel(email: _email,phone: _phone,username: _name,isvereviction: false));
                          Navigator.pushNamed(context, homepage.routname);
                        } else{
                          print("Some error happend");
                        }

                      }

                    }, child: Text("SING UP ",style: TextStyle(fontSize: 20),)),
                    Row(
                      children: [
                        Text("Do have an account ? ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                        TextButton(onPressed: (){
                          Navigator.pushNamed(context, homepage.routname);
                        }, child: Text("LOGIN ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        ),
    );
  }
}
