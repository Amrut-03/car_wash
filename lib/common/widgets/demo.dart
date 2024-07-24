// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// // Your ApiService class
// class ApiService {
//   final String baseUrl;

//   ApiService(this.baseUrl);

//   Future<http.Response> createAdmin() async {
//     final url = Uri.parse('$baseUrl');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'emp_id': "1234",
//         'emp_name': "Amrut",
//         'phone_1': "1234567890",
//         'phone_2': "",
//         'password': "123456",
//         'role': 'Admin',
//         'emp_photo': "",
//       }),
//     );
//     return response;
//   }
// }

// // Main app widget
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AdminPage(),
//     );
//   }
// }

// class AdminPage extends StatefulWidget {
//   const AdminPage({super.key});

//   @override
//   _AdminPageState createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   final ApiService apiService = ApiService(
//       'https://wash.sortbe.com/API/Admin/User/Employee-Creation'); // Replace with your actual API endpoint

//   void _createAdmin() async {
//     final response = await apiService.createAdmin();
//     if (response.statusCode == 200) {
//       // Success logic
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Admin created successfully!')));
//     } else {
//       // Failure logic
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Failed to create admin')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Admin'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _createAdmin,
//           child: Text('Submit'),
//         ),
//       ),
//     );
//   }
// }
