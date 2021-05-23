import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:unemindemaville/layouts/videofeed/videoContainer.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/models/video_info.dart';

class VideoList extends StatefulWidget {
  final List<VideoInfo> videos;
  VideoList({this.videos});
  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);
    if (widget.videos.length == 0) {
      return Container(
        padding: EdgeInsets.all(60),
        child: Center(
          child: Text(
            "Il n'y a aucune vidéo disponible actuellement ",
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
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
        var isLiked = widget.videos[index].likes.contains(user.uid);
        return VideoContainer(video: widget.videos[index], index: index, isLiked: isLiked);
      });
    }
  }
}
