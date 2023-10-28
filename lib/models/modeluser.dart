
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
   String? id;
   String? username;
   String? email;
   String? phone;
   String? image;
   String? cover;
   String? bio;

   bool? isvereviction;


  UserModel({this.id, this.username,this.email,this.phone, this.isvereviction,this.cover,this.image,this.bio});

  factory UserModel.fromSnapshots(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot['username'],
      id: snapshot['id'],
      email: snapshot['email'],
      phone: snapshot['phone'],
      image: snapshot['image'],
      cover: snapshot['cover'],
      bio: snapshot['bio'],
      isvereviction: snapshot['isvereviction'],


    );
  }

  Map<String, dynamic> toJson() => {
    'username' : username,
    'id': id,
    'email' : email,
    'phone': phone,
    'image': image,
    'cover': cover,
    'bio': bio,
    'isvereviction': isvereviction,

  };

}
