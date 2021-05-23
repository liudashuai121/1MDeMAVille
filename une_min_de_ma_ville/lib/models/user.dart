class User {
  String uid;
  UserData userData;
  User({this.uid});
}

class UserData {
  String uid;
  String email;
  String name;
  String gender;
  String avatar;
  DateTime date;
  int postalCode;
  UserData({this.uid, this.email, this.name, this.gender, this.avatar, this.date, this.postalCode});
  UserData.light({this.email, this.name, this.gender, this.avatar, this.date, this.postalCode});
}
