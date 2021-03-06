import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unemindemaville/layouts/auth/registerDepartment.dart';
import 'package:unemindemaville/layouts/home.dart';
import 'package:unemindemaville/services/auth.dart';
import 'package:unemindemaville/shared/colors.dart';
import 'package:unemindemaville/shared/loader.dart';

class LoginDepartment extends StatefulWidget {
  LoginDepartment({Key key}) : super(key: key);

  @override
  _LoginDepartmentState createState() => _LoginDepartmentState();
}

class _LoginDepartmentState extends State<LoginDepartment> {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passwordVisible = true;
  bool loading = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(body: Builder(
      // Create an inner BuildContext so that the onPressed methods
      // can refer to the Scaffold with Scaffold.of().
      builder: (BuildContext context) {
        return loading
            ? LoaderWhiteBack()
            : Container(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 100)),
                    Container(
                        margin: EdgeInsets.only(bottom: 40),
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/logo.jpg"),
                            fit: BoxFit.fitHeight,
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: inputColor,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.mail,
                              color: appSecondColor,
                            ),
                            border: InputBorder.none,
                            labelText: "E-mail",
                            labelStyle: TextStyle(color: appSecondColor)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: inputColor,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: TextField(
                        controller: passController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: appSecondColor,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              child: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: appSecondColor,
                              ),
                            ),
                            border: InputBorder.none,
                            labelText: "Mot de passe",
                            labelStyle: TextStyle(color: appSecondColor)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          color: Colors.white,
                          textColor: appSecondColor,
                          onPressed: () {
                            if (emailController.text.isEmpty) {
                              _showDialog("CHAMPS INCOMPLETS !",
                                  "L'e-mail doit ??tre renseign?? !");
                            } else if (passController.text.isEmpty) {
                              _showDialog("CHAMPS INCOMPLETS !",
                                  "Le mot de passe doit ??tre renseign?? !");
                            } else {
                              tryConnexion();
                            }
                          },
                          child: Text(
                            "CONNEXION",
                          ),
                        ),
                      ),
                    ),
                    Container(
                        child: FlatButton(
                      //color: Colors.white,
                      textColor: Colors.black,
                      //splashColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterDepartment()),
                        );
                      },
                      child: Text(
                        "Pas encore inscrit ? Cr??ez un compte",
                      ),
                    )),
                    Padding(padding: EdgeInsets.only(top: 100)),
                  ],
                ),
              );
      },
    ));
  }

  void _showDialog(titre, msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(titre),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  tryConnexion() async {
    setState(() {
      loading = true;
    });
    await _authService
        .signInDepartmentEmailAndPassword(emailController.text, passController.text)
        .then((result) {
      setState(() {
        loading = false;
      });
      switch (result) {
        case 0:
          moveAfterConnexion();
          break;
        case 1:
          _showDialog("IDENTIFIANT(S) ERRONE(S)",
              "L'e-mail et/ou le mot de passe est incorrect !");
          break;
        case 2:
          _showDialog("E-MAIL INVALIDE", "Cet e-mail n'est pas valide !");
          break;
        case 3:
          _showDialog("UTILISATEUR INCONNU",
              "Ce compte n'est pas pr??sent parmi nos membres !");
          break;
        case 4:
          _showDialog("COMPTE DESACTIVE",
              "Votre compte a ??t?? d??sactiv??, veuillez en cr??er un nouveau !");
          break;
        case 6:
          _showDialog(
              "ERREUR RESEAU", "Impossible de se connecter aux serveurs !");
          break;
        case 7:
          _showDialog(
              "ERREUR IDENTIFICATION", "Vous n'??tes pas enregistr?? comme un compte de collectivit?? territoriale !");
          break;
        default:
          _showDialog("ERREUR",
              "Une erreur s'est produite, veuillez r??essayer plus tard !");
      }
    });
  }

  moveAfterConnexion() async{
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new Home()),
            (Route<dynamic> route) => false);
  }
}
