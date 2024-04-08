import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musiki/custom_functions/supabase_functions.dart';

import '../../custom_designs/custom_color.dart';
import '../../custom_functions/post_modules.dart';
import '../../main.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String _myProfileImage = "";

  final TextEditingController _shareContent = TextEditingController();
  File? _postImageFile;

  @override
  void initState() {
    if (kDebugMode) {
      print(user?.id);
    }
    super.initState();
    fetchUserInfo(user?.id, updateUserInformation);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateUserInformation(
      String profileImage,
      String coverImage,
      String name,
      String bio,
      String country,
      DateTime? dateOfBirth,
      bool userInformationLoaded) {
    setState(() {
      _myProfileImage = profileImage;
    });
  }

// Function to handle picking an image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _postImageFile = File(pickedFile.path);
      // Upload the selected image to Supabase
      await sendImage(_postImageFile!, user?.id, _shareContent.text)
          .then((value) {
        setState(() {});
      });
      _shareContent.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor(),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Image.asset("assets/images/logo.png", scale: 4),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                shareMedia(_myProfileImage, _shareContent, user?.id, () {
                  sendText(_shareContent, user?.id).then((value) {
                    setState(() {});
                  });
                }, () {
                  _pickImage();
                }),
                Expanded(child: sharedContents("", true)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
