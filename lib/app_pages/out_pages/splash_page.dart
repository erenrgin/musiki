import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:musiki/app_pages/out_pages/promotion_page.dart';
import 'package:page_transition/page_transition.dart';

import '../in_pages/navbar.dart';

class SplashScreen extends StatelessWidget {
  final bool userIsLoggedIn;

  const SplashScreen(this.userIsLoggedIn, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(

      splash: Image.asset('assets/images/splash_logo.png',scale: 1,),
      backgroundColor: Colors.black,
      nextScreen: userIsLoggedIn ?  const Navbar() : const PromotionPage(),
      duration: 300,
      splashIconSize: 400,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
