import 'package:x_prompt/modules/authentication/screens/link_wallet_screen.dart';
import 'package:x_prompt/modules/bottom_nav/bottom_nav_bar.dart';

import 'package:x_prompt/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
// import 'package:x_prompt/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  static const routename = '/login-screen';

  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 0),
      () {
        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return LinkWalletScreen(
              afterConnect: () {
                Navigator.of(context)
                    .pushReplacementNamed(BottomNavScreen.routeName);
              },
            );
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/playstore.png',
                      width: 40.w,
                      height: 40.w,
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomOutlineButton(
                    text: "Connect Wallet",
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return LinkWalletScreen(
                            afterConnect: () {
                              Navigator.of(context).pushReplacementNamed(
                                  BottomNavScreen.routeName);
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 4.h,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
