import 'package:x_prompt/modules/dashboard/screens/dashobard_screen.dart';
import 'package:x_prompt/modules/profile/screens/profile_screen.dart';
import 'package:x_prompt/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});
  static const routeName = '/bottom-nav-bar';

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with SingleTickerProviderStateMixin {
  int currIndex = 0;
  late TabController tabController;

  final List<Widget> screens = [
    DashBoardScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: scaffoldBackgroundColor,
      body: TabBarView(controller: tabController, children: const [
        DashBoardScreen(),
        ProfileScreen(),
      ]),
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: const Color(0xff474958),
            boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black26)],
            border:
                Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(3),
            )),
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 60,
        child: TabBar(
          indicatorColor: secondaryColor,
          controller: tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white30,
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          indicatorWeight: 0.5,
          splashFactory: NoSplash.splashFactory,
          tabs: const [
            Tab(icon: Icon(FontAwesomeIcons.house, size: 20)),
            Tab(icon: Icon(FontAwesomeIcons.user, size: 20)),
          ],
        ),
      ),
    );
  }
}
