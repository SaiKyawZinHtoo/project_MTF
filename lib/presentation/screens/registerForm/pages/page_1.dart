import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _nrcNumberController = TextEditingController();
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  List<Map<String, String>> nrcData = [];
  List<Map<String, String>> filteredNrcData = [];

  // Declare and initialize nrcCodes
  final List<String> nrcCodes =
      List<String>.generate(14, (index) => (index + 1).toString());

  String? selectedNrcCode;
  String? selectedNrcName;
  String? selectedNrcRegion;
  String formattedNrc = '';
  bool _isLoading = false;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _loadNrcData() async {
    try {
      final String response =
          await DefaultAssetBundle.of(context).loadString('assets/nrc.json');
      final data = json.decode(response);

      setState(() {
        nrcData = List<Map<String, String>>.from(
          data['data'].map((item) => {
                "id": item['id']?.toString() ?? '',
                "name_en": item['name_en']?.toString() ?? '',
                "name_mm": item['name_mm']?.toString() ?? '',
                "nrc_code": item['nrc_code']?.toString() ?? '',
                "region": item['region']?.toString() ?? '',
                "type": item['type']?.toString() ?? '',
                "township": item['township']?.toString() ?? '',
              }),
        );
        filteredNrcData = nrcData;
        print("NRC Data loaded successfully."); // Debug print
      });
    } catch (e) {
      print("Error loading NRC data: $e"); // Debug print
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 50.0, ratioY: 30.0),
        compressQuality: 100, // Initial quality before compression
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
            _profileImage = compressedImage; // Set the compressed image
            _isLoading = false; // Set loading state to false
          });
        }
      } else {
        setState(() {
          _isLoading =
              false; // Set loading state to false if cropping is cancelled
        });
      }
    } else {
      setState(() {
        _isLoading =
            false; // Set loading state to false if no image is selected
      });
    }
  }

  Future<void> _captureImageWithCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      debugPrint("Image captured from camera: ${image.path}"); // Debug print
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Format date as dd-MM-yy for both storage and display
        String formattedDate =
            "${picked.day}-${picked.month.toString().padLeft(2, '0')}-${picked.year.toString().padLeft(2, '0')}";

        // Update the controller text with the formatted date
        _dateOfBirthController.text = formattedDate;

        debugPrint(
            "Date selected and formatted: $formattedDate"); // Debug print
      });
    }
  }

  void _updateFormattedNrc() {
    setState(() {
      // Construct the NRC number
      formattedNrc =
          '${selectedNrcCode ?? ''}/${selectedNrcName ?? ''}(${selectedNrcRegion ?? ''})${_nrcNumberController.text}';
      print("Formatted NRC: $formattedNrc"); // Debug print
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNrcData();

    _NameController.addListener(() {
      debugPrint("Name changed: ${_NameController.text}"); // Debug print
    });

    _fatherNameController.addListener(() {
      debugPrint(
          "Father's Name changed: ${_fatherNameController.text}"); // Debug print
    });

    _nrcNumberController.addListener(_updateFormattedNrc);
  }

  @override
  void dispose() {
    _nrcNumberController.dispose();
    _NameController.dispose();
    _fatherNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  final TextEditingController _taekwondoDateController =
      TextEditingController();
  final TextEditingController _coachDutyDateController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Container (Square)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Coach License Form",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 400,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : (_profileImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.photo_library,
                                    size: 60,
                                    color: Colors.grey,
                                  )),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: _captureImageWithCamera,
                              color: Colors.blueAccent,
                            ),
                            IconButton(
                              icon: const Icon(Icons.image),
                              onPressed: () async {
                                await _pickImage();
                              },
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Other Input Fields
            _buildInputField('အမည်', 'Name', _NameController),
            const SizedBox(height: 16),
            _buildInputField(
                'ဖခင်အမည်', 'Father\'s Name', _fatherNameController),
            const SizedBox(height: 16),
            _buildDatePicker(context),
            const SizedBox(height: 16),
            _buildDropdown(
                'ပြည်နယ်/တိုင်း', 'Select NRC Code', nrcCodes, selectedNrcCode,
                (value) {
              setState(() {
                selectedNrcCode = value;
                filteredNrcData =
                    nrcData.where((nrc) => nrc['nrc_code'] == value).toList();
                _updateFormattedNrc(); // Update formatted NRC
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown(
                'မြို့နယ်',
                'Select NRC Name',
                filteredNrcData
                    .map((nrc) => nrc['name_en'] ?? '')
                    .toSet()
                    .toList(), // Unique items
                selectedNrcName, (value) {
              setState(() {
                selectedNrcName = value;
                _updateFormattedNrc(); // Update formatted NRC
              });
            }),
            const SizedBox(height: 16),
            _buildDropdown(
                'အမျိုးအစား', 'Select NRC Region', ['N'], selectedNrcRegion,
                (value) {
              setState(() {
                selectedNrcRegion = value;
                _updateFormattedNrc(); // Update formatted NRC
              });
            }),
            const SizedBox(height: 16),
            // NRC Number input field
            _buildInputField(
              'NRC Number',
              'Enter NRC Number',
              _nrcNumberController,
              keyboardType:
                  TextInputType.number, // Set keyboard type to numeric
              maxLength: 6, // Limit input to 6 digits
            ),

            // const SizedBox(height: 16),
            // Display NRC Number
            // Text(
            //   'Formatted NRC: $formattedNrc',
            //   style: const TextStyle(fontSize: 16),
            // ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Coach Rank',
                border: OutlineInputBorder(),
              ),
              items: List.generate(3, (index) {
                String ordinal = getOrdinal(index + 1);
                return DropdownMenuItem<String>(
                  value: '$ordinal rank',
                  child: Text('$ordinal rank'),
                );
              }),
              onChanged: (value) {
                // Handle rank selection
                debugPrint('Selected coach rank: $value');
              },
            ),
            const SizedBox(height: 16),

            // Team Name
            _buildTextField(label: 'Team Name'),

            // Start Date of Playing Taekwondo
            _buildDatePickerField(
              context: context,
              label: 'Start Date of Playing Taekwondo',
              controller: _taekwondoDateController,
            ),

            // Start Date of Coach Duty
            _buildDatePickerField(
              context: context,
              label: 'Start Date of Coach Duty',
              controller: _coachDutyDateController,
            ),

            // Address
            _buildTextField(label: 'Address'),

            // Email
            _buildTextField(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),

            // Phone
            _buildTextField(
              label: 'Phone',
              keyboardType: TextInputType.phone,
            ),

            // Education
            _buildTextField(label: 'Education'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hintText,
    TextEditingController controller, {
    TextInputType keyboardType =
        TextInputType.text, // Default to text if not specified
    int? maxLength, // Optional maxLength parameter
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType, // Set keyboard type to numeric if specified
      maxLength: maxLength, // Limit input to the specified max length
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextField(
      controller: _dateOfBirthController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        hintText: 'Select Date of Birth',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String hintText, List<String> items,
      String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

String getOrdinal(int number) {
  if (number >= 11 && number <= 13) {
    return '${number}th';
  }
  switch (number % 10) {
    case 1:
      return '${number}st';
    case 2:
      return '${number}nd';
    case 3:
      return '${number}rd';
    default:
      return '${number}th';
  }
}

// Reusable TextField Widget
Widget _buildTextField({
  required String label,
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        onChanged: (value) {
          debugPrint('TextField $label changed: $value');
        },
      ),
      const SizedBox(height: 16),
    ],
  );
}

// Reusable DatePicker Field Widget
Widget _buildDatePickerField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            controller.text =
                "${selectedDate.day}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}";
            debugPrint(
                'Selected date for $label: ${controller.text}'); // Debug output
          }
        },
      ),
      const SizedBox(height: 16),
    ],
  );
}
