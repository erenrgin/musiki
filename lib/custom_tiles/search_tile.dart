// Search Tile
import 'package:flutter/material.dart';
import 'package:musiki/app_pages/in_pages/other_user_page.dart';
import '../app_pages/in_pages/open_image_page.dart';
import '../custom_designs/custom_text.dart';

// Search user bar
Widget searchUserTile(
    {required String userID,
    required String userName,
    required String userProfileImage,
    required context}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtherUserPage(userID: userID)));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ImageOpenPage(userProfileImage, userName)));
                },
                child: CircleAvatar(
                  foregroundImage: NetworkImage(userProfileImage),
                  backgroundImage:
                      const AssetImage("assets/images/blank_profile_image.png"),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            searchTitleText(userName),
          ],
        ),
      ),
    ),
  );
}
