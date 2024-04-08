import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:musiki/app_pages/in_pages/feed_page.dart';
import 'package:musiki/app_pages/in_pages/my_profile_page.dart';
import 'package:musiki/app_pages/in_pages/search_user_page.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  NavbarState createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  int _pageIndex = 0;

  final List<StatefulWidget> _pages = [
    const FeedPage(),
    const SearchUserPage(),
    const MyProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 750),
        transitionBuilder: (child, animation, secondaryAnimation) =>
            FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fillColor: Colors.grey.shade900,
          child: child,
        ),
        child: _pages[_pageIndex],
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.black,
        rippleColor: Colors.grey.shade800,
        hoverColor: Colors.grey.shade800,
        gap: 25,
        activeColor: Colors.white,
        iconSize: 35,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        duration: const Duration(milliseconds: 500),
        tabBackgroundColor: Colors.grey.shade900,
        color: Colors.grey.shade600,

        tabs:  [
          GButton(
            iconActiveColor: Colors.green.shade400,
            icon: Iconsax.home,
            text: 'Akış',
            textColor:  Colors.green.shade400,
          ),
          GButton(
            iconActiveColor: Colors.green.shade400,

            icon: Iconsax.search_normal,
            text: 'Ara',
            textColor:  Colors.green.shade400,

          ),
          GButton(
            iconActiveColor: Colors.green.shade400,

            icon: Iconsax.user,
            text: 'Profil',
            textColor:  Colors.green.shade400,

          ),
        ],
        selectedIndex: _pageIndex,
        onTabChange: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ));
}
