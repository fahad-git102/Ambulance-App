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
}