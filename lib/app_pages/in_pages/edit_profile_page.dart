import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:musiki/custom_designs/custom_text.dart';
import 'package:musiki/custom_designs/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../custom_designs/custom_button.dart';
import '../../custom_designs/custom_dialog.dart';
import '../../custom_designs/custom_toast.dart';
import '../../custom_functions/design_functions.dart';
import '../../main.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _newProfilePicLink = "";
  String _oldProfilePicLink = "";
  String _profilePicLink = "";
  String _newCoverPicLink = "";
  String _oldCoverPicLink = "";
  String _coverPicLink = "";
  String _oldName = "";
   String _oldBio = "";
   String _oldCountry = "";
  bool _isProfileImageSelected = false;
  bool _isCoverImageSelected = false;
  dynamic _profileImageFile;
  dynamic _coverImageFile;
  PlatformFile? _pickedProfileFile;
  PlatformFile? _pickedCoverFile;
  String? _selectedCountry;

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _bioEditingController = TextEditingController();


  @override
  void initState() {
    _fetchUserInfo();

    super.initState();
  }

  Future<void> _fetchUserInfo() async {
    PostgrestResponse<dynamic> response =
        await supabase.from('users').select().eq('uid', user?.id).execute();

    List<dynamic> data = response.data as List<dynamic>;

    if (data.isNotEmpty) {
      var userData = data.first;

      setState(() {
        _oldProfilePicLink = userData['profile_image'];
        _oldCoverPicLink = userData['cover_image'];
        _oldName = userData['name'];
         _oldBio = userData['bio'];
         _oldCountry = userData['country'];
      });
    }
  }

  //Check & Update Profile
  Future<void> _updateInfo() async {
    if (_formKey.currentState!.validate()) {
      if (_profileImageFile != null) {
        await _updateProfileImageToServer();
      }
      if (_coverImageFile != null) {
        await _updateCoverImageToServer();
      }

      await supabase.from('users').update({
        "name": _nameEditingController.text,
        "bio": _bioEditingController.text,
        "country":_selectedCountry ?? _oldCountry,
      }).eq('uid', user?.id);

      successToast("Profile updated!");
      if (context.mounted) {
        Navigator.of(context)
          ..pop(context)
          ..pop(context);
      }
    }
  }

  //Save Profile to Server
  Future<void> _updateProfileImageToServer() async {
    String path = await supabase.storage.from('images').upload(
          "profile_image/${"${user?.id}---${DateTime.now().toString()}".replaceAll(RegExp(r'\s+'), '')}",
          _profileImageFile!,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    String publicUrl = supabase.storage.from('').getPublicUrl(path);

    setState(() {
      _newProfilePicLink = publicUrl;

      _isProfileImageSelected = true;
    });

    if (_isProfileImageSelected == true) {
      _profilePicLink = _newProfilePicLink;
    } else {
      _profilePicLink = _oldProfilePicLink;
    }

    await supabase
        .from('users')
        .update({"profile_image": _profilePicLink}).eq('uid', user?.id);
    if (_isProfileImageSelected == true) {
      String oldImagePath = Uri.parse(_oldProfilePicLink)
          .path
          .replaceAll("/storage/v1/object/public//images/", "");

      await supabase.storage.from('images').remove([oldImagePath]);
    }
  }

  Future<void> _bottomSheetProfileImage() async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey.shade900,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(
                    child: SizedBox(
                      height: 4,
                      width: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            withGalleryEditProfile(_pickedProfileFile,
                                    _profileImageFile, context)
                                .then((value) {
                              setState(() {
                                _profileImageFile = value;
                                setState(() {});
                              });
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.green.shade100
                                  : Colors.green.shade900,
                            ),
                            height: 100,
                            width: 100,
                            child: Icon(
                              Iconsax.gallery,
                              size: 40,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.green
                                  : Colors.green.shade400,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            withCamEditProfile(
                              _profileImageFile,
                              context,
                            ).then((value) {
                              setState(() {
                                _profileImageFile = value;
                                setState(() {});
                              });
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.purple.shade100
                                  : Colors.purple.shade900,
                            ),
                            height: 100,
                            width: 100,
                            child: Icon(
                              Iconsax.camera,
                              size: 40,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.purple
                                  : Colors.purple.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Save Profile to Server
  Future<void> _updateCoverImageToServer() async {
    String path = await supabase.storage.from('images').upload(
          "cover_image/${"${user?.id}---${DateTime.now().toString()}".replaceAll(RegExp(r'\s+'), '')}.",
          _coverImageFile!,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    String publicUrl = supabase.storage.from('').getPublicUrl(path);

    setState(() {
      _newCoverPicLink = publicUrl;

      _isCoverImageSelected = true;
    });

    if (_isCoverImageSelected == true) {
      _coverPicLink = _newCoverPicLink;
    } else {
      _coverPicLink = _oldCoverPicLink;
    }

    await supabase
        .from('users')
        .update({"cover_image": _coverPicLink}).eq('uid', user?.id);

    if (_isCoverImageSelected == true) {
      String oldImagePath = Uri.parse(_oldCoverPicLink)
          .path
          .replaceAll("/storage/v1/object/public//images/", "");

      await supabase.storage.from('images').remove([oldImagePath]);
    }
  }

  //Show Options For Source of Cover Image
  Future<void> _bottomSheetCoverImage() async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey.shade900,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(
                    child: SizedBox(
                      height: 4,
                      width: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            withGalleryEditProfile(
                                    _pickedCoverFile, _coverImageFile, context)
                                .then((value) {
                              setState(() {
                                _coverImageFile = value;
                                setState(() {});
                              });
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.green.shade100
                                  : Colors.green.shade900,
                            ),
                            height: 100,
                            width: 100,
                            child: Icon(
                              Iconsax.gallery,
                              size: 40,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.green
                                  : Colors.green.shade400,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            withCamEditProfile(_coverImageFile, context)
                                .then((value) {
                              setState(() {
                                _coverImageFile = value;
                                setState(() {});
                              });
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.purple.shade100
                                  : Colors.purple.shade900,
                            ),
                            height: 100,
                            width: 100,
                            child: Icon(
                              Iconsax.camera,
                              size: 40,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.purple
                                  : Colors.purple.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Profile Image
  Widget _profileImage() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.green,
          radius: 80.0,
          backgroundImage: _profileImageFile == null
              ? NetworkImage(_oldProfilePicLink)
              : FileImage(
                  File(_profileImageFile!.path),
                ) as ImageProvider,
        ),
        Positioned(
          top: 15.0,
          right: 15.0,
          child: InkWell(
            onTap: () {
              _bottomSheetProfileImage();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green.shade100,
                boxShadow: const [
                  BoxShadow(color: Colors.green, spreadRadius: 3),
                ],
              ),
              child: const Icon(
                Iconsax.gallery_edit,
                color: Colors.black,
                size: 40.0,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget nameField = editTextField(
        _nameEditingController,
        RegExp(r'^.{3,20}$'),
        "Name",
        [],
        Iconsax.edit,
        TextInputAction.next,
        TextInputType.name,
        _oldName);

    Widget countryField =  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade700,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButton<String>(
          hint: _selectedCountry == null
              ? dropdownText('Select Country')
              : dropdownText(
            _selectedCountry!,
          ),
          borderRadius: BorderRadius.circular(15),
          isExpanded: true,
          items:  countryContents().map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (res) {
            setState(() {
              _selectedCountry = res;
            });
            if (kDebugMode) {
              print(_selectedCountry);
            }
          },
        ),
      ),
    );

    Widget bioField = editTextField(
        _bioEditingController,
        RegExp(r'^.{3,20}$'),
        "Bio",
        [],
        Iconsax.edit,
        TextInputAction.next,
        TextInputType.name,
        _oldBio);

    return Stack(children: [
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black54,
            centerTitle: true,
            title: appbarText("Profili Düzenle"),
            elevation: 0,
          ),
          body: SizedBox(
            width: double.maxFinite,
            child: NotificationListener<ScrollNotification>(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Stack(children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 220),
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _coverImageFile == null
                                      ? NetworkImage(_oldCoverPicLink)
                                      : FileImage(
                                          File(_coverImageFile!.path),
                                        ) as ImageProvider,
                                  fit: BoxFit.fitWidth,
                                ),
                                color: Colors.black,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              child: Wrap(children: [
                                Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 130),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 3),
                                          borderRadius:
                                              BorderRadius.circular(60),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: SizedBox(
                                              height: 175,
                                              width: 175,
                                              child: _profileImage()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          Positioned(
                            top: 15.0,
                            right: 15.0,
                            child: InkWell(
                              onTap: () {
                                _bottomSheetCoverImage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green.shade100,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.green, spreadRadius: 3),
                                  ],
                                ),
                                child: const Icon(
                                  Iconsax.gallery_edit,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 120,
                              ),
                              nameField,
                              const SizedBox(
                                height: 30,
                              ),
                              countryField,
                              const SizedBox(
                                height: 30,
                              ),
                              bioField,
                              const SizedBox(
                                height: 30,
                              ),
                              longButton(() async {
                                showProgressDialog(
                                    context, "Please wait...");
                                await _updateInfo();
                              }, "Save", Colors.green.shade700, context)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    ]);
  }
}
