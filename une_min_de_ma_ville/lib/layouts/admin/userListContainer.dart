import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unemindemaville/layouts/videofeed/widgets/player.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/models/video_info.dart';
import 'package:unemindemaville/shared/colors.dart';

class UserListContainer extends StatefulWidget {
  final List<UserData> users;
  UserListContainer({this.users});
  @override
  State<UserListContainer> createState() => _UserListContainerState();
}

class _UserListContainerState extends State<UserListContainer> {

  @override
  Widget build(BuildContext context) {
    if (widget.users.length == 0) {
      return Container(
        padding: EdgeInsets.all(60),
        child: Center(
          child: Text(
            "Il n'y a aucun compte à afficher actuellement",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      );
    } else {
      return ListView.builder(padding: EdgeInsets.only(top: 0),
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          if (widget.users[index].name == null)
            return displayAdminContainer(widget.users[index], index);
          if (widget.users[index].gender == null)
            return displayDepartmentContainer(widget.users[index], index);
          return displayUserContainer(widget.users[index], index);
        },
      );
    }
  }

  Widget displayUserContainer(UserData userData, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Material(
        type: MaterialType.card,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          child: Container(
            margin: new EdgeInsets.only(left: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.only(right: 10),
                  child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: userData.avatar != null
                                ? NetworkImage(userData.avatar)
                                : AssetImage(
                                'assets/images/user_profile.png'),
                            fit: BoxFit.fitWidth,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(100.0)),
                        ),
                      )),
                ),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child:
                      Text(
                        userData.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Text(userData.email.toString(),
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Text(
                        "Inscrit le : " + userData.date.toString(),
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Text(
                        userData.gender + " | " + userData.postalCode.toString(),
                        maxLines: 3,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ))
              ],
            )
            ,
          ),
        ),
      ),
    );
  }
  Widget displayDepartmentContainer(UserData userData, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Material(
        type: MaterialType.card,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          child: Container(
            margin: new EdgeInsets.only(left: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.only(right: 10),
                  child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: userData.avatar != null
                                ? NetworkImage(userData.avatar)
                                : AssetImage(
                                'assets/images/user_profile.png'),
                            fit: BoxFit.fitWidth,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(100.0)),
                        ),
                      )),
                ),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child:
                      Text(
                        userData.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Text(userData.email.toString(),
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Text(
                        "Inscrit le : " + userData.date.toString(),
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Text(
                        userData.postalCode.toString(),
                        maxLines: 3,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ))
              ],
            )
            ,
          ),
        ),
      ),
    );
  }
  Widget displayAdminContainer(UserData userData, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Material(
        type: MaterialType.card,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          child: Container(
            margin: new EdgeInsets.only(left: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Text(userData.email.toString(),
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ))
              ],
            )
          ),
        ),
      ),
    );
  }
}
