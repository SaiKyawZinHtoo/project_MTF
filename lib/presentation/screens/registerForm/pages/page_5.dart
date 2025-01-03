import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool _isLoading = false;

  // Lists to hold the selected images
  List<File> localCourseImages = [];
  List<File> internationalCourseImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blueAccent,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Local Course'),
                Tab(text: 'International Course'),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  CourseTab(
                    courseType: 'local',
                    selectedImages: localCourseImages,
                    onPickImage: (source, type) => _pickImage(source, type),
                  ),
                  CourseTab(
                    courseType: 'international',
                    selectedImages: internationalCourseImages,
                    onPickImage: (source, type) => _pickImage(source, type),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to pick and process images
  Future<void> _pickImage(ImageSource source, String courseType) async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    debugPrint('Opening image picker for $courseType course');
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      debugPrint('Image selected: ${image.path}');

      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 50.0, ratioY: 30.0),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (croppedFile != null) {
        debugPrint("Cropped image path: ${croppedFile.path}");
        debugPrint(
            "Cropped image size: ${File(croppedFile.path).lengthSync()} bytes");

        // Compress the image
        final img.Image? imageFile =
            img.decodeImage(File(croppedFile.path).readAsBytesSync());

        if (imageFile != null) {
          final compressedImage = File(croppedFile.path)
            ..writeAsBytesSync(
              img.encodeJpg(imageFile,
                  quality: 80), // Compress with reduced quality
            );

          debugPrint("Compressed image path: ${compressedImage.path}");
          debugPrint(
              "Compressed image size: ${compressedImage.lengthSync()} bytes");

          setState(() {
            if (courseType == 'local') {
              localCourseImages.add(compressedImage);
            } else {
              internationalCourseImages.add(compressedImage);
            }
            _isLoading = false; // Set loading state to false
          });
        } else {
          debugPrint('Failed to decode and compress the image.');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        debugPrint('Image cropping cancelled.');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      debugPrint('No image selected.');
      setState(() {
        _isLoading = false;
      });
    }
  }
}

// Reusable CourseTab widget
class CourseTab extends StatelessWidget {
  final String courseType;
  final List<File> selectedImages;
  final Function(ImageSource, String) onPickImage;

  const CourseTab({
    Key? key,
    required this.courseType,
    required this.selectedImages,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Course Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              debugPrint('Course Name entered: $value');
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Course Level',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              debugPrint('Course Level entered: $value');
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Upload Certification:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  debugPrint('Camera button clicked for $courseType course');
                  onPickImage(ImageSource.camera, courseType);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  debugPrint('Gallery button clicked for $courseType course');
                  onPickImage(ImageSource.gallery, courseType);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (selectedImages.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Certifications:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  width: 400, // Fixed width
                  height: 200, // Fixed height
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Optional: background color
                    border: Border.all(
                        color: Colors.blueAccent), // Optional: border style
                    borderRadius:
                        BorderRadius.circular(8), // Optional: rounded corners
                  ),
                  child: selectedImages.isNotEmpty
                      ? ListView.builder(
                          scrollDirection:
                              Axis.horizontal, // Allow horizontal scrolling
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  selectedImages[index],
                                  // width: 150, // Image width inside container
                                  // height: 150, // Image height
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No images uploaded yet.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                ),
              ],
            )
          else
            const Text(
              'No certifications uploaded yet.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
