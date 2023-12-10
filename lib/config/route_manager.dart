import 'package:x_prompt/modules/authentication/screens/link_wallet_screen.dart';
import 'package:x_prompt/modules/create%20nft/screens/create_nft_screen.dart';
import 'package:x_prompt/modules/dashboard/screens/dashobard_screen.dart';
import 'package:x_prompt/modules/authentication/screens/login_screen.dart';
import 'package:x_prompt/modules/splashscreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../modules/bottom_nav/bottom_nav_bar.dart';

class RouteManager {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const SplashScreen(),
        );
      case CreateNFTScreen.routeName:
        return PageTransition(
          settings: const RouteSettings(name: CreateNFTScreen.routeName),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 500),
          child: const CreateNFTScreen(),
        );

      case LinkWalletScreen.routename:
        return PageTransition(
          settings: const RouteSettings(name: LinkWalletScreen.routename),
          type: PageTransitionType.bottomToTop,
          child: LinkWalletScreen(
            afterConnect: () {},
          ),
        );
      case BottomNavScreen.routeName:
        return MaterialPageRoute(
          settings: const RouteSettings(name: BottomNavScreen.routeName),
          builder: (_) => const BottomNavScreen(),
        );
      case DashBoardScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: DashBoardScreen.routename),
          builder: (_) => const DashBoardScreen(),
        );

      case LoginScreen.routename:
        return MaterialPageRoute(
          settings: const RouteSettings(name: LoginScreen.routename),
          builder: (_) => const LoginScreen(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
