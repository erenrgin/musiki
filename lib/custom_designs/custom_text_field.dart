import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

// Text field for login and sign up pages
welcomeTextField(
    TextEditingController controller,
    RegExp regex,
    String content,
    List<TextInputFormatter> inputFormatter,
    icon,
    TextInputAction action,
    TextInputType inputType,
    bool isPassword) {
  bool isObscured = true;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return TextFormField(
      keyboardType: inputType,
      style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontStyle: FontStyle.normal),
      autofocus: false,
      controller: controller,
      inputFormatters: inputFormatter,
      obscureText: isPassword == true ? isObscured : false,
      validator: (value) {
        if (value!.isEmpty) {
          return ("$content cannot be left blank.");
        }

        if (!regex.hasMatch(value)) {
          return ("Please enter a valid $content.");
        }
        return null;
      },
      onSaved: (value) {
        controller.text = value!;
      },
      textInputAction: action,
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade700,
        labelText: content,
        labelStyle: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontStyle: FontStyle.normal),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: isObscured
                    ? const Icon(
                        Iconsax.eye_slash,
                        color: Colors.white70,
                      )
                    : const Icon(
                        Iconsax.eye,
                        color: Colors.white70,
                      ),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : null,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xff280000),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xff280000),
          ),
        ),
      ),
    );
  });
}

Widget shareMediaTextField(TextEditingController shareContent, VoidCallback onPress) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          textAlign: TextAlign.start,
          minLines: 1,
          maxLines: 3,
          controller: shareContent,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'What do you think?',
            hintStyle: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.green.shade50,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Iconsax.gallery,color: Colors.green,), // You can change the icon as needed
        onPressed: onPress,
      ),
    ],
  );
}
editTextField(
    TextEditingController controller,
    RegExp regexp,
    String content,
    List<TextInputFormatter> inputFormatter,
    icon,
    TextInputAction action,
    TextInputType inputType,
    String info) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return TextFormField(
      keyboardType: inputType,
      style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontStyle: FontStyle.normal),
      autofocus: false,
      controller: controller,
      inputFormatters: inputFormatter,
      validator: (value) {
        RegExp regex = regexp;
        if (value!.isEmpty) {
          controller.text = info;
        } else if (!regex.hasMatch(value)) {
          Navigator.pop(context);

          return ("Please enter a valid $content.");
        }
        return null;
      },
      onSaved: (value) {
        controller.text = value!;
      },
      textInputAction: action,
      decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white70
              : Colors.black12,
          hintText: info,
          labelText: content,
          labelStyle: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontStyle: FontStyle.normal),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.green.shade900
                : const Color(0xff280000),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.green.shade900
                    : const Color(0xff280000),
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.green.shade900
                    : const Color(0xff280000),
              ))),
    );
  });
}

playlistNameTextField(
    TextEditingController controller,
    List<TextInputFormatter> inputFormatter,
    icon,
    TextInputAction action,
    TextInputType inputType,
    String info) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return TextFormField(
      keyboardType: inputType,
      style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontStyle: FontStyle.normal),
      autofocus: false,
      controller: controller,
      inputFormatters: inputFormatter,
      onSaved: (value) {
        controller.text = value!;
      },
      textInputAction: action,
      decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white70
              : Colors.black12,
          hintText: info,
          labelStyle: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontStyle: FontStyle.normal),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.green.shade900
                : const Color(0xff280000),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.green.shade900
                    : const Color(0xff280000),
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.green.shade900
                    : const Color(0xff280000),
              ))),
    );
  });
}

playListSearchTextField(
  TextEditingController controller,
  icon,
  TextInputAction action,

  TextInputType inputType,
  void Function(String)  onChanged
) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return TextFormField(
      keyboardType: inputType,
      style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
          fontStyle: FontStyle.normal),
      autofocus: false,
      controller: controller,
      onSaved: (value) {
        controller.text = value!;
      },
      onChanged: onChanged,
      textInputAction: action,
      decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white70
              : Colors.black12,
          labelStyle: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontStyle: FontStyle.normal),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.green.shade900
                : const Color(0xff280000),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.green.shade900
                    : const Color(0xff280000),
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.green.shade900
                    : const Color(0xff280000),
              ))),
    );
  });
}
