import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unemindemaville/models/user.dart';

class DepartmentDAO {
  String departmentID;
  DepartmentDAO(this.departmentID);

  final CollectionReference departmentCollection =
  Firestore.instance.collection("department");

  Future createDepartmentData(UserData userData) async {
    return await departmentCollection.document(departmentID).setData({
      'uid': departmentID,
      'email': userData.email,
      'name': userData.name,
      'avatar': userData.avatar,
      'date': userData.date,
      'postalCode': userData.postalCode
    });
  }

  Future<UserData> getDepartmentData() async {
    DocumentSnapshot doc = await departmentCollection.document(departmentID).get();
    return UserData(
        uid: doc.data['uid'],
        email: doc.data['email'],
        name: doc.data['name'],
        gender: null,
        avatar: doc.data['avatar'],
        postalCode: doc.data['postalCode']);
  }

  Future<bool> departmentExists(userDocID) async {
    DocumentSnapshot doc = await departmentCollection.document(userDocID).get();
    return doc.exists;
  }

  //get user data stream
  Stream<UserData> get userData {
    return departmentCollection.document(departmentID).snapshots().map(_userDataFromSnapshot);
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: snapshot.data['uid'],
        email: snapshot.data['email'],
        name: snapshot.data['name'],
        gender: null,
        avatar: snapshot.data['avatar'],
        postalCode: snapshot.data['postalCode']);
  }


  Future updateProfilPhoto(String link) async {
    // TODO : After update, update all other occurences of avatar link (in video colloection)
    try {
      await departmentCollection
          .document(departmentID)
          .updateData({'avatar': link});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static listenDepartments(callback) async {
    Firestore.instance
        .collection("department")
        .orderBy("date", descending: true)
        .snapshots().listen((qs) {
      final videos = mapQueryToDepartmentInfo(qs);
      callback(videos);
    });
  }

  static mapQueryToDepartmentInfo(QuerySnapshot qs) {
    return qs.documents.map((DocumentSnapshot doc) {
      return UserData(
          uid: doc.data['uid'],
          email: doc.data['email'],
          name: doc.data['name'],
          gender: null,
          avatar: doc.data['avatar'],
          date: doc.data['date'].toDate(),
          postalCode: doc.data['postalCode']);
    }).toList();
  }
}