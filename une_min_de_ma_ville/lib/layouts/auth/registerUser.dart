import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/services/auth.dart';
import 'package:unemindemaville/shared/colors.dart';

class RegisterUser extends StatefulWidget {
  RegisterUser({Key key}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final AuthService _authService = AuthService();
  final nameController = TextEditingController();
  final genreController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passwordVisible = true;
  bool loading = false;
  bool userTypeChoosed = false;
  String _currentPostalCode;
  String _currentSex;

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
          child: _getRegisterUser(size),
        ));
  }

  Widget _getRegisterUser(size){
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
            controller: nameController,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: appSecondColor,
                ),
                border: InputBorder.none,
                labelText: "NOM Pr??nom",
                labelStyle:
                TextStyle(color: appSecondColor)),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(60),
          ),
          //TODO: Liste d??roulante pour le code postal
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("villes")
                    .orderBy("codepostal")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Text('Chargement...');
                  else {
                    List<DropdownMenuItem> currencyItems = [];
                    for (int i = 0;
                    i < snapshot.data.documents.length;
                    i++) {
                      DocumentSnapshot snap = snapshot.data.documents[i];
                      currencyItems.add(
                        DropdownMenuItem(
                          child: Text(
                            snap.data["codepostal"].toString(),
                            style: TextStyle(color: appSecondColor),
                          ),
                          value: "${snap.data["codepostal"]}",
                        ),
                      );
                    }
                    return DropdownButton(
                      items: currencyItems,
                      onChanged: (codeValue) {
                        setState(() {
                          _currentPostalCode = codeValue;
                        });
                      },
                      value: _currentPostalCode,
                      isExpanded: true,
                      hint: new Text("Code postal",
                        style: TextStyle(color: appSecondColor),
                      ),
                    );
                  }
                }),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(60),
          ),
          child: DropdownButton(
            items: getDropDownSexItems(),
            onChanged: (sexValue) {
              setState(() {
                _currentSex = sexValue;
              });
            },
            value: _currentSex,
            isExpanded: true,
            hint: new Text("Sexe",
              style: TextStyle(color: appSecondColor),
            ),
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.mail,
                  color: appSecondColor,
                ),
                border: InputBorder.none,
                labelText: "E-mail",
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
              onPressed: () {
                print(_currentPostalCode);
                if (nameController.text.isEmpty) {
                  _showDialog("CHAMPS INCOMPLETS !", "Vous devez indiquer votre nom !");
                } else if (_currentPostalCode == null) {
                  _showDialog("CHAMPS INCOMPLETS !", "Veuillez s??lectionner un code postal !");
                } else if (_currentSex == null) {
                  _showDialog("CHAMPS INCOMPLETS !", "Veuillez indiquer votre sexe !");
                } else if (emailController.text.isEmpty) {
                  _showDialog("CHAMPS INCOMPLETS !", "L'e-mail doit ??tre renseign?? !");
                } else if (passController.text.isEmpty) {
                  _showDialog("CHAMPS INCOMPLETS !", "Le mot de passe doit ??tre renseign?? !");
                } else {
                  createAccount(context);
                }
              },
              child: Text(
                "INSCRIPTION",
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
                Navigator.pop(context);
              },
              child: Text(
                "D??j?? inscrit ? Connectez-vous",
              ),
            )),
      ],
    );
  }

  Widget _getRegisterMairie(size){
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
            controller: nameController,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: appSecondColor,
                ),
                border: InputBorder.none,
                labelText: "Nom de la collectivit??",
                labelStyle:
                TextStyle(color: appSecondColor)),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width * 0.8,
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(60),
          ),
          //TODO: Liste d??roulante pour le code postal
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("villes")
                    .orderBy("codepostal")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Text('Chargement...');
                  else {
                    List<DropdownMenuItem> currencyItems = [];
                    for (int i = 0;
                    i < snapshot.data.documents.length;
                    i++) {
                      DocumentSnapshot snap = snapshot.data.documents[i];
                      currencyItems.add(
                        DropdownMenuItem(
                          child: Text(
                            snap.data["codepostal"].toString(),
                            style: TextStyle(color: appSecondColor),
                          ),
                          value: "${snap.data["codepostal"]}",
                        ),
                      );
                    }
                    return DropdownButton(
                      items: currencyItems,
                      onChanged: (codeValue) {
                        setState(() {
                          _currentPostalCode = codeValue;
                        });
                      },
                      value: _currentPostalCode,
                      isExpanded: true,
                      hint: new Text("Code postal",
                        style: TextStyle(color: appSecondColor),
                      ),
                    );
                  }
                }),
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.mail,
                  color: appSecondColor,
                ),
                border: InputBorder.none,
                labelText: "E-mail",
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
              onPressed: () {
                if (nameController.text.isEmpty) {
                  _showDialog("CHAMPS INCOMPLETS !", "Vous devez indiquer le nom de la collectivit?? !");
                } else if (_currentPostalCode == null) {
                  _showDialog("CHAMPS INCOMPLETS !", "Veuillez s??lectionner un code postal !");
                } else if (emailController.text.isEmpty) {
                  _showDialog("CHAMPS INCOMPLETS !", "L'e-mail doit ??tre indiqu?? !");
                } else if (passController.text.isEmpty) {
                  _showDialog("CHAMPS INCOMPLETS !", "Veuillez renseigner un mot de passe !");
                } else {
                  createAccount(context);
                }
              },
              child: Text(
                "INSCRIPTION",
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
                Navigator.pop(context);
              },
              child: Text(
                "D??j?? inscrit ? Connectez-vous",
              ),
            )),
      ],
    );
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownSexItems() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(DropdownMenuItem(value: "Homme", child: new Text("Homme",
        style: TextStyle(color: appSecondColor))));
    items.add(DropdownMenuItem(value: "Femme", child: new Text("Femme",
        style: TextStyle(color: appSecondColor))));
    items.add(DropdownMenuItem(value: "Autre", child: new Text("Autre",
        style: TextStyle(color: appSecondColor))));
    return items;
  }

  createAccount(context) async {
    setState(() {
      loading = true;
    });
    UserData userData = UserData(
      email: emailController.text,
      name: nameController.text,
      avatar: null,
      date: DateTime.now(),
      postalCode: int.parse(_currentPostalCode),
      gender: _currentSex
    );
    await _authService.registerWithEmailAndPassword(userData, passController.text, true, false).then((result)
    {
      setState(() {
        loading = false;
      });
      switch(result){
        case 0: _showDialog("INSCRIPTION REUSSIE", "Vous pouvez d??sormais vous connecter sur 1min2maVille ! Nous vous souhaitons une belle naviguation !");break;
        case 1: _showDialog("MOT DE PASSE FAIBLE", "Votre mot de passe doit contenir des chiffres, des lettres et des caract??res sp??ciaux !");break;
        case 2: _showDialog("E-MAIL INVALIDE", "Veuillez renseigner votre mail correctement !");break;
        case 3: _showDialog("E-MAIL DEJA UTILISE", "Cet e-mail est d??j?? utilis?? par un autre compte, veuillez en choisir un autre !");break;
        case 4: _showDialog("ERREUR RESEAU", "Impossible de se connecter aux serveurs !");break;
        default: _showDialog("ERREUR", "Une erreur s'est produite, veuillez r??essayer plus tard !");
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
