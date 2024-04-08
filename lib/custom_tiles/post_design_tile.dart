import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musiki/custom_designs/custom_text.dart';
import 'package:musiki/custom_functions/supabase_functions.dart';

import '../main.dart';

class PostDesignTile extends StatefulWidget {
  final String senderID;
  final String senderImage;
  final String senderName;
  final String postID;
  final String postImage;
  final String postContent;
  final int postType;
  final List<dynamic> postLikes;
  final String postCreatedAt;

  const PostDesignTile({
    Key? key,
    required this.context,
    required this.senderID,
    required this.senderImage,
    required this.senderName,
    required this.postID,
    required this.postContent,
    required this.postType,
    required this.postLikes,
    required this.postCreatedAt,
    required this.postImage,
  }) : super(key: key);

  final BuildContext context;

  @override
  PostDesignTileState createState() => PostDesignTileState();
}

class PostDesignTileState extends State<PostDesignTile> {
  bool isLiked = false;
  int likeNum = 0;
  @override
  void initState() {
    super.initState();
    // Check if the current user has liked the post
    isLiked = widget.postLikes.contains(user!.id);
    likeNum = widget.postLikes.length; // Update likeNum to initial number of likes

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  titleAlignment: ListTileTitleAlignment.top,
                  leading: CircleAvatar(
                    backgroundImage: const AssetImage(
                        "assets/images/blank_profile_image.png"),
                    foregroundImage:
                        CachedNetworkImageProvider(widget.senderImage),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      postSenderNameText(widget.senderName),
                      postSenderNameText(widget.postCreatedAt)
                    ],
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      postTypeText(
                        (() {
                          switch (widget.postType) {
                            case 1:
                              return "Shared a comment";
                            case 2:
                              return "Shared an image";
                            default:
                              return "Unknown source";
                          }
                        })(),
                      ),
                      widget.postType == 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: postContentText(widget.postContent),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.postContent == ""
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child:
                                            postContentText(widget.postContent),
                                      ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: CachedNetworkImage(
                                      imageUrl: widget.postImage),
                                ),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(0.0),
                              icon: Icon(Icons.favorite,
                                  color: isLiked ? Colors.red : Colors.white70),
                              onPressed: () async {
                                await likePost(widget.postID, user!.id,
                                    (newLikeNum) {
                                  setState(() {
                                    likeNum = newLikeNum;
                                  });
                                }).then((value) {
                                  setState(() {
                                    isLiked = value;
                                  });
                                });
                              },
                            ),
                            postSenderNameText(likeNum.toString())
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
