import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unemindemaville/layouts/auth/chooseUserType.dart';
import 'package:unemindemaville/layouts/videofeed/apis/firebase_provider.dart';
import 'package:unemindemaville/layouts/videofeed/videoList.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/models/video_info.dart';
import 'package:unemindemaville/services/auth.dart';
import 'package:unemindemaville/services/databases/departmentDAO.dart';
import 'package:unemindemaville/services/databases/userDAO.dart';
import 'package:unemindemaville/shared/colors.dart';
import 'package:unemindemaville/shared/loader.dart';
import 'package:unemindemaville/shared/styles.dart';

class Profil extends StatefulWidget {
  FirebaseStorage storage;
  Profil({this.storage});
  @override
  State<StatefulWidget> createState() {
    return _ProfilState();
  }
}

class _ProfilState extends State<Profil> {
  final AuthService _authService = AuthService();
  File choosedImageFile;
  final _picker = ImagePicker();
  bool choosing = false;
  bool validated = true;
  bool isUser = false;
  bool isDepartment = false;
  List<VideoInfo> _validatedVideos = <VideoInfo>[];
  List<VideoInfo> _unvalidatedVideos = <VideoInfo>[];

  @override
  void initState() {
    final user = Provider.of<User>(context, listen: false);
    print("dkoivkdfoiv");
    print(user.uid);
    FirebaseProvider.listenToPersonalValidatedVideos((newVideos) {
      _validatedVideos = newVideos;
    }, user.uid);
    FirebaseProvider.listenToPersonalUnvalidatedVideos((newVideos) {
      _unvalidatedVideos = newVideos;
    }, user.uid);
    checkUserType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);

    return StreamBuilder<UserData>(
        stream: isUser == true ? UserDAO(user.uid).userData : DepartmentDAO(user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //ToDO : return personnalised container box for error and awaiting
            return Container();
          } else if (snapshot.hasData) {
            UserData userdata = snapshot.data;
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  "Profil",
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
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        child: Text('Déconnexion'),
                        value: "0",
                      ),
                    ],
                  ),
                ],
              ),
              body: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 100),
                          height: 170,
                          child: Center(
                              child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: userdata.avatar != null
                                    ? NetworkImage(userdata.avatar)
                                    : AssetImage(
                                        'assets/images/user_profile.png'),
                                fit: BoxFit.fitWidth,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                            ),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      choosing = true;
                                    });
                                  },
                                  elevation: 2.0,
                                  fillColor: Colors.white,
                                  shape: CircleBorder(),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                )),
                          )),
                        ),
                        Container(
                          child: Text(
                            userdata.name,
                            style: accountProfileName,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          child: Text(
                            userdata.email,
                            style: accountProfileEmail,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            isUser == true? Text(
                              userdata.gender,
                              style: accountProfileEmail,
                              textAlign: TextAlign.center,
                            ): Container(),
                            SizedBox(width: 50.0),
                            Text(
                              userdata.postalCode.toString(),
                              style: accountProfileEmail,
                              textAlign: TextAlign.center,
                            )
                          ],),
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  validated = true;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _validatedVideos.length.toString(),
                                    style: accountProfileEmail,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 15.0),
                                  Text(
                                    "Publications",
                                    style: publicationsText,
                                    textAlign: TextAlign.center,
                                  )
                                ],),
                            ),
                            SizedBox(width: 50.0, height: 30, child: VerticalDivider(width: 10,thickness: 2,),),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  validated = false;
                                });
                              },child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _unvalidatedVideos.length.toString(),
                                  style: accountProfileEmail,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 15.0),
                                Text(
                                  "Non validées",
                                  style: publicationsText,
                                  textAlign: TextAlign.center,
                                )
                              ],),),
                          ],),
                        SizedBox(height: 15.0),
                        Expanded(
                            child: VideoList(
                              videos: validated? _validatedVideos: _unvalidatedVideos,
                            ))
                      ],
                    ),
                  ),
                  choosing
                      ? Container(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      choosing = false;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.black45,
                                    child: choosedImageFile != null
                                        ? Center(
                                            child: Image.file(
                                              choosedImageFile,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                height: 150,
                                color: appMainColor,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text("Photo de profil",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            RawMaterialButton(
                                              onPressed: () {
                                                takePhoto();
                                              },
                                              elevation: 2.0,
                                              fillColor: appSecondColor,
                                              shape: CircleBorder(),
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Icon(
                                                  Icons.photo_camera,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Caméra",
                                                style: TextStyle(
                                                    color: Colors.black))
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            RawMaterialButton(
                                              onPressed: () {
                                                choosePhoto();
                                              },
                                              elevation: 2.0,
                                              fillColor: appSecondColor,
                                              shape: CircleBorder(),
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Icon(
                                                  Icons.photo,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Galerie",
                                                style: TextStyle(
                                                    color: Colors.black))
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            RawMaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  choosedImageFile = null;
                                                });
                                              },
                                              elevation: 2.0,
                                              fillColor: appSecondColor,
                                              shape: CircleBorder(),
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("Supprimer",
                                                style: TextStyle(
                                                    color: Colors.black))
                                          ],
                                        ),
                                        choosedImageFile != null
                                            ? Column(
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {
                                                      uploadPhoto(
                                                          user,
                                                          userdata);
                                                      setState(() {
                                                        choosing = false;
                                                      });
                                                    },
                                                    elevation: 2.0,
                                                    fillColor: Colors.white,
                                                    shape: CircleBorder(),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child: Icon(
                                                        Icons.send,
                                                        color: appSecondColor,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("Choisir",
                                                      style: TextStyle(
                                                          color: Colors.black))
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  //fin partie vidéo
                  /*changing ? changeText(mode, userdata) :*/ Container()
                ],
              ),
            );
          } else {
            return LoaderWhiteBack();
          }
        });
  }

  _deconnect() async {
    //remove this screen and come back
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new ChooseUserType()),
            (Route<dynamic> route) => false);
    await _authService.signOut();
  }

  Future choosePhoto() async {
    PickedFile image = await _picker.getImage(
      source: ImageSource.gallery,
    );
    print("IMAGE");
    print(image);
    if (image != null) {
      File file = File(image.path);
      setState(() {
        choosedImageFile = file;
      });
    }
  }

  Future takePhoto() async {
    PickedFile image = await _picker.getImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      File file = File(image.path);
      setState(() {
        choosedImageFile = file;
      });
    }
  }

  Future<void> uploadPhoto(
      User user, UserData userData) async {
    if (choosedImageFile != null) {
      try {
        StorageReference storageReference =
        FirebaseStorage.instance.ref().child("photos_profil").child(user.uid);

        StorageUploadTask uploadTask = storageReference.putFile(choosedImageFile);
        await uploadTask.onComplete;
        String link = await storageReference.getDownloadURL();
        if(isUser)
          UserDAO(user.uid).updateProfilPhoto(link);
        else
          DepartmentDAO(user.uid).updateProfilPhoto(link);
      } catch (e) {
        print("failed to upload");
        print(e);
      }
    }
  }

  checkUserType() async{
    final prefs = await SharedPreferences.getInstance();
    var tempIsUser = await prefs.getBool('isUser');
    setState(() {
      isUser = tempIsUser;
    });
    //isDepartment = await prefs.getBool('isDepartment');
  }
}
