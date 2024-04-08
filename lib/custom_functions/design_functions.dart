import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import '../custom_designs/custom_toast.dart';

// Custom loading circle
customLoad(BuildContext context) {
  return const SpinKitRipple(
    color: Colors.white,
    size: 50.0,
  );
}

Future<File?> withGalleryEditProfile(
    PlatformFile? pickedImageFile,
    File? imageFile,
    BuildContext context ) async {
  try {
    FilePickerResult? result =   await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (result != null) {
      List<String> selectedFile = result.files.single.path!.split(".");

         if (selectedFile.last == "png" ||
            selectedFile.last == "jpg" ||
            selectedFile.last == "jpeg" ) {
          if (selectedFile.last != 'gif') {
            pickedImageFile = result.files.first;

            File img = File(pickedImageFile.path!);
            if (selectedFile.last != 'gif') {

               return img;
            }
          }
        } else {
          warnToast("Selected file is not an image file.");
        }

    }
    if ( context.mounted)
    {
      Navigator.of(context).pop();
    }    return null;
  } on PlatformException catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    if ( context.mounted)
    {
      Navigator.of(context).pop();
    }
    return null;
  }
}

Future<File?> withCamEditProfile(File? imageFile, BuildContext context, ) async {
  try {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (image == null) return null;

    File? img = File(image.path);

    return img;
  } on PlatformException catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
  return null;
}

List<String> countryContents(){
  return  [
    'Afghanistan',
    'Algeria',
    'Angola',
    'Argentina',
    'Australia',
    'Bangladesh',
    'Belarus',
    'Bolivia',
    'Botswana',
    'Brazil',
    'Burma (Myanmar)',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Democratic Republic of the Congo',
    'Egypt',
    'Ethiopia',
    'France',
    'Greenland (Denmark)',
    'India',
    'Indonesia',
    'Iran',
    'Kazakhstan',
    'Libya',
    'Madagascar',
    'Mali',
    'Mauritania',
    'Mexico',
    'Mongolia',
    'Mozambique',
    'Namibia',
    'Niger',
    'Nigeria',
    'Pakistan',
    'Peru',
    'Russia',
    'Saudi Arabia',
    'Somalia',
    'South Africa',
    'South Sudan',
    'Sudan',
    'Tanzania',
    'Türkiye',
    'Ukraine',
    'United States of America',
    'Venezuela',
    'Yemen'
  ];

}