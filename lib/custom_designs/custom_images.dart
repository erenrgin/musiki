import 'package:flutter/material.dart';

import '../app_pages/in_pages/open_image_page.dart';

imageProfileCombine(
    BuildContext context, String profile, String cover, String name) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ImageOpenPage(cover, name)));
    },
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(cover),
            fit: BoxFit.fitWidth,
          ),
          color: Colors.green.shade700,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: Wrap(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ImageOpenPage(profile, name)));
                    },
                    child: SizedBox(
                        height: 125,
                        width: 125,
                        child: CircleAvatar(
                          backgroundColor: Colors.green.shade900,
                          foregroundImage: NetworkImage(profile),
                          backgroundImage: const AssetImage(
                              "assets/images/blank_profile_image.png"),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ),
  );
}
