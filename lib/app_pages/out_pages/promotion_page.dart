import 'package:flutter/material.dart';
import 'package:musiki/app_pages/out_pages/login_page.dart';
import 'package:musiki/custom_designs/custom_button.dart';
import 'package:musiki/custom_designs/custom_text.dart';

class PromotionPage extends StatelessWidget {
  const PromotionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: 0.3,
                  fit: BoxFit.fill,
                  image: ExactAssetImage(
                    "assets/images/promotion_background.jpg",
                  ))),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(right: 50.0, left: 50, bottom: 25,top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  scale: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 150),
                  child: promotionText("Enjoy Your\nPlaylist"),
                ),

                Padding(
                    padding: const EdgeInsets.all(10),
                    child: longButton(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    }, "Next", Colors.green.shade700, context))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
