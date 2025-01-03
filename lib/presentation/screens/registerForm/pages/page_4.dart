import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CertificationDetailsPage extends StatefulWidget {
  @override
  _CertificationDetailsPageState createState() =>
      _CertificationDetailsPageState();
}

class _CertificationDetailsPageState extends State<CertificationDetailsPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _myanmarImageFile;
  XFile? _kukkiwonImageFile;
  bool _isLoading = false;
  // Add state variables for issue date and controllers
  DateTime? _myanmarIssueDate;
  DateTime? _kukkiwonIssueDate;
  final TextEditingController _myanmarDateController = TextEditingController();
  final TextEditingController _kukkiwonDateController = TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers to free resources
    _myanmarDateController.dispose();
    _kukkiwonDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, String section) async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 50.0, ratioY: 30.0),
        compressQuality: 80, // Reduce quality
        compressFormat: ImageCompressFormat.jpg,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (croppedFile != null) {
        debugPrint("Cropped image path: ${croppedFile.path}");
        debugPrint(
            "Cropped image size: ${File(croppedFile.path).lengthSync()} bytes");

        setState(() {
          if (section == 'Myanmar') {
            _myanmarImageFile = XFile(croppedFile.path);
          } else if (section == 'Kukkiwon') {
            _kukkiwonImageFile = XFile(croppedFile.path);
          }
          _isLoading = false; // Set loading state to false
        });
      } else {
        debugPrint("Image cropping canceled.");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      debugPrint("No image selected.");
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  Widget buildCertificationCard(
    String title,
    List<String> ranks,
    String section,
    XFile? imageFile,
  ) {
    debugPrint('Building Certification Card for $section');
    DateTime? issueDate =
        section == 'Myanmar' ? _myanmarIssueDate : _kukkiwonIssueDate;
    TextEditingController dateController =
        section == 'Myanmar' ? _myanmarDateController : _kukkiwonDateController;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              items: ranks
                  .map((rank) =>
                      DropdownMenuItem(value: rank, child: Text(rank)))
                  .toList(),
              onChanged: (value) {
                debugPrint('Selected Rank for $section: $value');
                // Handle selection change
              },
              decoration: InputDecoration(
                labelText: 'Certification Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Issue Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                debugPrint('Issue Number for $section: $value');
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Issue Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: issueDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  debugPrint('Selected Date for $section: $selectedDate');
                  setState(() {
                    if (section == 'Myanmar') {
                      _myanmarIssueDate = selectedDate;
                      _myanmarDateController.text =
                          '${selectedDate.day}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}';
                    } else if (section == 'Kukkiwon') {
                      _kukkiwonIssueDate = selectedDate;
                      _kukkiwonDateController.text =
                          '${selectedDate.day}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}';
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Certification:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera, section),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery, section),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            if (imageFile != null) ...[
              //debugPrint('Displaying image for $section: ${imageFile.path}'),
              const SizedBox(height: 16),
              const Text(
                'Selected Image:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imageFile.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCertificationCard(
              'Myanmar Ranks',
              [
                'Select Dan',
                '1st Dan',
                '2nd Dan',
                '3rd Dan',
                '4th Dan',
                '5th Dan',
                '6th Dan',
                '7th Dan',
                '8th Dan',
                '9th Dan',
              ],
              'Myanmar',
              _myanmarImageFile,
            ),
            const SizedBox(height: 16),
            buildCertificationCard(
              'Kukkiwon Ranks',
              [
                'Select Dan',
                '1st Dan',
                '2nd Dan',
                '3rd Dan',
                '4th Dan',
                '5th Dan',
                '6th Dan',
                '7th Dan',
                '8th Dan',
                '9th Dan',
              ],
              'Kukkiwon',
              _kukkiwonImageFile,
            ),
          ],
        ),
      ),
    );
  }
}
