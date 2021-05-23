import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unemindemaville/layouts/auth/chooseUserType.dart';
import 'package:unemindemaville/layouts/videofeed/apis/encoding_provider.dart';
import 'package:unemindemaville/layouts/videofeed/apis/firebase_provider.dart';
import 'package:unemindemaville/models/user.dart';
import 'package:unemindemaville/models/video_info.dart';
import 'package:unemindemaville/services/auth.dart';
import 'package:unemindemaville/services/databases/departmentDAO.dart';
import 'package:unemindemaville/services/databases/userDAO.dart';
import 'package:unemindemaville/shared/colors.dart';
import 'package:unemindemaville/shared/styles.dart';
import 'package:video_player/video_player.dart';

class CreateVideo extends StatefulWidget {
  CreateVideo({Key key}) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<CreateVideo> {
  final AuthService _authService = AuthService();
  final villeController = TextEditingController();
  final quartierController = TextEditingController();
  final descController = TextEditingController();
  bool loading = false;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  File choosedVideoFile;
  bool isUser = false;
  /*** sync **/
  final thumbWidth = 100;
  final thumbHeight = 150;
  bool _imagePickerActive = false;
  bool _processing = false;
  bool _canceled = false;
  double _progress = 0.0;
  int _videoDuration = 0;
  String _processPhase = '';

  @override
  void initState() {
    EncodingProvider.enableStatisticsCallback((int time,
        int size,
        double bitrate,
        double speed,
        int videoFrameNumber,
        double videoQuality,
        double videoFps) {
      if (_canceled) return;

      setState(() {
        _progress = time / _videoDuration;
      });
    });

    checkUserType();
    super.initState();
  } // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;

    if (choosedVideoFile != null) {
      _controller = VideoPlayerController.file(choosedVideoFile);
      // Initialize the controller and store the Future for later use.
      _initializeVideoPlayerFuture = _controller.initialize();
      // Use the controller to loop the video.
      _controller.setLooping(true);
      print(_initializeVideoPlayerFuture);
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            _processing ? "Envoi..." : "Publier",
            style: createAppBarTextStyle,
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
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  child: Text('Déconnexion'),
                  value: "0",
                ),
              ],
            ),
          ],
        ),
        body: Builder(
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of().
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: _processing
                  ? _getProgressBar()
                  : ListView(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Container(
                            margin: EdgeInsets.only(bottom: 20),
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/logo.jpg"),
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: inputColor,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: TextField(
                            controller: villeController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Ville",
                                labelStyle: TextStyle(color: appSecondColor)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: inputColor,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: TextField(
                            controller: quartierController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Quartier",
                                labelStyle: TextStyle(color: appSecondColor)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: inputColor,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: TextField(
                            controller: descController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Description",
                                labelStyle: TextStyle(color: appSecondColor)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: size.width * 0.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40),
                              color: appSecondColor,
                              onPressed: () {
                                if (villeController.text.isEmpty) {
                                  _showDialog("Ville non renseignée !",
                                      "Vous devez indiquer la ville d'où vous prenez la vidéo !");
                                } else if (quartierController.text.isEmpty) {
                                  _showDialog("Quartier non indiqué !",
                                      "Vous devez indiquer le quartier dans lequel la situation se déroule !");
                                } else if (descController.text.isEmpty) {
                                  _showDialog("Aucune description !",
                                      "Vous devez décrire ce que reporte la vidéo !");
                                } else {
                                  _takeVideo(user);
                                }
                              },
                              child: Icon(
                                Icons.video_call,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          },
        ));
  }

  _getProgressBar() {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(_processPhase),
          ),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }

  _deconnect() async {
    //remove this screen and come back
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new ChooseUserType()),
            (Route<dynamic> route) => false);
    await _authService.signOut();
  }

  Future getVideo() async {
    var villeController = this.villeController.text;
    var quartierController = this.quartierController.text;
    var descController = this.descController.text;
    var video = await ImagePicker().getVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 60));
    if (video != null) {
      File file = File(video?.path);
      setState(() {
        choosedVideoFile = file;
      });
    }
    this.villeController.text = villeController;
    this.quartierController.text = quartierController;
    this.descController.text = descController;
  }

  void _showDialog(titre, msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(titre),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _takeVideo(User user) async {
    var videoFile;
    if (_imagePickerActive) return;

    _imagePickerActive = true;
    videoFile = await ImagePicker().getVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 60));
    _imagePickerActive = false;

    if (videoFile == null) return;
    //}
    setState(() {
      _processing = true;
    });

    try {
      await _processVideo(videoFile, user);
    } catch (e) {
      print('${e.toString()}');
    } finally {
      setState(() {
        _processing = false;
        descController.text = "";
        villeController.text = "";
        quartierController.text = "";
        _showDialog("Vidéo enregistrée",
            isUser == true? "Dès qu'elle sera validée par nos modérateurs, les élus y auront accès":
            "Dès qu'elle sera validée par nos modérateurs, les autres utilisateurs y auront accès");
      });
    }
  }

  Future<void> _processVideo(PickedFile rawVideoFile, User user) async {
    final String rand = '${new Random().nextInt(10000)}';
    final videoName = 'video$rand';
    final Directory extDir = await getApplicationDocumentsDirectory();
    final outDirPath = '${extDir.path}/Videos/$videoName';
    final videosDir = new Directory(outDirPath);
    videosDir.createSync(recursive: true);

    final rawVideoPath = rawVideoFile.path;
    final info = await EncodingProvider.getMediaInformation(rawVideoPath);
    final aspectRatio = EncodingProvider.getAspectRatio(info);

    setState(() {
      _processPhase = 'Generation de l\'aperçu';
      _videoDuration = EncodingProvider.getDuration(info);
      _progress = 0.0;
    });

    final thumbFilePath =
        await EncodingProvider.getThumb(rawVideoPath, thumbWidth, thumbHeight);

    setState(() {
      _processPhase = 'Encodage de la vidéo';
      _progress = 0.0;
    });

    final encodedFilesDir =
        await EncodingProvider.encodeHLS(rawVideoPath, outDirPath);

    setState(() {
      _processPhase = 'Chargement de l\'aperçu vers le server';
      _progress = 0.0;
    });
    final thumbUrl = await _uploadFile(thumbFilePath, 'thumbnail');
    final videoUrl = await _uploadHLSFiles(encodedFilesDir, videoName);

    var userData;
    if (isUser == true)
      userData = await UserDAO(user.uid).getUserData();
    else
      userData = await DepartmentDAO(user.uid).getDepartmentData();
    final videoInfo = VideoInfo(
      uid: '',
      verified: false,
      isDepartment: isUser== true ? false : true,
      videoDescription: descController.text,
      videoCity: villeController.text,
      videoPostalCode: userData.postalCode,
      videoQuartier: quartierController.text,
      videoAuthor: userData.name,
      videoAuthorID: user.uid,
      videoUrl: videoUrl,
      thumbUrl: thumbUrl,
      coverUrl: thumbUrl,
      aspectRatio: aspectRatio,
      uploadedAt: DateTime.now().millisecondsSinceEpoch,
      videoName: videoName,
    );
    print("quartier: " + videoInfo.videoQuartier);

    setState(() {
      _processPhase = 'Enregistrement des données de la vidéo sur le cloud';
      _progress = 0.0;
    });

    await FirebaseProvider.saveVideo(videoInfo);

    setState(() {
      _processPhase = '';
      _progress = 0.0;
      _processing = false;
    });
  }

  Future<String> _uploadFile(filePath, folderName) async {
    final file = new File(filePath);
    final basename = p.basename(filePath);

    final StorageReference ref =
        FirebaseStorage.instance.ref().child(folderName).child(basename);
    StorageUploadTask uploadTask = ref.putFile(file);
    uploadTask.events.listen(_onUploadProgress);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String videoUrl = await taskSnapshot.ref.getDownloadURL();
    return videoUrl;
  }

  Future<String> _uploadHLSFiles(dirPath, videoName) async {
    final videosDir = Directory(dirPath);

    var playlistUrl = '';

    final files = videosDir.listSync();
    int i = 1;
    for (FileSystemEntity file in files) {
      final fileName = p.basename(file.path);
      final fileExtension = getFileExtension(fileName);
      if (fileExtension == 'm3u8') _updatePlaylistUrls(file, videoName);

      setState(() {
        _processPhase =
            'Chargement du fichier de vidéo n°$i sur ${files.length}';
        _progress = 0.0;
      });

      final downloadUrl = await _uploadFile(file.path, videoName);

      if (fileName == 'master.m3u8') {
        playlistUrl = downloadUrl;
      }
      i++;
    }

    return playlistUrl;
  }

  void _onUploadProgress(event) {
    if (event.type == StorageTaskEventType.progress) {
      final double progress =
          event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
      setState(() {
        _progress = progress;
      });
    }
  }

  String getFileExtension(String fileName) {
    final exploded = fileName.split('.');
    return exploded[exploded.length - 1];
  }

  void _updatePlaylistUrls(File file, String videoName) {
    final lines = file.readAsLinesSync();
    var updatedLines = List<String>();

    for (final String line in lines) {
      var updatedLine = line;
      if (line.contains('.ts') || line.contains('.m3u8')) {
        updatedLine = '$videoName%2F$line?alt=media';
      }
      updatedLines.add(updatedLine);
    }
    final updatedContents =
        updatedLines.reduce((value, element) => value + '\n' + element);

    file.writeAsStringSync(updatedContents);
  }

  checkUserType() async{
    final prefs = await SharedPreferences.getInstance();
    isUser = await prefs.getBool('isUser');
  }
}
