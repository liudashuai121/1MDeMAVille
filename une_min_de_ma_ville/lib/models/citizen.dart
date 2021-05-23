class Citizen{
  String uid;
  int videosPublished;
  int videosBeingVerified;
  Citizen({this.uid, this.videosPublished, this.videosBeingVerified});
  Citizen.light({this.videosPublished, this.videosBeingVerified});
}