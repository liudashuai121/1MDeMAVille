import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:unemindemaville/layouts/auth/loginAdmin.dart';
import 'package:unemindemaville/layouts/auth/loginDepartment.dart';
import 'package:unemindemaville/layouts/auth/loginUser.dart';
import 'package:unemindemaville/shared/colors.dart';

class ChooseUserType extends StatefulWidget {
  ChooseUserType({Key key}) : super(key: key);

  @override
  _ChooseUserTypeState createState() => _ChooseUserTypeState();
}

class _ChooseUserTypeState extends State<ChooseUserType> {

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Vous êtes :", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    color: Colors.white,
                    textColor: appSecondColor,
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginUser()),
                        );
                      });
                    },
                    child: Text(
                      "Un utilisateur",
                    ),
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
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginDepartment()),
                        );
                      });
                    },
                    child: Text(
                      "Une collectivité territoriale",
                    ),
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
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginAdmin()),
                        );
                      });
                    },
                    child: Text(
                      "Un administrateur",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
