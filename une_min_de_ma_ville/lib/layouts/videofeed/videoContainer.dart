import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unemindemaville/layouts/videofeed/widgets/player.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/models/video_info.dart';
import 'package:unemindemaville/services/databases/videoDAO.dart';
import 'package:unemindemaville/shared/colors.dart';

class VideoContainer extends StatefulWidget {
  final VideoInfo video;
  final int index;
  bool isLiked;
  VideoContainer({this.video, this.index, this.isLiked});
  @override
  State<VideoContainer> createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  bool like = false;

  @override
  void initState() {
    like = widget.isLiked;
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);
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
                      image: widget.video.thumbUrl,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: "btn" + widget.index.toString(),
                    backgroundColor: Colors.white54,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Player(video: widget.video);
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                ),
                              )),
                            ),
                            Text(
                              widget.video.videoAuthor,
                              style: TextStyle(
                                  color: widget.video.isDepartment == true
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
                          widget.video.videoCity,
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
                          widget.video.videoDescription,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child: GestureDetector(
                          onTap: () async {
                            if (like) {
                              await VideoDAO(videoID: widget.video.uid)
                                  .removeLike(user.uid);
                            }
                            else
                              await VideoDAO(videoID: widget.video.uid)
                                  .addLike(user.uid);
                            setState(() {
                              like = !like;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              like == true
                                ? Icon(
                              Icons.favorite,
                              color: appMainColor,
                            )
                                : Icon(Icons.favorite_border),
                            SizedBox(width: 10),
                            Text(widget.video.likes.length.toString())
                          ],),
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
    );
  }
}
