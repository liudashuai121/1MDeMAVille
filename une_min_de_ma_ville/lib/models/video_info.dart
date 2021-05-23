class VideoInfo {
  String uid;
  String videoUrl;
  String thumbUrl;
  String coverUrl;
  double aspectRatio;
  int uploadedAt;
  String videoName;
  bool verified;
  bool isDepartment;
  String videoDescription;
  String videoCity;
  int videoPostalCode;
  String videoQuartier;
  String videoAuthor;
  String videoAuthorID;
  List<String> likes = [];

  VideoInfo({
        this.uid,
        this.videoUrl,
        this.thumbUrl,
        this.coverUrl,
        this.aspectRatio,
        this.uploadedAt,
        this.videoName,
        this.verified,
        this.isDepartment,
        this.videoDescription,
        this.videoCity,
        this.videoPostalCode,
        this.videoQuartier,
        this.videoAuthor,
        this.videoAuthorID,
        this.likes
      });
}
