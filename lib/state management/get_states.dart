abstract class getstates {}

class getintialstate extends getstates{}
class getchangestate extends getstates{}
class getsuccesstate extends getstates{}
class getfailstate extends getstates{
  final String error;
  getfailstate(this.error);
}




class changestate extends getstates{}
class intialstate extends getstates{}
class successtate extends getstates{}
class failstate extends getstates{
  final String error;
  failstate(this.error);
}


class add extends getstates{}
class intialadd extends getstates{}
class succesadd extends getstates{}
class failadd extends getstates{
  final String error;
  failadd(this.error);
}

class imagestate extends getstates{}
class imageinitstate extends getstates{}
class imagesuccesstate extends getstates{}
class imagefailstate extends getstates{
  final String error;
  imagefailstate(this.error);
}

class coverstate extends getstates{}
class coverinitstate extends getstates{}
class coversuccesstate extends getstates{}
class coverfailstate extends getstates{
  final String error;
  coverfailstate(this.error);
}

class updatesuccesstate extends getstates{}
class updatefailstate extends getstates{
  final String error;
  updatefailstate(this.error);
}


class postimagesuccesstate extends getstates{}
class postimagefailstate extends getstates {
  final String error;

  postimagefailstate(this.error);
}
class removeimagesuccesstate extends getstates{}


class chatimagesuccesstate extends getstates{}
class chatimagefailstate extends getstates {
  final String error;

  chatimagefailstate(this.error);
}
