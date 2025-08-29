import 'dart:io';

class ImageModel {
  final File file;
  final DateTime pickedAt;
  String? caption;

  ImageModel({
    required this.file,
    required this.pickedAt,
    this.caption,
  });

  Future<Map<String, dynamic>> toMap() async {
    final bytes = await file.readAsBytes();
    return {
      "pickedAt": pickedAt.toIso8601String(),
      "file": bytes,
      "caption": caption,
    };
  }
}