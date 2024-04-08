import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

// Check email is avaliable
Future<bool> userMailCheck(String userMail) async {
  PostgrestResponse<dynamic> response =
      await supabase.from('users').select().eq('email', userMail).execute();

  var data = response.data;
  return data.isEmpty;
}

// Search user
searchUser(String userID) {
  return supabase.from("users").select().textSearch("fts", "$userID:*");
}

// Fetch user informations
Future<void> fetchUserInfo(
    String? userID,
    Function(String, String, String, String, String, DateTime?, bool)
        updateUserInformation) async {
  try {
    PostgrestResponse<dynamic> response =
        await supabase.from('users').select().eq('uid', userID).execute();

    List<dynamic> data = response.data as List<dynamic>;

    if (data.isNotEmpty) {
      var userData = data.first;

      String profileImage = userData['profile_image'];
      String coverImage = userData['cover_image'];
      String name = userData['name'];
      String bio = userData['bio'];
      String country = userData['country'];
      DateTime? dateOfBirth = userData['date_of_birth'] != null
          ? DateTime.parse(userData['date_of_birth'])
          : null;
      bool userInformationLoaded = true;

      updateUserInformation(profileImage, coverImage, name, bio, country,
          dateOfBirth, userInformationLoaded);
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching user profile: $e');
    }
  }
}




// Send text to home
Future<void> sendText(
    TextEditingController shareContent, String? userID) async {
  if (shareContent.text.isNotEmpty) {
    String content = shareContent.text;

    await supabase.from("posts").insert(
        {"post_content": content, "post_type": 1, "post_sender_id": userID});
    shareContent.clear();
  }
}


// Function to send image
Future<void> sendImage(File imageFile, String? userID, String? contentText) async {
   final fileName = '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';

   String path = await supabase.storage.from('images').upload("post_images/$fileName", imageFile);

  String imageUrl = supabase.storage.from('').getPublicUrl(path);

  await supabase
      .from('posts')
      .insert(
      {"post_image": imageUrl, "post_content": contentText, "post_type": 2, "post_sender_id": userID});
}

// Like the post
Future<bool> likePost(String postID, String userID, void Function(int) updateLikeNum) async {
  var response = await supabase
      .from('posts')
      .select("*")
      .eq('post_id', postID)
      .single()
      .execute();

  var newArray = List<String>.from(response.data['post_likes'] ?? []);
  if (newArray.contains(userID)) {
    newArray.remove(userID);
    await supabase
        .from('posts')
        .update({'post_likes': newArray})
        .eq('post_id', postID)
        .execute();
    updateLikeNum(newArray.length);
    return false;
  } else {
    newArray.add(userID);
    await supabase
        .from('posts')
        .update({'post_likes': newArray})
        .eq('post_id', postID)
        .execute();
    updateLikeNum(newArray.length);
    return true;
  }
}


// Get sent post
Future<PostgrestResponse<dynamic>> getSentPosts(userID, bool isFeed) async {
  if (isFeed == false) {
    PostgrestResponse<dynamic> response = await supabase
        .from("posts")
        .select()
        .eq("post_sender_id", userID)
        .order("post_created_at", ascending: false)
        .execute();
    return response;
  } else {
    PostgrestResponse<dynamic> response = await supabase
        .from("posts")
        .select()
        .order("post_created_at", ascending: false)
        .execute();
    return response;
  }
}

// Get rated post
Future<PostgrestResponse<dynamic>> getRatedPosts(userID) async {
  PostgrestResponse<dynamic> response = await supabase
      .from("posts")
      .select()
      .contains("post_likes", [user?.id])
      .order("post_created_at", ascending: false)
      .execute();

  return response;
}

// Get rated post
Future<PostgrestResponse<dynamic>> savePlaylist(
    String playlistName, List<String> playlistContent) async {
  PostgrestResponse<dynamic> response = await supabase
      .from("playlists")
      .insert({
    "playlist_name": playlistName,
    "playlist_content": playlistContent
  }).execute();

  return response;
}

// Get playlists
Future<List<dynamic>> fetchPlaylists(userID) async {
  final response = await supabase
      .from('playlists')
      .select()
      .eq("playlist_creator_id", userID)
      .execute();

  return response.data as List<dynamic>;
}

Future<List<String>> getPlaylistTrackIDs(String playlistId) async {
  try {
    final response = await supabase
        .from('playlists')
        .select('playlist_content')
        .eq('playlist_id', playlistId)
        .execute();
    final playlistContent = response.data?.first['playlist_content'];
    if (playlistContent is List<dynamic>) {
      // Extract track IDs from playlist content
      final trackIds = playlistContent.cast<String>(); // Assuming playlist content contains track IDs as strings
      return trackIds;
    } else {
      throw Exception('Playlist content is not in the expected format');
    }
  } catch (error) {
    // Handle error
    if (kDebugMode) {
      print('Error fetching playlist content: $error');
    }
    return [];
  }
}
