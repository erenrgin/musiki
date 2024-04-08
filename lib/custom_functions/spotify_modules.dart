import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:musiki/custom_functions/supabase_functions.dart';

import '../custom_designs/custom_text.dart';
import 'design_functions.dart';

// Get Spotify API token
Future<String> getAuthToken() async {
  // Your Spotify API credentials
  String clientId = '88cc2888824f4cb7a5c2a5a5399e0de0';
  String clientSecret = 'ed1b26e47a604e4290a3b559369da5b7';
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

  String tokenUrl = 'https://accounts.spotify.com/api/token';
  final response = await http.post(Uri.parse(tokenUrl), headers: {
    'Authorization': basicAuth,
    'Content-Type': 'application/x-www-form-urlencoded',
  }, body: {
    'grant_type': 'client_credentials',
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return data['access_token'];
  } else {
    throw Exception('Failed to get access token');
  }
}

// Search songs with Spotify API
Future<List<dynamic>> searchSong(String query) async {
  String accessToken = await getAuthToken();
  String apiUrl =
      'https://api.spotify.com/v1/search?q=$query&type=track&limit=10';

  try {
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body)['tracks']['items'];
    } else {
      throw Exception('Failed to load search results');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
    return []; // Return an empty list in case of an error
  }
}

// Playlist create button
Widget createPlaylistButton(VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Iconsax.add,
            size: 50,
            color: Colors.white70,
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: playlistNameText(
              "Create Playlist",
            ))
      ],
    ),
  );
}

Widget showPlaylists(String? userID, bool isMe,
    VoidCallback? createPlaylistDialog, String userImage, String userName) {
  return FutureBuilder<List<dynamic>>(
    future: fetchPlaylists(userID),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
          child: Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.green),
          ),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return isMe == true
            ? createPlaylistButton(createPlaylistDialog!)
            : playlistNameText("No playlist!");
      } else {
        return GridView.builder(
          itemCount: snapshot.data!.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust crossAxisCount here
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (index < snapshot.data!.length) {
              final playlist = snapshot.data![index];
              return GestureDetector(
                onTap: () async {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return showDialogWidget(
                              context,
                              playlist['playlist_name'],
                              playlist['playlist_id'],
                              userImage,
                              userName);
                        },
                      );
                    },
                  );
                },
                child: showPlaylistItems(
                  playlist['playlist_content'],
                  playlist['playlist_name'],
                ),
              );
            } else {
              return isMe == true
                  ? createPlaylistButton(createPlaylistDialog!)
                  : const SizedBox();
            }
          },
        );
      }
    },
  );
}

// Selected playlist contents
Widget showDialogWidget(BuildContext context, String playlistName,
    String playlistID, String userImage, String userName) {
  return AlertDialog(
    content: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircleAvatar(
                      foregroundImage: NetworkImage(userImage),
                      backgroundImage: const AssetImage(
                          "assets/images/blank_profile_image.dart"),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: playlistCreatorText(userName),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: playlistTimeText(playlistName),
                      ),
                    ],
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: getPlaylistTrackIDs(playlistID),
              builder: (context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: customLoad(context));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final trackIds = snapshot.data!;
                  return FutureBuilder(
                    future: getTrackInfo(trackIds),
                    builder: (context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: customLoad(context));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final trackInfoList = snapshot.data!;
                        return SizedBox(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(), // Disable ListView scrolling
                            shrinkWrap: true,
                            itemCount: trackInfoList.length,
                            itemBuilder: (context, index) {
                              final trackInfo = trackInfoList[index];
                              return ListTile(
                                title: Text(trackInfo['name']),
                                subtitle: Text(trackInfo['albumName']),
                                leading: Image.network(trackInfo['imageUrl']),
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: const Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

// Show tracks inside created playlists
Widget showPlaylistItems(List<dynamic> trackIDs, String playlistName) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 10),
      Expanded(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: 75),
          itemCount: trackIDs.length > 4 ? 4 : trackIDs.length,
          itemBuilder: (context, index) {
            return FutureBuilder<String>(
              future: fetchTrackImages(trackIDs[index]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.grey.withOpacity(0.2),
                    child: Center(
                      child: customLoad(context),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    color: Colors.grey.withOpacity(0.2),
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      image: DecorationImage(
                        image: snapshot.data == null
                            ? const AssetImage("blank_playlist_imagre.jpg")
                                as ImageProvider
                            : NetworkImage(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
      playlistNameText(playlistName)
    ],
  );
}

// Show track images
Future<String> fetchTrackImages(String trackId) async {
  String accessToken = await getAuthToken();
  String apiUrl = 'https://api.spotify.com/v1/tracks/$trackId';

  final response = await http.get(Uri.parse(apiUrl), headers: {
    'Authorization': 'Bearer $accessToken',
  });

  if (response.statusCode == 200) {
    final Map<String, dynamic> trackData = json.decode(response.body);

    final imageUrl = trackData['album']['images'][0]['url'];
    return imageUrl;
  } else {
    if (kDebugMode) {
      print(response.body);
    }
    throw Exception('Failed to load track image');
  }
}

// Show all track informations
Future<List<Map<String, dynamic>>> getTrackInfo(List<String> trackIds) async {
  final accessToken = await getAuthToken();
  final url = 'https://api.spotify.com/v1/tracks?ids=${trackIds.join(',')}';

  final response = await http.get(Uri.parse(url), headers: {
    'Authorization': 'Bearer $accessToken',
  });

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<Map<String, dynamic>> trackInfoList = [];

    for (final track in data['tracks']) {
      if (track != null &&
          track['album'] != null &&
          track['album']['images'] != null) {
        final String name = track['name'] ?? 'Unknown';
        final String imageUrl = track['album']['images'][0]['url'] ?? '';
        final String albumName = track['album']['name'] ?? '';

        trackInfoList.add({
          'name': name,
          'imageUrl': imageUrl,
          'albumName': albumName,
        });
      }
    }

    return trackInfoList;
  } else {
    throw Exception('Failed to load track information: ${response.statusCode}');
  }
}
