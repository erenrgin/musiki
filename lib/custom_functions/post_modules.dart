import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:musiki/custom_functions/supabase_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../custom_designs/custom_text.dart';
import '../custom_designs/custom_text_field.dart';
import '../custom_tiles/post_data_tile.dart';
import 'design_functions.dart';

// Show shared posts widget
Widget sharedContents(String? userID, bool isFeed) {
  return StatefulBuilder(
    builder: (context, setState) {
      return FutureBuilder<PostgrestResponse<dynamic>>(
        future: getSentPosts(userID, isFeed),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: customLoad(context));
          } else if (snapshot.hasData) {
            List<dynamic> posts = snapshot.data!.data as List<dynamic>;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                String postCreatedAtString = posts[index]['post_created_at'];

                DateTime postCreatedAt = DateTime.parse(postCreatedAtString);
                DateTime currentTime = DateTime.now().toUtc();

                Duration difference = currentTime.difference(postCreatedAt);
                difference = difference.abs();

                String timeAgo = '';
                if (difference.inDays > 0) {
                  timeAgo = '${difference.inDays} d';
                } else if (difference.inHours > 0) {
                  timeAgo = '${difference.inHours} h';
                } else if (difference.inMinutes > 0) {
                  timeAgo = '${difference.inMinutes} m';
                } else {
                  timeAgo = 'now';
                }
                return postDataTile(
                  postID: posts[index]['post_id'],
                  postSenderID: posts[index]['post_sender_id'],
                  postType: posts[index]['post_type'],
                  postCreatedAt: timeAgo,
                  postLikes: posts[index]['post_likes'],
                  postContent: posts[index]['post_content'],
                  context: context,
                  postImage: posts[index]['post_image'],

                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Container();
        },
      );
    },
  );
}

// Show rated posts widget
Widget ratedContents(String? userID) {
  return StatefulBuilder(builder: (context, setState) {
    return FutureBuilder<PostgrestResponse<dynamic>>(
      future: getRatedPosts(userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: customLoad(context));
        } else if (snapshot.hasData) {
          List<dynamic> posts = snapshot.data!.data as List<dynamic>;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              String postCreatedAtString = posts[index]['post_created_at'];

              DateTime postCreatedAt = DateTime.parse(postCreatedAtString);
              DateTime currentTime = DateTime.now().toUtc();

              Duration difference = currentTime.difference(postCreatedAt);
              difference = difference.abs();

              String timeAgo = '';
              if (difference.inDays > 0) {
                timeAgo = '${difference.inDays} d';
              } else if (difference.inHours > 0) {
                timeAgo = '${difference.inHours} h';
              } else if (difference.inMinutes > 0) {
                timeAgo = '${difference.inMinutes} m';
              } else {
                timeAgo = 'now';
              }
              return postDataTile(
                postID: posts[index]['post_id'],
                postSenderID: posts[index]['post_sender_id'],
                postType: posts[index]['post_type'],
                postCreatedAt: timeAgo,
                postLikes: posts[index]['post_likes'],
                postContent: posts[index]['post_content'],
                context: context,
                postImage: posts[index]['post_image'],

              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Container(
          child: welcomeFaintText("No Data", context),
        );
      },
    );
  });
}



// Show share media widget
Widget shareMedia(
    String? profileImage, TextEditingController shareContent, String? userID,  VoidCallback onTapSend,VoidCallback onTapGallery,) {
  return Row(children: [
    SizedBox(
      height: 50,
      width: 50,
      child: CircleAvatar(
        foregroundImage: NetworkImage(profileImage!),
        backgroundImage:
            const AssetImage("assets/images/blank_profile_image.png"),
      ),
    ),
    Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: shareMediaTextField(shareContent,onTapGallery)),
    ),
    IconButton(
      icon: const Icon(
        Iconsax.send_2,
        size: 35,
        color: Colors.green,
      ),
      onPressed: onTapSend
    ),
  ]);
}
