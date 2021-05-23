import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unemindemaville/layouts/admin/homeAdmin.dart';
import 'package:unemindemaville/layouts/auth/chooseUserType.dart';
import 'package:unemindemaville/layouts/home.dart';
import 'package:unemindemaville/layouts/onboarding.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/services/auth.dart';

int initScreen = 0;
bool isUser, isDepartment;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  isUser = await prefs.getBool('isUser');
  isDepartment = await prefs.getBool('isDepartment');

  runApp(StreamProvider<User>.value(
    value: AuthService().user,
    child: MaterialApp(
      title: '1 min de ma ville',
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    _getSharedPrefs().then((status) {
      if (!status) return ChooseUserType();
      return null;
    });
    try {
      if (initScreen != 1){
        return OnboardingScreen();
      }
      else if (user == null){
        return ChooseUserType();
      }
      else{
        if(isUser != true && isDepartment != true){
          return HomeAdmin();
        }
        return Home();
      } 
    }catch(e){
      print (e);
    }
  }

  Future<bool> _getSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("email") != null &&
        prefs.getString("password") != null)
      return true;
    else
      return false;
  }
}