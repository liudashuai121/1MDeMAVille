import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unemindemaville/models/video_info.dart';

class FirebaseProvider {
  static saveVideo(VideoInfo video) async {
    await Firestore.instance.collection('videos').document().setData({
      'verified': video.verified,
      'isDepartment': video.isDepartment,
      'videoDescription': video.videoDescription,
      'videoCity': video.videoCity,
      'videoPostalCode': video.videoPostalCode,
      'videoQuartier': video.videoQuartier,
      'videoAuthor': video.videoAuthor,
      'videoAuthorID': video.videoAuthorID,
      'videoUrl': video.videoUrl,
      'thumbUrl': video.thumbUrl,
      'coverUrl': video.coverUrl,
      'aspectRatio': video.aspectRatio,
      'uploadedAt': video.uploadedAt,
      'videoName': video.videoName,
    });
  }

  static listenToValidatedVideos(callback) async {
    Firestore.instance
        .collection('videos')
        .where('verified', isEqualTo: true)
        .orderBy("uploadedAt", descending: true)
        .snapshots()
        .listen((qs) {
      final videos = mapQueryToVideoInfo(qs);
      callback(videos);
    });
  }

  static listenToUnvalidatedVideos(callback) async {
    Firestore.instance
        .collection('videos')
        .where('verified', isEqualTo: false)
        .orderBy("uploadedAt", descending: true)
        .snapshots()
        .listen((qs) {
      final videos = mapQueryToVideoInfo(qs);
      callback(videos);
    });
  }

  static listenToPersonalValidatedVideos(callback, userID) async {
    Firestore.instance
        .collection('videos')
        .where('verified', isEqualTo: true)
        .where('videoAuthorID', isEqualTo: userID)
        .orderBy("uploadedAt", descending: true)
        .snapshots()
        .listen((qs) {
      final videos = mapQueryToVideoInfo(qs);
      callback(videos);
    });
  }

  static listenToPersonalUnvalidatedVideos(callback, userID) async {
    Firestore.instance
        .collection('videos')
        .where('verified', isEqualTo: false)
        .where('videoAuthorID', isEqualTo: userID)
        .orderBy("uploadedAt", descending: true)
        .snapshots()
        .listen((qs) {
      final videos = mapQueryToVideoInfo(qs);
      callback(videos);
    });
  }

  static mapQueryToVideoInfo(QuerySnapshot qs) {
    return qs.documents.map((DocumentSnapshot ds) {
      List<String> likes = [];
      if(ds.data['likes']!= null)
        ds.data['likes'].forEach((doc) => likes.add(doc));
      return VideoInfo(
        uid: ds.documentID,
        verified: ds.data['verified'],
        isDepartment: ds.data['isDepartment'],
        videoDescription: ds.data['videoDescription'],
        videoCity: ds.data['videoCity'],
        videoPostalCode: ds.data['videoPostalCode'],
        videoQuartier: ds.data['videoQuartier'],
        videoAuthor: ds.data['videoAuthor'],
        videoAuthorID: ds.data['videoAuthorID'],
        videoUrl: ds.data['videoUrl'],
        thumbUrl: ds.data['thumbUrl'],
        coverUrl: ds.data['coverUrl'],
        aspectRatio: ds.data['aspectRatio'],
        videoName: ds.data['videoName'],
        uploadedAt: ds.data['uploadedAt'],
        likes: likes,
      );
    }).toList();
  }
}
