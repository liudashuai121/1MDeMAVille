import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unemindemaville/models/video_info.dart';

class VideoDAO {
  String videoID;
  VideoDAO({this.videoID});

  final CollectionReference videoCollection =
      Firestore.instance.collection("videos");

  Future<String> uploadFile(
      String postalCode, String videoID, File videoFile) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('videos/$postalCode/$videoID');
    StorageUploadTask uploadTask = storageReference.putFile(videoFile);
    await uploadTask.onComplete;
    String link;
    await storageReference.getDownloadURL().then((fileURL) {
      link = fileURL;
    });
    return link;
  }

  Future validateVideo() async {
    try {
      await videoCollection
          .document(videoID)
          .updateData({'verified': true});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future suppressVideo() async {
    try {
      await videoCollection
          .document(videoID)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<List<VideoInfo>> getPersonalUnvalidatedVideos(userID) {
    Stream<List<VideoInfo>> list = videoCollection
        .where('verified', isEqualTo: true)
        .where('auteurID', isEqualTo: userID)
        .orderBy("uploadedAt", descending: true)
        .snapshots()
        .map(_videosFromSnapshots);
    return list;
  }

  Stream<List<VideoInfo>> getPersonalValidatedVideos(userID) {
    Stream<List<VideoInfo>> list = videoCollection
        .where('verified', isEqualTo: false)
        .where('auteurID', isEqualTo: userID)
        .orderBy("uploadedAt", descending: true)
        .snapshots()
        .map(_videosFromSnapshots);
    return list;
  }

  Stream<List<VideoInfo>> getValidatedVideos() {
    Stream<List<VideoInfo>> list = videoCollection
        .where('verified', isEqualTo: true)
        .orderBy("uploadedAt", descending: true)
        .snapshots()
        .map(_videosFromSnapshots);
    return list;
  }

  Future<List<VideoInfo>> getVideos() async {
    QuerySnapshot videos = await videoCollection
        .where('verified', isEqualTo: true)
        .orderBy("dateCreation", descending: true)
        .getDocuments();
    return _videosFromSnapshots(videos);
  }

  List<VideoInfo> _videosFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.documents.map((ds) {
      List<String> likes = [];/*
      ds.reference
          .collection("likes")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((doc) => likes.add(doc.documentID));
      });*/
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

  Future<VideoInfo> getVideoData() async {
    DocumentSnapshot ds = await videoCollection.document(videoID).get();
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
  }

  Future addLike(String userID) async {
    var val=[];   //blank list for add elements which you want to delete
    val.add(userID);
    return videoCollection.document(videoID).updateData({
      "likes":FieldValue.arrayUnion(val) });
  }

  Future removeLike(String userID) async {
    var val=[];   //blank list for add elements which you want to delete
    val.add(userID);
    return videoCollection.document(videoID).updateData({
      "likes":FieldValue.arrayRemove(val) });
  }
}
