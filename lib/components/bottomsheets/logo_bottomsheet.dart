import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LogoPickerBottomSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  const LogoPickerBottomSheet({
    Key? key,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Select Logo Image',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.blue),
            title: Text('Take Photo'),
            onTap: () => _pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: Colors.green),
            title: Text('Choose from Gallery'),
            onTap: () => _pickImage(ImageSource.gallery),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      // Try picking the image with specific format handling
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
        requestFullMetadata: false, // This helps with iOS issues
      );

      if (pickedFile != null) {
        print("Original picked file path: ${pickedFile.path}");

        // Check if file exists and has content
        final File originalFile = File(pickedFile.path);
        if (!await originalFile.exists()) {
          throw Exception("Selected file does not exist");
        }

        final int originalFileSize = await originalFile.length();
        if (originalFileSize == 0) {
          throw Exception("Selected file is empty");
        }

        print("Original file size: $originalFileSize bytes");

        // Create permanent location
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String fileName = 'logo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String newPath = path.join(appDocDir.path, fileName);

        // Copy file with error handling
        final File permanentFile = await originalFile.copy(newPath);
        print("Copied to permanent location: ${permanentFile.path}");

        // Verify the copied file
        if (await permanentFile.exists()) {
          final fileSize = await permanentFile.length();
          print("Permanent file size: $fileSize bytes");

          if (fileSize > 0) {
            onImageSelected(permanentFile);
          } else {
            throw Exception("Copied file is empty");
          }
        } else {
          throw Exception("Failed to copy file to permanent location");
        }
      }
    } on PlatformException catch (e) {
      print("PlatformException: ${e.code} - ${e.message}");
      if (e.code == 'invalid_image') {
        // Retry with different parameters
        await _retryImagePick(source);
      } else {
        _showErrorDialog("Failed to pick image: ${e.message}");
      }
    } catch (e) {
      print("Error picking image: $e");
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _retryImagePick(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      // Retry with minimal parameters
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 100, // Try with full quality
      );

      if (pickedFile != null) {
        print("Retry - Original picked file path: ${pickedFile.path}");

        final File originalFile = File(pickedFile.path);
        if (await originalFile.exists() && await originalFile.length() > 0) {
          final Directory appDocDir = await getApplicationDocumentsDirectory();
          final String fileName = 'logo_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final String newPath = path.join(appDocDir.path, fileName);

          final File permanentFile = await originalFile.copy(newPath);

          if (await permanentFile.exists() && await permanentFile.length() > 0) {
            onImageSelected(permanentFile);
          } else {
            throw Exception("Retry failed - file copy unsuccessful");
          }
        } else {
          throw Exception("Retry failed - original file invalid");
        }
      }
    } catch (e) {
      print("Retry failed: $e");
      _showErrorDialog("Failed to select image. Please try again.");
    }
  }

  void _showErrorDialog(String error) {
    print("Image picker error: $error");
  }
}