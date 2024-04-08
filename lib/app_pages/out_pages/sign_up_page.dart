import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:musiki/app_pages/out_pages/login_page.dart';
import 'package:musiki/custom_designs/custom_color.dart';
import 'package:musiki/custom_functions/design_functions.dart';
import 'package:musiki/custom_functions/supabase_functions.dart';

import '../../custom_designs/custom_button.dart';
import '../../custom_designs/custom_dialog.dart';
import '../../custom_designs/custom_text.dart';
import '../../custom_designs/custom_text_field.dart';
import '../../custom_designs/custom_toast.dart';
import '../../custom_functions/user_model.dart';
import '../../main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  DateTime? _selectedDate;
  String? _selectedCountry;
  // Insert user informations to users table & save user ID to locale
  _saveUserInfoIntoAppWhenSignedUp(uid, mail) async {
    UserModel userModel = UserModel();

    userModel.userID = uid;
    userModel.userMail = mail;
    userModel.userName = _nameEditingController.text;
    userModel.userMail = _emailEditingController.text;
    userModel.userProfileImage = "";
    userModel.userCoverImage = "";
    userModel.userBio = "Hi, I am using Musiki!";
    userModel.userCountry = _selectedCountry;
    userModel.userDateOfBirth =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedDate!);

    await supabase.from("users").insert(userModel.toMap());
  }

  // Sign up user
  Future<void> _signUp(String email, String password) async {
    bool valid = await userMailCheck(_emailEditingController.text);
    if (!valid) {
      warnToast("The email is already being used by another account.");
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedCountry != null) {
      if (mounted) {
        try {
          await supabase.auth
              .signUp(
                email: email,
                password: password,
              )
              .then(
                (value) async => {
                  await _saveUserInfoIntoAppWhenSignedUp(
                      value.user!.id, value.user!.email),
                  if( context.mounted){Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  )}
                },
              );
          successToast("The account has been created.");
        } catch (e) {
          if (kDebugMode) {
            print("An unexpected error occurred while sign up: $e");
          }
          failToast("Unexpected error.");
          if (context.mounted) {
            Navigator.pop(context);
          }        }
      }
    } else if (_selectedDate == null || _selectedCountry == null) {
      failToast("Birth of date and country cannot be left blank.");
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        Navigator.pop(context);
      }    }
  }

  // Select date picker
  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    return picked;
  }

  // Update selected date
  void _pickDate() async {
    DateTime? date = await _selectDate(context);
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image = Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Image.asset(
          "assets/images/logo.png",
          width: 200,
          height: 200,
        ),
      ),
    );
    //Name Field
    Widget nameField = welcomeTextField(
        _nameEditingController,
        RegExp(r'^.{3,20}$'),
        "Name & Surname",
        [],
        Iconsax.edit,
        TextInputAction.next,
        TextInputType.name,
        false);

    //Country Field
    Widget countryField = Container(
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
          items: countryContents().map((String value) {
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

    //Date of Birth Field
    Widget dateOfBirthField = shortButton(
      buttonText: "Date of Birth",
      onPressed: _pickDate,
    );

    //E- Mail Field
    Widget emailField = welcomeTextField(
        _emailEditingController,
        RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]"),
        "Email",
        [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
        Iconsax.sms,
        TextInputAction.next,
        TextInputType.emailAddress,
        false);

    //Password Field
    Widget passwordField = welcomeTextField(
        _passwordEditingController,
        RegExp(r'^.{6,}$'),
        "Password",
        [
          FilteringTextInputFormatter.deny(RegExp('[ ]')),
        ],
        Iconsax.key,
        TextInputAction.done,
        TextInputType.visiblePassword,
        true);

    //Sign Up Button
    Widget signUpButton = longButton(() async {
      FocusScope.of(context).requestFocus(FocusNode());
      showProgressDialog(context, "Please wait...");
      await _signUp(
          _emailEditingController.text, _passwordEditingController.text);
    }, "Sign Up", Colors.green.shade800, context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 50.0, left: 50, bottom: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      image,
                      welcomeTitleText("Join Us"),
                      const SizedBox(
                        height: 18,
                      ),
                      nameField,
                      const SizedBox(
                        height: 20,
                      ),
                      countryField,
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dateOfBirthField,
                          Text(
                            _selectedDate != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate!)
                                : 'Select a date',
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      emailField,
                      const SizedBox(height: 20),
                      passwordField,
                      const SizedBox(
                        height: 20,
                      ),
                      signUpButton,
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          welcomeFaintText('Do you have an account?', context),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: welcomeActionText("Login"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
