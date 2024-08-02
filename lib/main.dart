import 'package:car_wash/common/widgets/demo.dart';
import 'package:car_wash/features/dashboard.dart';
import 'package:car_wash/features/employee/editEmployee.dart';
import 'package:car_wash/features/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]).then((_) {
//     runApp(ProviderScope(child: DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => MyApp(), // Wrap your app
//   ),));
//   });
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(ProviderScope(
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<Map<String, String>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? image = prefs.getString('employee_pic');
    String? emp_id = prefs.getString('emp_id');
    return {
      'name': name ?? '',
      'image': image ?? '',
      'emp_id': emp_id ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: FutureBuilder<bool>(
                future: checkLoginStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (snapshot.hasData && snapshot.data == true) {
                    return FutureBuilder<Map<String, String>>(
                      future: getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading data'));
                        } else if (snapshot.hasData) {
                          final userData = snapshot.data!;
                          return DashBoard(
                            name: userData['name']!,
                            image: userData['image']!,
                            empid: userData['emp_id']!,
                          );
                        } else {
                          return const LoginScreen();
                        }
                      },
                    );
                  } else {
                    return const LoginScreen();
                  }
                },
              ));
          // home: EditEmployeePage());
        });
  }
}
