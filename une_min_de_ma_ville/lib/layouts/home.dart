import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unemindemaville/layouts/account/profil.dart';
import 'package:unemindemaville/layouts/video/create.dart';
import 'package:unemindemaville/layouts/videofeed/feed.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/shared/colors.dart';

class Home extends StatefulWidget {
  Home({
    Key key
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                icon: Icon(Icons.lock_outline),
                title: Text('Créer'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.create),
                title: Text('Profil'),
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
      return CreateVideo();
    }
    else{
      return Profil();
    }
  }
}
