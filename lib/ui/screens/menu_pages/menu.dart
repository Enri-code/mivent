import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:mivent/theme/mivent_icons.dart';
import 'package:mivent/ui/screens/menu_pages/account.dart';
import 'package:mivent/ui/screens/menu_pages/discover.dart';
import 'package:mivent/ui/screens/menu_pages/liked.dart';
import 'package:mivent/ui/screens/menu_pages/your_events.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/menu';
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final PageController pageController;
  var currentPage = 1;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true,
      initialPage: currentPage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageCache!.clearLiveImages();
    imageCache!.clear();
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (page) => setState(() => currentPage = page),
        children: const [
          YourEventsPage(),
          DicoverPage(),
          LikedPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: FancyBottomNavigation(
        //TODO: check if changing it with hot reload changes selected screen
        selection: currentPage,
        tabs: [
          TabData(
            icon: const Icon(MiventIcons.event_planning),
            title: const Text('Your Events'),
          ),
          TabData(
            icon: const Icon(MiventIcons.compass),
            title: const Text('Discover'),
          ),
          TabData(
            icon: const Icon(Icons.favorite_border),
            title: const Text('Liked'),
          ),
          TabData(
            icon: const Icon(MiventIcons.user),
            title: const Text('You'),
          ),
        ],
        onTabChangedListener: (index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
