class post{
  String id;
  String text;
  String data;
  String photo;
  String uid;


  post({this.id="",
    required this.text,
    required this.data,
    required this.photo,
    required this.uid,
  });

  Map<String,dynamic> toFirestorepost(){
    return{
      "id" : id,
      "text" : text,
      "data" : data,
      "photo" : photo,
      "uid" : uid,


    };
  }
  post.fromFirestorepost (Map<String,dynamic> json):this(
      id : json["id"],
      text : json['text'],
      data : json['data'],
      photo : json['photo'],
      uid :json[ 'uid'],

  );
}

