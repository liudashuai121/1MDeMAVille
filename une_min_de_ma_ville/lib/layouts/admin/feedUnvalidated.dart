import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unemindemaville/layouts/admin/videoListAdmin.dart';
import 'package:unemindemaville/layouts/auth/chooseUserType.dart';
import 'package:unemindemaville/layouts/videofeed/apis/firebase_provider.dart';
import 'package:unemindemaville/layouts/videofeed/videoList.dart';
import 'package:unemindemaville/models/video_info.dart';
import 'package:unemindemaville/services/auth.dart';
import 'package:unemindemaville/shared/colors.dart';
import 'package:unemindemaville/shared/styles.dart';

class FeedUnvalidated extends StatefulWidget {
  FeedUnvalidated({Key key}) : super(key: key);

  @override
  _FeedUnvalidatedState createState() => _FeedUnvalidatedState();
}

class _FeedUnvalidatedState extends State<FeedUnvalidated> {
  final AuthService _authService = AuthService();
  List<VideoInfo> _videos = <VideoInfo>[];

  @override
  void initState() {
    FirebaseProvider.listenToUnvalidatedVideos((newVideos) {
      setState(() {
        _videos = newVideos;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: appThirdColor,
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
          title: Container(
            child: Text(
              '1 min 2 ma ville',
              style: accountAppBarTextStyle,
            ),
          ),
        ),
        body: Center(
            child: _videos.length == 0 ? Text("Aucune vidéo à valider "): VideoListAdmin(
          videos: _videos,
        )));
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
