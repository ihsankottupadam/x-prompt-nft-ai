import 'package:x_prompt/config/route_manager.dart';
import 'package:x_prompt/core/theme.dart';
import 'package:x_prompt/modules/authentication/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:x_prompt/modules/bottom_nav/bottom_nav_bar.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ai.muse',
          theme: AppTheme.theme,
          //ThemeData(scaffoldBackgroundColor: const Color(0x0ff4f7fe).withOpacity(1)),
          onGenerateRoute: RouteManager.onGenerateRoute,
          initialRoute: LoginScreen.routename,
        );
      },
    );
  }
}
