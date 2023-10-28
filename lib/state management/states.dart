abstract class regeststates {}

class regestintialstate extends regeststates{}
class regestchangestate extends regeststates{}
class regestsuccesstate extends regeststates{

}
class regestfailstate extends regeststates{
  final String error;
  regestfailstate(this.error);
}

class loginsuccesstate extends regeststates{
  final String uid;
  loginsuccesstate(this.uid);
}
class loginfailstate extends regeststates{
  final String error;
  loginfailstate(this.error);
}

class crudintialstate extends regeststates{}
class crudchangestate extends regeststates{}
class crudsuccesstate extends regeststates{}
class crudfailstate extends regeststates{
  final String error;
  crudfailstate(this.error);
}


