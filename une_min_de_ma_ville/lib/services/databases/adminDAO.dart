import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unemindemaville/models/user.dart';

class AdminDAO {
  String admintID;
  AdminDAO(this.admintID);

  final CollectionReference adminCollection =
  Firestore.instance.collection("admin");

  Future createAdminData(UserData userData) async {
    return await adminCollection.document(admintID).setData({
      'uid': admintID,
      'email': userData.email
    });
  }

  Future<UserData> getAdminData() async {
    DocumentSnapshot doc = await adminCollection.document(admintID).get();
    return UserData(
        uid: doc.data['uid'],
        email: doc.data['email']);
  }

  Future<bool> adminExists(userDocID) async {
    DocumentSnapshot doc = await adminCollection.document(userDocID).get();
    return doc.exists;
  }

  //get user data stream
  Stream<UserData> get userData {
    return adminCollection.document(admintID).snapshots().map(_userDataFromSnapshot);
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: snapshot.data['uid'],
        email: snapshot.data['email']);
  }

  static listenAdmins(callback) async {
    Firestore.instance
        .collection("admin")
        .snapshots().listen((qs) {
      final videos = mapQueryToAdminInfo(qs);
      callback(videos);
    });
  }

  static mapQueryToAdminInfo(QuerySnapshot qs) {
    return qs.documents.map((DocumentSnapshot doc) {
      return UserData(
          uid: doc.data['uid'],
          email: doc.data['email']);
    }).toList();
  }
}