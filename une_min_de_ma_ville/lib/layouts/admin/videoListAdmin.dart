import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unemindemaville/layouts/videofeed/widgets/player.dart';
import 'package:unemindemaville/models/video_info.dart';
import 'package:unemindemaville/services/databases/videoDAO.dart';
import 'package:unemindemaville/shared/colors.dart';

class VideoListAdmin extends StatefulWidget {
  final List<VideoInfo> videos;
  VideoListAdmin({this.videos});
  @override
  State<VideoListAdmin> createState() => _VideoListAdminState();
}

class _VideoListAdminState extends State<VideoListAdmin> {
  @override
  Widget build(BuildContext context) {
    if (widget.videos.length == 0) {
      return Container(
        padding: EdgeInsets.all(60),
        child: Center(
          child: Text(
            "Il n'y a aucune vidéo à valider ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(top: 0),
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          return displayVideoContainer(widget.videos[index], index);
        },
      );
    }
  }

  Widget displayVideoContainer(VideoInfo video, int index) {
    return GestureDetector(
      onLongPress: () {
        _showValidationDialog(video);
      },
      child: Container(
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
          //borderOnForeground: borderOnForeground,
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: video.thumbUrl,
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: "btn" + index.toString(),
                      backgroundColor: Colors.white54,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Player(video: video);
                            },
                          ),
                        );
                      },
                      // Display the correct icon depending on the state of the player.
                      child: Icon(
                        Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: new EdgeInsets.only(left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                padding: EdgeInsets.only(right: 10),
                                child: Center(
                                    child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/user_profile.png'),
                                      fit: BoxFit.fitWidth,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.0)),
                                  ),
                                )),
                              ),
                              Text(
                                video.videoAuthor,
                                style: TextStyle(
                                    color: video.isDepartment == true
                                        ? appMainColor
                                        : appSecondColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                          child: Text(
                            video.videoCity,
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
                            video.videoDescription,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.black45,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateVideo(VideoInfo videoInfo) async {
    await VideoDAO(videoID: videoInfo.uid).validateVideo();
  }

  _suppressVideo(VideoInfo videoInfo) async {
    await VideoDAO(videoID: videoInfo.uid).suppressVideo();
  }

  _showValidationDialog(VideoInfo videoInfo) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('VALIDATION'),
          content: new Text("Voulez-vous valider cette vidéo ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Supprimer"),
              onPressed: () {
                _suppressVideo(videoInfo);
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Valider"),
              onPressed: () {
                _validateVideo(videoInfo);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
