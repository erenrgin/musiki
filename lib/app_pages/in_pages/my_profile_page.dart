import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:musiki/app_pages/out_pages/login_page.dart';
import 'package:musiki/custom_designs/custom_color.dart';
import 'package:musiki/custom_designs/custom_images.dart';
import 'package:musiki/custom_designs/custom_text.dart';
import 'package:musiki/custom_designs/custom_text_field.dart';
import 'package:musiki/custom_designs/custom_toast.dart';
import 'package:musiki/custom_functions/design_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom_functions/post_modules.dart';
import '../../custom_functions/spotify_modules.dart';
import '../../custom_functions/supabase_functions.dart';
import '../../main.dart';
import 'edit_profile_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _profileImage = "";
  String _coverImage = "";
  String _name = "";
  String _bio = "";
  String _country = "";
  DateTime? _dateOfBirth;
  bool _userInformationLoaded = false; // Declare _userInformationLoaded here
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _playlistNameController = TextEditingController();
  List<dynamic> _searchResults = [];
  final List<String> _selectedSongs = [];

  @override
  void initState() {
    super.initState();
    fetchUserInfo(user?.id, updateUserInformation);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
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
      _profileImage = profileImage;
      _coverImage = coverImage;
      _name = name;
      _bio = bio;
      _country = country;
      _dateOfBirth = dateOfBirth;
      _userInformationLoaded = userInformationLoaded;
    });
  }

  void _handleTabChange() {
    if (_tabController.index == 1) {
      sharedContents(user?.id, false);
    } else if (_tabController.index == 2) {
      showPlaylists(user?.id, true, () {
        _createPlaylistDialog();
      }, _profileImage,_name);
    } else if (_tabController.index == 3) {
      ratedContents(user?.id);
    }
  }

  void _createPlaylistDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text("Create Playlist"),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height *
                    0.6, // Adjust the height as needed
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      playlistNameTextField(
                          _playlistNameController,
                          [],
                          Iconsax.edit,
                          TextInputAction.next,
                          TextInputType.name,
                          "Playlist Name"),
                      const SizedBox(height: 10),
                      playListSearchTextField(
                          _searchController,
                          Iconsax.search_normal,
                          TextInputAction.done,
                          TextInputType.name, (String searchText) async {
                        List<dynamic> results =
                            await searchSong(_searchController.text);
                        setState(() {
                          _searchResults = results;
                        });
                      }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.4, // Adjust the height as needed
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResults.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      _searchResults[index]['album']['images']
                                          [0]['url'],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(_searchResults[index]['name']),
                              subtitle: Text(
                                  _searchResults[index]['artists'][0]['name']),
                              trailing: IconButton(
                                icon: Icon(
                                  _selectedSongs
                                          .contains(_searchResults[index]['id'])
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _selectedSongs
                                          .contains(_searchResults[index]['id'])
                                      ? Colors.red
                                      : null, // Use null for default color
                                ),
                                onPressed: () {
                                  final trackId = _searchResults[index]['id'];
                                  if (_selectedSongs.contains(trackId)) {
                                    _selectedSongs.remove(trackId);
                                  } else {
                                    _selectedSongs.add(trackId);
                                  }
                                  setState(() {});
                                  if (kDebugMode) {
                                    print(_selectedSongs);
                                  }
// Update the UI to reflect the change in favorite status
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    _searchController.clear();
                    _playlistNameController.clear();
                    _searchResults.clear();
                    _selectedSongs.clear();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  onPressed: _selectedSongs.isEmpty ||
                          _playlistNameController.text.isEmpty
                      ? () {
                          warnToast(
                              "To create a playlist, you must enter a playlist name and select at least 1 track.");
                        }
                      : () {
                          String playlistNameString =
                              _playlistNameController.text;
                          _searchController.clear();
                          _playlistNameController.clear();
                          _searchResults.clear();
                          savePlaylist(playlistNameString, _selectedSongs)
                              .then((value) {
                            _selectedSongs.clear();
                          });
                          Navigator.of(context).pop();
                          _refreshState();
                        },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }



  _refreshState() {
    setState(() {
      fetchUserInfo(user?.id, updateUserInformation);
      fetchPlaylists(user?.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _userInformationLoaded == false
        ? customLoad(context)
        : Stack(
            children: [
              DefaultTabController(
                length: 3,
                child: Scaffold(
                  backgroundColor: backgroundColor(),
                  appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.black,
                      title: appbarText("Profil"),
                      leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfile()))
                                .then((res) => _refreshState());
                          },
                          icon: const Icon(
                            Iconsax.user_edit,
                            color: Colors.green,
                          )),
                      actions: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  await pref.clear();
                                  supabase.auth.signOut();
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  }
                                },
                                icon: const Icon(
                                  Iconsax.logout,
                                  color: Colors.green,
                                )),
                          ],
                        ),
                      ]),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: imageProfileCombine(
                            context, _profileImage, _coverImage, _name),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, top: 10),
                        child: userNameText(_name),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: userBioText(_bio),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 40, top: 15),
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.flag,
                                color: Colors.white,
                              ),
                              userCountryAndDateOfBirthText(_country),
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(
                                Iconsax.calendar,
                                color: Colors.white,
                              ),
                              _dateOfBirth == null
                                  ? const Text("-")
                                  : userCountryAndDateOfBirthText(
                                      DateFormat('dd/MM/yyyy')
                                          .format(_dateOfBirth!))
                            ],
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: TabBar(
                          controller: _tabController,
                          dividerColor: Colors.white,
                          dividerHeight: 5,
                          labelColor: Colors.green.shade800,
                          labelStyle: const TextStyle(fontSize: 20),
                          unselectedLabelColor: Colors.white,
                          indicatorColor: Colors.white,
                          tabs: const [
                            Tab(text: 'Posts'),
                            Tab(text: 'Playlists'),
                            Tab(text: 'Ratings'),
                          ],
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: _tabController,
                        children: [
                          Center(child: sharedContents(user?.id, false)),
                          Center(
                              child: showPlaylists(user?.id, true, () {
                            _createPlaylistDialog();
                          }, _profileImage,_name)),
                          Center(child: ratedContents(user?.id)),
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
