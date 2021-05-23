import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unemindemaville/layouts/admin/userListContainer.dart';
import 'package:unemindemaville/layouts/auth/chooseUserType.dart';
import 'package:unemindemaville/layouts/auth/registerAdmin.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/services/auth.dart';
import 'package:unemindemaville/services/databases/adminDAO.dart';
import 'package:unemindemaville/services/databases/departmentDAO.dart';
import 'package:unemindemaville/services/databases/userDAO.dart';
import 'package:unemindemaville/shared/colors.dart';
import 'package:unemindemaville/shared/styles.dart';

class UserList extends StatefulWidget {
  UserList();
  @override
  State<StatefulWidget> createState() {
    return _UserListState();
  }
}

class _UserListState extends State<UserList> {
  List<UserData> _users = <UserData>[];
  List<UserData> _departments = <UserData>[];
  List<UserData> _admins = <UserData>[];
  int selected = 1;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    final user = Provider.of<User>(context, listen: false);
    UserDAO.listenUsers((newUsers) {
      setState(() {
        _users = newUsers;
      });
    });
    DepartmentDAO.listenDepartments((newUsers) {
      setState(() {
        _departments = newUsers;
      });
    });
    AdminDAO.listenAdmins((newUsers) {
      setState(() {
        _admins = newUsers;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Utilisateurs",
          style: accountAppBarTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: appThirdColor, //change your color here
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            color: appThirdColor,
            onSelected: (String result) {
              if (result == "0") _deconnect();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                child: Text('Déconnexion'),
                value: "0",
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: selected != 3
          ? Container()
          : FloatingActionButton(
              backgroundColor: appMainColor,
              child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterAdmin()),
          );
        },
            ),
      body: Container(
        width: size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _users.length.toString(),
                          style: accountProfileEmail,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          "Utilisateurs",
                          style: publicationsText,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                  height: 30,
                  child: VerticalDivider(
                    width: 10,
                    thickness: 2,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _departments.length.toString(),
                          style: accountProfileEmail,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          "Comptes Mairies",
                          style: publicationsText,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                  height: 30,
                  child: VerticalDivider(
                    width: 10,
                    thickness: 2,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _admins.length.toString(),
                          style: accountProfileEmail,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          "Administrateurs",
                          style: publicationsText,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Expanded(
                child: UserListContainer(
              users: selected == 1
                  ? _users
                  : selected == 2
                      ? _departments
                      : _admins,
            ))
          ],
        ),
      ),
    );
  }

  _deconnect() async {
    //remove this screen and come back
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new ChooseUserType()),
        (Route<dynamic> route) => false);
    await _authService.signOut();
  }
}
