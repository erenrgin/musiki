import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musiki/custom_designs/custom_color.dart';
import 'package:musiki/custom_designs/custom_text.dart';
import 'package:musiki/custom_tiles/search_tile.dart';

import '../../custom_functions/supabase_functions.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  SearchUserPageState createState() => SearchUserPageState();
}

class SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController _searchTextEditingController = TextEditingController();

  List _users = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> _searchUsers() async {
    try {
      searchUser(_searchTextEditingController.text).then((value) {
        setState(() {
          _users = value;
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error while searching user: $e");
      }
    }
  }

// Show Searched User Information
  Widget _searchList() {
    const SizedBox(
      height: 5,
    );
    if (_users.isNotEmpty && _searchTextEditingController.text != "") {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return searchUserTile(
                userName: _users[index]["name"],
                userID: _users[index]["uid"],
                userProfileImage: _users[index]["profile_image"],
                context: context);
          });
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor(),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: appbarText("Search User"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(15)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          onChanged: (val) {
                            setState(() {
                              _searchUsers();
                            });
                          },
                          controller: _searchTextEditingController,
                          decoration: InputDecoration(
                            hintText: "search user...",
                            hintStyle:
                                GoogleFonts.nunito(fontStyle: FontStyle.italic),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                _searchList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
