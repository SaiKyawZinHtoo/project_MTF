// import 'package:flutter/material.dart';

// Widget buildPage2(BuildContext context) {
//   String getOrdinal(int number) {
//     if (number >= 11 && number <= 13) {
//       return '${number}th';
//     }
//     switch (number % 10) {
//       case 1:
//         return '${number}st';
//       case 2:
//         return '${number}nd';
//       case 3:
//         return '${number}rd';
//       default:
//         return '${number}th';
//     }
//   }

//   final TextEditingController _taekwondoDateController =
//       TextEditingController();
//   final TextEditingController _coachDutyDateController =
//       TextEditingController();

//   return Scaffold(
//     body: Padding(
//       padding: const EdgeInsets.all(16),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             // Coach Rank Dropdown
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 labelText: 'Coach Rank',
//                 border: OutlineInputBorder(),
//               ),
//               items: List.generate(3, (index) {
//                 String ordinal = getOrdinal(index + 1);
//                 return DropdownMenuItem<String>(
//                   value: '$ordinal rank',
//                   child: Text('$ordinal rank'),
//                 );
//               }),
//               onChanged: (value) {
//                 // Handle rank selection
//                 debugPrint('Selected coach rank: $value');
//               },
//             ),
//             const SizedBox(height: 16),

//             // Team Name
//             _buildTextField(label: 'Team Name'),

//             // Start Date of Playing Taekwondo
//             _buildDatePickerField(
//               context: context,
//               label: 'Start Date of Playing Taekwondo',
//               controller: _taekwondoDateController,
//             ),

//             // Start Date of Coach Duty
//             _buildDatePickerField(
//               context: context,
//               label: 'Start Date of Coach Duty',
//               controller: _coachDutyDateController,
//             ),

//             // Address
//             _buildTextField(label: 'Address'),

//             // Email
//             _buildTextField(
//               label: 'Email',
//               keyboardType: TextInputType.emailAddress,
//             ),

//             // Phone
//             _buildTextField(
//               label: 'Phone',
//               keyboardType: TextInputType.phone,
//             ),

//             // Education
//             _buildTextField(label: 'Education'),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// // Reusable TextField Widget
// Widget _buildTextField({
//   required String label,
//   TextEditingController? controller,
//   TextInputType keyboardType = TextInputType.text,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         keyboardType: keyboardType,
//         onChanged: (value) {
//           debugPrint('TextField $label changed: $value');
//         },
//       ),
//       const SizedBox(height: 16),
//     ],
//   );
// }

// // Reusable DatePicker Field Widget
// Widget _buildDatePickerField({
//   required BuildContext context,
//   required String label,
//   required TextEditingController controller,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         readOnly: true,
//         onTap: () async {
//           DateTime? selectedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(1900),
//             lastDate: DateTime.now(),
//           );
//           if (selectedDate != null) {
//             controller.text =
//                 "${selectedDate.day}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}";
//             debugPrint(
//                 'Selected date for $label: ${controller.text}'); // Debug output
//           }
//         },
//       ),
//       const SizedBox(height: 16),
//     ],
//   );
// }
