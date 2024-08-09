import 'package:car_wash/features/dashboard.dart';
import 'package:car_wash/features/login.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, child) {
        Widget home;
        if (!authState.isLoggedIn) {
          home = const LoginScreen();
        } else {
          home = DashBoard();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: home,
        );
      },
    );
  }
}
