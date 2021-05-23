import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unemindemaville/layouts/admin/feedUnvalidated.dart';
import 'package:unemindemaville/layouts/admin/userList.dart';
import 'package:unemindemaville/layouts/videofeed/feed.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/shared/colors.dart';

class HomeAdmin extends StatefulWidget {
  HomeAdmin({
    Key key
  }) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return  Scaffold(
      body: getPage(_selectedIndex, user),

      bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
              canvasColor: appMainColor,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              //primaryColor: Colors.red,
              textTheme: Theme.of(context)
                  .textTheme),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.public),
                title: Text('Vidéos'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public),
                title: Text('A valider'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                title: Text('Utilisateurs'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: appSecondColor,
            onTap: _onItemTapped,
            iconSize: 20,
            unselectedItemColor: Colors.white,
            showUnselectedLabels: true,
          )),
    );
  }

  Widget getPage(int index, User user){
    if(index == 0){
      return Feed();
    }
    else if(index == 1){
      return FeedUnvalidated();
    }
    else{
      return UserList();
    }
  }
}
