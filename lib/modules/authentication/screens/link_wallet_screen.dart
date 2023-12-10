import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:x_prompt/modules/authentication/widgets/social_auth_button.dart';
import 'package:x_prompt/utils/constants.dart';
import 'package:x_prompt/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'package:x_prompt/widgets/primary_button.dart';
import 'package:x_prompt/widgets/custom_outlined_button.dart';
import 'package:x_prompt/modules/dashboard/screens/dashobard_screen.dart';
import 'package:x_prompt/utils/session_helper.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';

import 'package:web3auth_flutter/output.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
//import 'package:solana_web3/solana_web3.dart' as web3;

class LinkWalletScreen extends StatefulWidget {
  final Function() afterConnect;
  static const routename = '/link-wallet-screen';

  const LinkWalletScreen({
    Key? key,
    required this.afterConnect,
  }) : super(key: key);

  @override
  State<LinkWalletScreen> createState() => _LinkWalletScreenState();
}

class _LinkWalletScreenState extends State<LinkWalletScreen> {
  String _result = '';
  bool logoutVisible = false;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#229954";

    Uri redirectUrl;
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('aimuse://com.example.x_prompt/auth');
    } else if (Platform.isIOS) {
      redirectUrl =
          Uri.parse('com.web3auth.flutter.web3authFlutterExample://openlogin');
    } else {
      throw UnKnownException('Unknown platform');
    }

    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId:
            'BCJEQuYINJKBEFnpWeQp73_ScAY18qB-eM6o1-0flxPqN8UqOokt-SuQqtyZRzey39CGAtFYdXr4QUepy3UL-_w',
        network: Network.testnet,
        redirectUrl: redirectUrl,
        whiteLabel:
            WhiteLabelData(dark: true, name: "AI Muse", theme: themeMap),
      ),
    );
  }

  bool _showSecond = false;
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'AI Muse',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  // ignore: prefer_typing_uninitialized_variables
  var _session;

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        debugPrint(session.accounts[0]);
        debugPrint(session.chainId.toString());
        setState(() {
          _session = session;
        });
      } catch (exp) {
        debugPrint(exp.toString());
      }
    }
  }

  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 5001:
        return 'Mantle Testnet';
      case 80001:
        return 'Mumbai Testnet';
      default:
        return 'Unknown Chain';
    }
  }

  @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(
              () {
                _session = session;
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
              debugPrint(_session.accounts[0]);
              debugPrint(_session.chainId);
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: scaffoldBackgroundColor,
      ),
      width: double.infinity,
      duration: const Duration(milliseconds: 400),
      child: AnimatedCrossFade(
        firstChild: SocialLoginSheet(context),
        secondChild: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Congratulations 🎉",
                style: appFont(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Lottie.asset("assets/animations/confetti.json", height: 25.h),
              PrimaryButton(onPressed: widget.afterConnect, text: "Okay"),
              SizedBox(
                height: 3.h,
              ),
            ],
          ),
        ),
        crossFadeState:
            _showSecond ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  SocialLoginSheet(context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              height: 1.h,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(40)),
              width: 30.w,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Icon(
            Icons.login,
            color: const Color(0XFF707EAE),
            size: 6.h,
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            "Walletless login",
            style: appFont(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "Choose a social login from below or sign in via email",
            style: appFont(
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              color: const Color(0XFF8F9BBA),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 3.h,
          ),
          SocialAuthButton(
              icon: FontAwesomeIcons.google,
              text: "Google",
              onPressed: _login(_withGoogle)),
          SizedBox(
            height: 2.h,
          ),
          SocialAuthButton(
              icon: FontAwesomeIcons.facebook,
              text: "Facebook",
              onPressed: _login(_withFacebook)),
          SizedBox(height: 2.h),
          SocialAuthButton(
              icon: FontAwesomeIcons.discord,
              text: "Discord",
              onPressed: _login(_withDiscord)),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "or",
            style: appFont(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: const Color(0XFF8F9BBA),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 2.h,
          ),
          SocialAuthButton(
            icon: Icons.mail,
            text: "Email",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40.0))),
                context: context,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: const BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 1.h,
                            decoration: BoxDecoration(
                                color: const Color(0XFFE0E5F2),
                                borderRadius: BorderRadius.circular(40)),
                            width: 30.w,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Icon(
                          Icons.mail,
                          color: const Color(0XFF707EAE),
                          size: 6.h,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Email login",
                          style: appFont(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Text(
                            "Please enter your email address & proceed password-less",
                            style: appFont(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: const Color(0XFF8F9BBA),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              fillColor: Colors.white12,
                              hintText: "Email",
                              border: InputBorder.none,
                              suffix: InkWell(
                                child: Icon(
                                  Icons.close,
                                  size: 14.sp,
                                ),
                                onTap: () {
                                  textEditingController.clear();
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: PrimaryButton(
                            onPressed: _login(_withEmailPasswordless),
                            text: "Verify",
                            showIcon: false,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  demo() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Visibility(
          visible: !logoutVisible,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.flutter_dash,
                size: 80,
                color: Color(0xFF1389fd),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Web3Auth',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: Color(0xFF0364ff)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Welcome to Web3Auth x Flutter Demo',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Login with',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: _login(_withGoogle), child: const Text('Google')),
              ElevatedButton(
                  onPressed: _login(_withFacebook),
                  child: const Text('Facebook')),
              ElevatedButton(
                  onPressed: _login(_withEmailPasswordless),
                  child: const Text('Email Passwordless')),
              ElevatedButton(
                  onPressed: _login(_withDiscord),
                  child: const Text('Discord')),
            ],
          ),
        ),
        Visibility(
          // ignore: sort_child_properties_last
          child: Column(
            children: [
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red[600] // This is what you need!
                        ),
                    onPressed: _logout(),
                    child: const Column(
                      children: [
                        Text('Logout'),
                      ],
                    )),
              ),
            ],
          ),
          visible: logoutVisible,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_result),
        )
      ],
    ));
  }

  customModalBottomSheet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: Colors.white,
      ),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 10.h,
            width: 100.w,
            child: const TextField(
              // controller: _walletAddressController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff26384f))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff26384f))),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff26384f),
                  ),
                ),
                labelStyle: TextStyle(color: Color(0xff26384f)),
                hintStyle: TextStyle(color: Color(0xff26384f)),
                labelText: 'NFT Name',
              ),
            ),
          ),
          Transform.scale(
            scale: 0.7,
            child: CustomOutlineButton(
                text: "Done",
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(DashBoardScreen.routename);
                }),
          ),
        ],
      ),
    );
  }

  VoidCallback _login(Future<Web3AuthResponse> Function() method) {
    return () async {
      try {
        final Web3AuthResponse response = await method();
        setState(() {
          SessionManager.userPrivateKey = response.privKey;
          logoutVisible = true;
          _showSecond = true;
          log('user info:' +
              (response.userInfo?.toJson().toString() ?? 'empty'));
        });
        final credentials =
            EthPrivateKey.fromHex(SessionManager.userPrivateKey!);
        log('wellet address: ${credentials.address}');
        SessionManager.walletAddress = credentials.address.hex;
        log(SessionManager.walletAddress!);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', response.userInfo?.name ?? 'user');
        prefs.setString('imagePath', response.userInfo?.profileImage ?? '');
      } on UserCancelledException {
        debugPrint("User cancelled.");
      } on UnKnownException {
        debugPrint("Unknown exception occurred");
      }
    };
  }

  VoidCallback _logout() {
    return () async {
      try {
        await Web3AuthFlutter.logout();
        setState(() {
          _result = '';
          logoutVisible = false;
        });
      } on UserCancelledException {
        debugPrint("User cancelled.");
      } on UnKnownException {
        debugPrint("Unknown exception occurred");
      }
    };
  }

  Future<Web3AuthResponse> _withGoogle() {
    return Web3AuthFlutter.login(LoginParams(
      loginProvider: Provider.google,
      mfaLevel: MFALevel.NONE,
    ));
  }

  Future<Web3AuthResponse> _withFacebook() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.facebook));
  }

  Future<Web3AuthResponse> _withEmailPasswordless() {
    return Web3AuthFlutter.login(LoginParams(
        loginProvider: Provider.email_passwordless,
        extraLoginOptions:
            ExtraLoginOptions(login_hint: textEditingController.text)));
  }

  Future<Web3AuthResponse> _withDiscord() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.discord));
  }
}
