import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:musiki/custom_designs/custom_color.dart';
import 'package:musiki/custom_designs/custom_images.dart';
import 'package:musiki/custom_designs/custom_text.dart';
import 'package:musiki/custom_functions/design_functions.dart';

import '../../custom_functions/post_modules.dart';
import '../../custom_functions/spotify_modules.dart';
import '../../custom_functions/supabase_functions.dart';

class OtherUserPage extends StatefulWidget {
  final String userID;

  const OtherUserPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<OtherUserPage> createState() => _OtherUserPageState();
}

class _OtherUserPageState extends State<OtherUserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _profileImage = "";
  String _coverImage = "";
  String _name = "";
  String _bio = "";
  String _country = "";
  DateTime? _dateOfBirth;
  bool _userInformationLoaded = false; // Declare _userInformationLoaded here

  @override
  void initState() {
    super.initState();
    fetchUserInfo(widget.userID, updateUserInformation);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
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

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.index == 1) {
      sharedContents(widget.userID, false);
    } else if (_tabController.index == 2) {}
    showPlaylists(widget.userID, false, null, _profileImage, _name);
  }

  @override
  Widget build(BuildContext context) {
    return _userInformationLoaded == false
        ? customLoad(context)
        : Stack(
            children: [
              DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: backgroundColor(),
                  appBar: AppBar(
                    backgroundColor: Colors.black,
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
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
                          ],
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: _tabController,
                        children: [
                          Center(child: sharedContents(widget.userID, false)),
                          Center(
                              child: showPlaylists(widget.userID, false, null,
                                  _profileImage, _name)),
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
