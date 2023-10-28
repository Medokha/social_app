class comment{
  String id;
  String text;
  String id_user;
  String id_post;


  comment({this.id="",
    required this.text,
    required this.id_user,
    required this.id_post,
  });

  Map<String,dynamic> toFirestorecomment(){
    return{
      "id" : id,
      "text" : text,
      "id_user" : id_user,
      "id_post" : id_post,


    };
  }
  comment.fromFirestorecomment (Map<String,dynamic> json):this(
    id : json["id"],
    text : json['text'],
    id_user : json['id_user'],
    id_post :json[ 'id_post'],

  );
}

