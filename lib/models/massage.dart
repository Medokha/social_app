class massages{
  String id;
  String id_send;
  String id_rec;
  String massage;
  String date;
  String image;




  massages({this.id="",
    required this.id_send,
    required this.id_rec,
    required this.massage,
    required this.date,
    required this.image,



  });

  Map<String,dynamic> toFirestoremassage(){
    return{
      "id" : id,
      "id_send" : id_send,
      "id_rec" : id_rec,
      "massage" : massage,
      "date" : date,
      "image" : image,




    };
  }
  massages.fromFirestoremassage (Map<String,dynamic> json):this(
      id : json["id"],
      id_send : json['id_send'],
      id_rec : json['id_rec'],
      massage : json['massage'],
    date : json['date'],
    image : json['image'],



  );
}

