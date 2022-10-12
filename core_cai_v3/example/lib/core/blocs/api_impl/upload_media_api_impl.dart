import 'dart:convert';
import 'dart:typed_data';

// import 'package:firebase/firebase.dart' as fb;
import 'package:core_cai_v3/api/upload_media_api.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class UploadMediaApiImpl extends UploadMediaApi {
  @override
  Future<String> uploadFile(Uint8List bytes, String fileType, String extension,
      {String? fileName}) async {
    String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    String newFileName = dateTime + "." + extension;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('taskFiles/$dateTime/$fileName');
    print('1');
    firebase_storage.UploadTask task = ref.putData(bytes);
    print('2');
    String downloadUrl =
        await (await task.whenComplete(() => null)).ref.getDownloadURL();
    print('3');
    return downloadUrl;
  }

  @override
  Future<String> uploadImage(
      Uint8List bytes, String fileType, String extension) async {
    String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    String newFileName = dateTime + "." + extension;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('taskImages/$newFileName');
    print('1');
    firebase_storage.UploadTask task = ref.putData(bytes);
    print('2');
    String downloadUrl =
        await (await task.whenComplete(() => null)).ref.getDownloadURL();
    print('3');

    print('downloadUrl $downloadUrl');
    return downloadUrl;
  }

  @override
  Future<Uint8List> getVideoTumbnail(String videoUrl) async {
    String input = '{"videoUrl" : "$videoUrl"}';
    String url =
        "https://video-thumbnail-generator-pub.herokuapp.com/generate/thumbnail";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: input,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        return base64Decode(data);
      } else {
        throw 'Could not fetch data from api | Error Code: ${response.statusCode}';
      }
    } on Exception catch (e) {
      throw "Error : $e";
    }
  }
}
