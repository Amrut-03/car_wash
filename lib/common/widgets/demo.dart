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

import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Top Slide-in Menu Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Draggable Top Slide-in Menu Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double _initialDragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleMenu() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else if (_controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable Top Slide-in Menu Demo'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleMenu,
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Text('Press the menu icon to show the top menu'),
          ),
          SlideTransition(
            position: _offsetAnimation,
            child: GestureDetector(
              onVerticalDragStart: (details) {
                _initialDragOffset = details.globalPosition.dy;
              },
              onVerticalDragUpdate: (details) {
                if (details.globalPosition.dy - _initialDragOffset > 0) {
                  _controller.value = 1.0 -
                      (details.globalPosition.dy - _initialDragOffset) /
                          MediaQuery.of(context).size.height;
                }
              },
              onVerticalDragEnd: (details) {
                if (_controller.value > 0.5) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: Material(
                elevation: 8.0,
                child: Container(
                  color: Colors.white,
                  height: 250,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Profile'),
                        onTap: _toggleMenu,
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: _toggleMenu,
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: _toggleMenu,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
