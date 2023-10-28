class likes{
  String id;
  String id_user;
  String id_post;
  bool like ;


  likes({this.id="",
    required this.id_user,
    required this.like,
required this.id_post
  });

  Map<String,dynamic> toFirestorelike(){
    return{
      "id" : id,
      "id_user" : id_user,
      "like" : like,
      "id_post" : id_post,



    };
  }
  likes.fromFirestorelike (Map<String,dynamic> json):this(
      id : json["id"],
      id_user : json['id_user'],
      like : json['like'],
    id_post : json['id_post'],


  );
}
