// Title size text with overflow handling
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

welcomeTitleText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 27,
      fontWeight: FontWeight.w700,
      color: Colors.green.shade600,
      fontStyle: FontStyle.normal,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Faint color text with overflow handling
welcomeFaintText(content, context) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white70,
      fontStyle: FontStyle.normal,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Action text with overflow handling
welcomeActionText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.green.shade600,
      fontStyle: FontStyle.normal,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Button text with overflow handling
dropdownText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Button text with overflow handling
buttonText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Promotion text with overflow handling
promotionText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
  );
}

// Appbar text with overflow handling
appbarText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 22.5,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Username text with overflow handling
userNameText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// User bio text with overflow handling
userBioText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 19,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// User country and date of birth text with overflow handling
userCountryAndDateOfBirthText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.white70,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Searching user name title text with overflow handling
searchTitleText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Post sender name text with overflow handling
postSenderNameText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Post type text with overflow handling
postTypeText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: Colors.white54,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Post content text with overflow handling
postContentText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Playlist name text with overflow handling
playlistNameText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Playlist creator text with overflow handling
playlistCreatorText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Playlist time text with overflow handling
playlistTimeText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

// Error content text with overflow handling
errorContentText(content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 17,
      color: Colors.red.shade200,
    ),
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}
