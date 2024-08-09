// import 'dart:convert';
// import 'dart:io';

// import 'package:car_wash/common/utils/constants.dart';
// import 'package:car_wash/features/customer/customer.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class EditCustomerPage extends StatefulWidget {
//   final String customer_id;

//   EditCustomerPage({required this.customer_id});

//   @override
//   _EditCustomerPageState createState() => _EditCustomerPageState();
// }

// class _EditCustomerPageState extends State<EditCustomerPage> {
//   late TextEditingController customerController;
//   late TextEditingController mobileController;
//   List<TextEditingController> carModelNameControllers = [];
//   List<TextEditingController> carNoControllers = [];
//   List<TextEditingController> carLatControllers = [];
//   List<TextEditingController> carLongControllers = [];
//   List<TextEditingController> carPhotosController = [];
//   List<String> existingCarIds = [];
//   List<File?> imageFiles = [];
//   bool isLoading = false;
//   bool hasError = false;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     customerController = TextEditingController();
//     mobileController = TextEditingController();
//     _loadCustomerData();
//   }

//   void _initializeControllers(Map<String, dynamic> data) {
//     setState(() {
//       customerController.text = data['client_name'] ?? '';
//       mobileController.text = data['mobile_no'] ?? '';

//       final cars = data['car_data']['available_car'] as List;
//       existingCarIds = data['car_data']['car_id'] ?? [];

//       carModelNameControllers = cars.map((car) {
//         return TextEditingController(text: car['model_name'] ?? '');
//       }).toList();
//       carNoControllers = cars.map((car) {
//         return TextEditingController(text: car['vehicle_no'] ?? '');
//       }).toList();
//       carLatControllers = cars.map((car) {
//         return TextEditingController(text: car['latitude']?.toString() ?? '');
//       }).toList();
//       carLongControllers = cars.map((car) {
//         return TextEditingController(text: car['longitude']?.toString() ?? '');
//       }).toList();
//       carPhotosController = cars.map((car) {
//         return TextEditingController(text: car['car_images'] ?? '');
//       }).toList();
//       imageFiles = List.generate(cars.length, (index) => null);
//     });
//   }

//   Future<Map<String, dynamic>> fetchCustomerData(String customerId) async {
//     var request = http.MultipartRequest('POST',
//         Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-View'));

//     // Add fields to the request
//     request.fields.addAll({
//       'enc_key': 'C0oRAe1QNtn3zYNvJ8rv',
//       'emp_id': '123', // Replace with dynamic value if needed
//       'customer_id': customerId
//     });

//     // Send the request and get the response
//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       // Convert the response stream to a string
//       String responseString = await response.stream.bytesToString();

//       // Print for debugging
//       print(responseString);

//       // Decode the JSON string into a Map
//       Map<String, dynamic> data = jsonDecode(responseString);

//       // Return the decoded data
//       return data;
//     } else {
//       // Print error message
//       print(response.reasonPhrase);

//       // Handle errors (you might want to throw an exception or return an empty map)
//       throw Exception('Failed to load customer data');
//     }
//   }

//   Future<void> _loadCustomerData() async {
//     setState(() {
//       isLoading = true;
//       hasError = false;
//     });

//     try {
//       final data = await fetchCustomerData(widget.customer_id);
//       _initializeControllers(data);
//     } catch (e) {
//       setState(() {
//         hasError = true;
//         errorMessage = 'Failed to load customer data';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create/Update Customer'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : hasError
//                 ? Center(
//                     child:
//                         Text(errorMessage, style: TextStyle(color: Colors.red)))
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildTextField(customerController, 'Customer Name'),
//                       SizedBox(height: 16),
//                       _buildTextField(mobileController, 'Mobile Number'),
//                       SizedBox(height: 16),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: carModelNameControllers.length,
//                           itemBuilder: (context, index) {
//                             return _buildCarCard(index);
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: _updateCustomerData,
//                         child: Text('Save Changes'),
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildCarCard(int index) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField(carModelNameControllers[index], 'Car Model'),
//             SizedBox(height: 16),
//             _buildTextField(carNoControllers[index], 'Vehicle No'),
//             SizedBox(height: 16),
//             _buildImagePicker(index),
//             SizedBox(height: 16),
//             _buildLocationPicker(index),
//             if (index != 0)
//               Align(
//                 alignment: Alignment.topRight,
//                 child: IconButton(
//                   icon: Icon(Icons.remove_circle, color: Colors.red),
//                   onPressed: () => _removeCard(index),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePicker(int index) {
//     return GestureDetector(
//       onTap: () async {
//         if (carPhotosController[index].text.isEmpty) {
//           await _pickImage(context, index);
//         } else {
//           setState(() {
//             carPhotosController[index].text = '';
//             imageFiles[index] = null;
//           });
//         }
//       },
//       child: Container(
//         height: 100,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: imageFiles[index] != null
//               ? Image.file(imageFiles[index]!)
//               : carPhotosController[index].text.isNotEmpty
//                   ? Image.network(carPhotosController[index].text)
//                   : Icon(Icons.camera_alt, color: Colors.grey),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationPicker(int index) {
//     return GestureDetector(
//       onTap: () async {
//         await _getLocation(index);
//       },
//       child: Container(
//         height: 80,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Icon(Icons.location_on, color: Colors.green),
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage(BuildContext context, int index) async {
//     print('_pickImage called for index $index');
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       final File file = File(pickedFile.path);
//       print('Picked image path: ${pickedFile.path}'); // Debugging line

//       setState(() {
//         if (index < imageFiles.length) {
//           imageFiles[index] = file;
//         } else {
//           // In case index is out of bounds, add a new entry
//           imageFiles.add(file);
//         }
//         // Optionally update the corresponding text controller
//         carPhotosController[index].text = pickedFile.path;
//         print(
//             'Updated carPhotosController[$index] with path: ${carPhotosController[index].text}'); // Debugging line
//       });
//     } else {
//       print('No image picked');
//     }
//   }

//   Future<void> _getLocation(int index) async {
//     // Implement location picking logic here
//   }

//   void _removeCard(int index) {
//     setState(() {
//       carModelNameControllers.removeAt(index);
//       carNoControllers.removeAt(index);
//       carLatControllers.removeAt(index);
//       carLongControllers.removeAt(index);
//       carPhotosController.removeAt(index);
//       imageFiles.removeAt(index);
//     });
//   }

//   bool validateFields() {
//     if (customerController.text.isEmpty) {
//       showValidationError("Customer name is required");
//       return false;
//     }
//     if (mobileController.text.isEmpty) {
//       showValidationError("Mobile number is required");
//       return false;
//     }
//     if (mobileController.text.length != 10) {
//       showValidationError("Mobile number is invalid");
//       return false;
//     }
//     for (int i = 0; i < carModelNameControllers.length; i++) {
//       if (carModelNameControllers[i].text.isEmpty) {
//         showValidationError("Model name for car ${i + 1} is required");
//         return false;
//       }
//       if (carNoControllers[i].text.isEmpty) {
//         showValidationError("Vehicle number for car ${i + 1} is required");
//         return false;
//       }
//       if (carPhotosController[i].text.isEmpty &&
//           (imageFiles[i] == null || !imageFiles[i]!.existsSync())) {
//         showValidationError("Car image for car ${i + 1} is required");
//         return false;
//       }
//       if (carLatControllers[i].text.isEmpty ||
//           carLongControllers[i].text.isEmpty) {
//         showValidationError(
//             "Latitude and Longitude for car ${i + 1} is required");
//         return false;
//       }
//     }
//     return true;
//   }

//   void showValidationError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: AppTemplate.bgClr,
//         content: Text(
//           message,
//           style: GoogleFonts.inter(
//               color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
//         ),
//       ),
//     );
//   }

//   Future<void> _updateCustomerData() async {
//     if (!validateFields()) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse('https://wash.sortbe.com/API/Admin/Client/Client-Edit'),
//       );

//       void _addImageFiles(http.MultipartRequest request) {
//         for (int i = 0; i < imageFiles.length; i++) {
//           if (imageFiles[i] != null) {
//             request.files.add(
//               http.MultipartFile.fromBytes(
//                 'car_image_$i',
//                 imageFiles[i]!.readAsBytesSync(),
//                 filename: imageFiles[i]!.path.split('/').last,
//               ),
//             );
//           }
//         }
//       }

//       List<Map<String, dynamic>> _generateNewCarDataList() {
//         return List.generate(carModelNameControllers.length, (index) {
//           return {
//             'model_name': carModelNameControllers[index].text,
//             'vehicle_no': carNoControllers[index].text,
//             'latitude': carLatControllers[index].text,
//             'longitude': carLongControllers[index].text,
//             'car_photo': carPhotosController[index].text,
//           };
//         });
//       }

//       List<Map<String, dynamic>> _generateCarDataList(
//           List<String> existingCarIds) {
//         return List.generate(existingCarIds.length, (index) {
//           return {
//             'car_id': existingCarIds[index],
//             'model_name': carModelNameControllers[index].text,
//             'vehicle_no': carNoControllers[index].text,
//             'latitude': carLatControllers[index].text,
//             'longitude': carLongControllers[index].text,
//             'car_photo': carPhotosController[index].text,
//           };
//         });
//       }

//       void _addCarData(http.MultipartRequest request) {
//         final carData = {
//           'available_car': _generateCarDataList(existingCarIds),
//           'new_car': _generateNewCarDataList(),
//         };

//         request.fields['car_data'] = jsonEncode(carData);
//       }

//       _addCarData(request);
//       _addImageFiles(request);

//       // final admin = ref.read(authProvider);
//       request.fields.addAll({
//         'enc_key': encKey,
//         'emp_id': '123',
//         'customer_id': widget.customer_id,
//         'client_name': customerController.text,
//         'mobile': mobileController.text,
//         'car_data': jsonEncode({
//           'available_car': _generateCarDataList(existingCarIds),
//           'new_car': _generateNewCarDataList(),
//         }),
//       });

//       final response = await request.send();
//       if (response.statusCode == 200) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Customer()),
//         );
//       } else {
//         _showError('Error updating customer data');
//       }
//     } catch (e) {
//       _showError('An error occurred. Please try again.');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _showError(String message) {
//     setState(() {
//       hasError = true;
//       errorMessage = message;
//     });
//   }
// }
