import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unemindemaville/layouts/auth/chooseUserType.dart';
import 'package:unemindemaville/layouts/videofeed/apis/firebase_provider.dart';
import 'package:unemindemaville/layouts/videofeed/videoContainer.dart';
import 'package:unemindemaville/layouts/videofeed/videoList.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/models/video_info.dart';
import 'package:unemindemaville/services/auth.dart';
import 'package:unemindemaville/services/databases/videoDAO.dart';
import 'package:unemindemaville/shared/colors.dart';
import 'package:unemindemaville/shared/loader.dart';
import 'package:unemindemaville/shared/styles.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);
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
            child: StreamBuilder<List<VideoInfo>>(
                stream: VideoDAO().getValidatedVideos(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(child: Text("Désolé, il y a eu une erreur !"),);
                  }
                  else if (snapshot.hasData) {
                    List<VideoInfo> _videos = <VideoInfo>[];
                    _videos = snapshot.data;
                    return VideoList(
                      videos: _videos,
                    );
                  } else {
                    return Loader();
                  }
                })
            ));
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
