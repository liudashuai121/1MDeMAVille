import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unemindemaville/models/user.dart';

class UserDAO {
  String userID;
  UserDAO(this.userID);

  final CollectionReference userCollection =
      Firestore.instance.collection("users");

  Future createUserData(UserData userData) async {
    return await userCollection.document(userID).setData({
      'uid': userID,
      'email': userData.email,
      'name': userData.name,
      'gender': userData.gender,
      'avatar': userData.avatar,
      'date': userData.date,
      'postalCode': userData.postalCode
    });
  }

  Future<UserData> getUserData() async {
    DocumentSnapshot doc = await userCollection.document(userID).get();
    return UserData(
        uid: doc.data['uid'],
        email: doc.data['email'],
        name: doc.data['name'],
        gender: doc.data['gender'],
        avatar: doc.data['avatar'],
        postalCode: doc.data['postalCode']);
  }

  Future<bool> userExists(userDocID) async {
    DocumentSnapshot doc = await userCollection.document(userDocID).get();
    return doc.exists;
  }

  //get user data stream
  Stream<UserData> get userData {
    return userCollection
        .document(userID)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: snapshot.data['uid'],
        email: snapshot.data['email'],
        name: snapshot.data['name'],
        gender: snapshot.data['gender'],
        avatar: snapshot.data['avatar'],
        postalCode: snapshot.data['postalCode']);
  }

  Future updateProfilPhoto(String link) async {
    // TODO : After update, update all other occurences of avatar link (in video colloection)
    try {
      await userCollection.document(userID).updateData({'avatar': link});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static listenUsers(callback) async {
    Firestore.instance
        .collection("users")
        .orderBy("date", descending: true)
        .snapshots().listen((qs) {
      final videos = mapQueryToUserInfo(qs);
      callback(videos);
    });
  }

  static mapQueryToUserInfo(QuerySnapshot qs) {
    return qs.documents.map((DocumentSnapshot doc) {
      return UserData(
          uid: doc.data['uid'],
          email: doc.data['email'],
          name: doc.data['name'],
          gender: doc.data['gender'],
          avatar: doc.data['avatar'],
          date: doc.data['date'].toDate(),
          postalCode: doc.data['postalCode']);
    }).toList();
  }
}
