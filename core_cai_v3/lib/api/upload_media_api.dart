import 'dart:typed_data';

abstract class UploadMediaApi {
  Future<String> uploadImage(
    Uint8List bytes,
    String fileType,
    String extension,
  );

  Future<String> uploadFile(
      Uint8List bytes, String fileType, String extension,
      {String? fileName});

  Future<Uint8List> getVideoTumbnail(String videoUrl);
}
