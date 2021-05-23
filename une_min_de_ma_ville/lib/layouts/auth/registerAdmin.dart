import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/services/auth.dart';
import 'package:unemindemaville/shared/colors.dart';

class RegisterAdmin extends StatefulWidget {
  RegisterAdmin({Key key}) : super(key: key);

  @override
  _RegisterAdminState createState() => _RegisterAdminState();
}

class _RegisterAdminState extends State<RegisterAdmin> {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passwordVisible = true;
  bool loading = false;
  bool isUser = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: _getRegisterAdmin(size),
        ));
  }

  Widget _getRegisterAdmin(size){
    return ListView(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 40, bottom: 20),
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo.jpg"),
                fit: BoxFit.fitHeight,
              ),
            )),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, ),
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(60),
          ),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: appSecondColor,
                ),
                border: InputBorder.none,
                labelText: "Email",
                labelStyle:
                TextStyle(color: appSecondColor)),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, ),
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
                onTap: (){
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                child: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: appSecondColor,
                ),),
              border: InputBorder.none,
              labelText: "Mot de passe",
              labelStyle:
              TextStyle(color: appSecondColor),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              color: Colors.white,
              textColor: appSecondColor,
              onPressed: () async {
                if (emailController.text.isEmpty) {
                  _showDialog("CHAMPS INCOMPLETS !", "Vous devez indiquer le nom de l'administrateur !");
                } else if (passController.text.isEmpty) {
                  _showDialog("CHAMPS INCOMPLETS !", "Veuillez renseigner un mot de passe !");
                } else {
                  createAccount(context);
                }
              },
              child: Text(
                "CREATION DU COMPTE",
              ),
            ),
          ),
        ),
      ],
    );
  }

  createAccount(context) async {
    setState(() {
      loading = true;
    });
    UserData userData = UserData(
      email: emailController.text,
    );
    await _authService.registerWithEmailAndPassword(userData, passController.text, false, true).then((result)
    {
      setState(() {
        loading = false;
      });
      switch(result){
        case 0: _showDialog("INSCRIPTION REUSSIE", "Cet admin peut désormais se connecter sur 1min2maVille ! Bonne supervision !");break;
        case 1: _showDialog("MOT DE PASSE FAIBLE", "Votre mot de passe doit contenir des chiffres, des lettres et des caractères spéciaux !");break;
        case 2: _showDialog("E-MAIL INVALIDE", "Veuillez renseigner votre mail correctement !");break;
        case 3: _showDialog("E-MAIL DEJA UTILISE", "Cet e-mail est déjà utilisé par un autre compte, veuillez en choisir un autre !");break;
        case 4: _showDialog("ERREUR RESEAU", "Impossible de se connecter aux serveurs !");break;
        default: _showDialog("ERREUR", "Une erreur s'est produite, veuillez réessayer plus tard !");
      }
    });
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
                if(titre == "INSCRIPTION REUSSIE"){
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
