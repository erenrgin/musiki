import 'package:flutter/material.dart';
import 'package:musiki/custom_tiles/post_design_tile.dart';

import '../custom_designs/custom_text.dart';
import '../main.dart';

// Private Rooms Tile
Widget postDataTile({
  required String postID,
  required String postContent,
  required String postSenderID,
  required int postType,
  required String postCreatedAt,
  required List<dynamic> postLikes,
   required context,
   required String postImage,
}) {
  return FutureBuilder<List<dynamic>>(
    future: supabase
        .from("users")
        .select()
        .eq('uid', postSenderID)
        .execute()
        .then((response) => response.data),
    builder: (_, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildPostDesignTile(
          context,
          senderName: "",
          senderImage: "assets/images/blank_profile_image.png",

          postContent: postContent,
          postType: postType,
          postCreatedAt: postCreatedAt,
          postLikes: postLikes,
          senderID: postSenderID,
          postID: postID, postImage: postImage,
        );
      } else if (snapshot.hasError) {
        return errorContentText(snapshot.error);
      } else {
        var output = snapshot.data![0] as Map<String, dynamic>; // Cast to map
        var userName = output['name'];
        var userProfileImage = output['profile_image'];

        return _buildPostDesignTile(
          context,
          senderName: userName,
          senderImage: userProfileImage,

          postContent: postContent,
          postType: postType,
          postCreatedAt: postCreatedAt,
          postLikes: postLikes,
          senderID: postSenderID,
          postID: postID, postImage: postImage,
        );
      }
    },
  );
}

Widget _buildPostDesignTile(
  BuildContext context, {
  required String senderName,
  required String senderID,
  required String senderImage,
  required String postID,
  required String postContent,
  required int postType,
  required List<dynamic> postLikes,
  required String postCreatedAt,
  required String postImage,
  }) {
  return PostDesignTile(
    context: context,
    senderImage: senderImage,
    senderName: senderName,
    postContent: postContent,
    postType: postType,
    postLikes: postLikes,
    postCreatedAt: postCreatedAt,
    senderID: senderID,
    postID: postID, postImage: postImage,
  );
}
