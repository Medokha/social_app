class taskedate{
  String id;
  String name;
  String email;
  String phone;
  String image;
  String cover;
  String bio;

  taskedate({this.id="",
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.cover,required this.bio
  });

  Map<String,dynamic> toFirestore(){
    return{
      "id" : id,
      "name" : name,
      "email" : email,
      "phone" : phone,
      "image" : image,
      "cover" : cover,
      "bio" : bio,

    };
  }
  taskedate.fromFirestore (Map<String,dynamic> json):this(
      id : json["id"],
      name : json['name'],
      email : json['email'],
      phone : json['phone'],
      image :json[ 'image'],
      cover : json['cover'],
      bio :json[ 'bio']
  );
}

class ardssetting {
  String image ;
  String cover ;
  ardssetting(this.image,this.cover);
}