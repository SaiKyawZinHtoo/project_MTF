import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final ImagePicker _picker = ImagePicker();
  XFile? _frontNRCImage;
  XFile? _backNRCImage;
  bool _isLoading = false;

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    debugPrint("Local path: ${directory.path}");
    return directory.path;
  }

  Future<File> _saveImageLocally(XFile image, String fileName) async {
    final localPath = await _getLocalPath();
    final file = File('$localPath/$fileName');
    debugPrint("Saving image locally to: ${file.path}");
    return File(image.path).copy(file.path);
  }

  Future<void> _pickImage(ImageSource source, String side) async {
    setState(() {
      _isLoading = true;
      debugPrint("Loading started for $side side.");
    });

    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      debugPrint("Image selected: ${image.path}");

      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 50.0, ratioY: 30.0),
        compressQuality: 50,
        compressFormat: ImageCompressFormat.jpg,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (croppedFile != null) {
        debugPrint("Cropped image path: ${croppedFile.path}");
        debugPrint(
            "Cropped image size: ${File(croppedFile.path).lengthSync()} bytes");

        setState(() {
          if (side == 'Front') {
            _frontNRCImage = XFile(croppedFile.path);
            debugPrint("Front NRC image updated.");
          } else {
            _backNRCImage = XFile(croppedFile.path);
            debugPrint("Back NRC image updated.");
          }
          _isLoading = false;
        });
      } else {
        debugPrint("Image cropping canceled for $side side.");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      debugPrint("No image selected for $side side.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget buildImageUploadSection(String title, String side, XFile? imageFile) {
    debugPrint("Building upload section for: $title");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera, side),
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery, side),
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      label: const Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                if (imageFile != null) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imageFile.path),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building Page3 UI.");
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImageUploadSection(
              'Upload NRC Front Side:', 'Front', _frontNRCImage),
          buildImageUploadSection(
              'Upload NRC Back Side:', 'Back', _backNRCImage),
        ],
      ),
    );
  }
}
