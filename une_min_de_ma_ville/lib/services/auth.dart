import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/services/databases/adminDAO.dart';
import 'package:unemindemaville/services/databases/departmentDAO.dart';
import 'package:unemindemaville/services/databases/userDAO.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid): null;
  }

  //Stream for auth state change
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map((_userFromFirebaseUser));
  }

  Stream<String> get onAuthStateChanger =>
      _auth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);

  // register user and return 0 or another number if error
  Future registerWithEmailAndPassword(UserData userData, String password, bool isUser, bool isAdmin) async{
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: userData.email, password: password);
      FirebaseUser currentUser = result.user;
      if(isAdmin)
        await AdminDAO(currentUser.uid).createAdminData(userData);
      else if(isUser)
        await UserDAO(currentUser.uid).createUserData(userData);
      else
        await DepartmentDAO(currentUser.uid).createDepartmentData(userData);
      return 0;
    } catch (e) {
      if (e.toString().contains("ERROR_WEAK_PASSWORD"))
        return 1;
      else if (e.toString().contains("ERROR_INVALID_EMAIL"))
        return 2;
      else if (e.toString().contains("ERROR_EMAIL_ALREADY_IN_USE"))
        return 3;
      else if (e.toString().contains("ERROR_NETWORK_REQUEST_FAILED"))
        return 4;
      else
        return 5;
    }
  }

  Future<int> signInUserEmailAndPassword(String email, String password) async {
    bool isUser = false;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser currentUser = result.user;
      isUser = await UserDAO("").userExists(currentUser.uid);
      if(isUser== false){
        _auth.signOut();
        return 7;
      }
      // persist user identifiers
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('isUser', true);
      return 0;
    } catch (e){
      if (e.toString().contains("ERROR_WRONG_PASSWORD"))
        return 1;
      else if (e.toString().contains("ERROR_INVALID_EMAIL"))
        return 2;
      else if (e.toString().contains("ERROR_USER_NOT_FOUND"))
        return 3;
      else if (e.toString().contains("ERROR_USER_DISABLED"))
        return 4;
      else if (e.toString().contains("ERROR_TOO_MANY_REQUESTS"))
        return 5;
      else if (e.toString().contains("ERROR_NETWORK_REQUEST_FAILED"))
        return 6;
      else
        return 8;
    }
  }

  Future<int> signInDepartmentEmailAndPassword(String email, String password) async {
    bool isDepartment = false;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser currentUser = result.user;
      isDepartment = await DepartmentDAO("").departmentExists(currentUser.uid);
      if(isDepartment== false){
        _auth.signOut();
        return 7;
      }
      // persist user identifiers
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('isDepartment', true);
      return 0;
    } catch (e){
      if (e.toString().contains("ERROR_WRONG_PASSWORD"))
        return 1;
      else if (e.toString().contains("ERROR_INVALID_EMAIL"))
        return 2;
      else if (e.toString().contains("ERROR_USER_NOT_FOUND"))
        return 3;
      else if (e.toString().contains("ERROR_USER_DISABLED"))
        return 4;
      else if (e.toString().contains("ERROR_TOO_MANY_REQUESTS"))
        return 5;
      else if (e.toString().contains("ERROR_NETWORK_REQUEST_FAILED"))
        return 6;
      else
        return 8;
    }
  }

  Future<int> signInAdminEmailAndPassword(String email, String password) async {
    bool isAdmin = false;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser currentUser = result.user;
      isAdmin = await AdminDAO("").adminExists(currentUser.uid);
      if(isAdmin== false){
        _auth.signOut();
        return 7;
      }
      // persist user identifiers
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      return 0;
    } catch (e){
      if (e.toString().contains("ERROR_WRONG_PASSWORD"))
        return 1;
      else if (e.toString().contains("ERROR_INVALID_EMAIL"))
        return 2;
      else if (e.toString().contains("ERROR_USER_NOT_FOUND"))
        return 3;
      else if (e.toString().contains("ERROR_USER_DISABLED"))
        return 4;
      else if (e.toString().contains("ERROR_TOO_MANY_REQUESTS"))
        return 5;
      else if (e.toString().contains("ERROR_NETWORK_REQUEST_FAILED"))
        return 6;
      else
        return 8;
    }
  }

  Future<void> signOut() async {
    try {
      // clean persisted user info
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      //await prefs.setInt("initScreen", 1);
      _auth.signOut();
    } catch (e){
      print(e.toString());
    }
  }
}