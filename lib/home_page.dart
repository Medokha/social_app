
import 'package:socail_app/state%20management/get_cubit.dart';
import 'network/cachehelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socail_app/regesration.dart';
import 'package:socail_app/social-layout.dart';
import 'package:socail_app/state%20management/cubit.dart';
import 'package:socail_app/state%20management/states.dart';

class homepage extends StatelessWidget {

  final _key = GlobalKey<FormState>();
  TextEditingController email  =TextEditingController();
  TextEditingController  password =TextEditingController();

  static const String routname ='homepage';
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<getcubit>(create:(BuildContext context) =>getcubit()),
        BlocProvider<regcubit>(create:(BuildContext context) => regcubit()),
      ],
      child: BlocConsumer<regcubit,regeststates>(
        listener: (BuildContext context, regeststates state) async {
          if(state is loginfailstate){
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Error !! ',style: TextStyle(fontSize: 30),),
                  icon: Icon(Icons.error,size: 50,),
                  iconColor: Colors.red,
                  content: Text('${state.error}',),
                  actions: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                        child: Text("OK",style:TextStyle(fontSize: 30),))
                  ],
                )
            );
            Navigator.pushReplacementNamed(context, homepage.routname);

          }
          if(state is loginsuccesstate){
            await cache_helper.putid(
                key: "uId", value:state.uid).
            then((value) {
              Navigator.pushNamed(context, sociallayout.routname);
            });

          }
        },
        builder: (BuildContext context, regeststates state) {
          return  Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key:_key ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SafeArea(child: Container()),
                    Text("LOGIN",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w500)),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Enter Email And Password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300)),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller:email,
                      validator: (value){
                        if(value == null || value.isEmpty || !value.contains('@') ){
                          return 'Invalid Email';
                        }
                        return null;
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
                      controller: password,
                      validator: (value){
                        if(value == null || value.isEmpty || value.length < 6){
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          borderSide: new BorderSide(),
                        ),
                        prefixIcon:  Icon(Icons.lock_person_outlined),
                        hintText: "Enter Password",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(onPressed: () async {
                      String _email=email.text;
                      String _password = password.text;
                      if(_key.currentState!.validate()){
                        User? user = await regcubit.get(context).signInWithEmailAndPassword(_email, _password);
                        IdTokenResult? userr = await FirebaseAuth.instance.currentUser?.getIdTokenResult();
                        print("///////////////////");
                        print(userr);
                        print("/////////////////");
                        if (user == null){
                          print("User is successfully created");
                          Navigator.pushNamed(context, sociallayout.routname);
                        } else{
                          print("Some error happend");
                        }
                      }

                    }, child: Text("LOGIN ",style: TextStyle(fontSize: 20),)),
                    Row(
                      children: [
                        Text("Dont have an account ? ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                        TextButton(onPressed: (){
                          Navigator.pushNamed(context, regest.routname);
                        }, child: Text("REGISTER",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))),

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
  void bottomsheet(BuildContext context){
    showModalBottomSheet
      (context: context,
        builder: (c){
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Text("Please verfiy your account ",style: TextStyle(fontSize: 25),),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(onPressed: (){
                  FirebaseAuth.instance.currentUser?.sendEmailVerification()
                      .then((value) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Check mail',style: TextStyle(fontSize: 30),),
                          iconColor: Colors.red,
                          actions: [
                            InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Text("OK",style:TextStyle(fontSize: 30),))
                          ],
                        )
                    );
                  });
                }, child: Text("Send",style: TextStyle(fontSize: 25),))
              ],
            ),
          );
        });
  }
}
