import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:musiki/custom_designs/custom_color.dart';
import 'package:musiki/custom_designs/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 import '../../custom_designs/custom_button.dart';
import '../../custom_designs/custom_text.dart';
import '../../custom_designs/custom_toast.dart';
import '../../custom_functions/account_shared_preferences.dart';
import '../../main.dart';
import '../in_pages/navbar.dart';
import 'sign_up_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();

  late StreamSubscription<AuthState> _authStateSubscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  // Sign in user & save user as logged in
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),

        );

        if (mounted) {
          successToast("Logging in.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Navbar(),
            ),
          );
          AccountSharedPreferences.saveUserLoggedInSharedPreference(true);
        }
      }  catch (e) {
        if (kDebugMode) {
          print("An unexpected error occurred while logging in: $e");
        }
        failToast("Invalid user.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [

      Scaffold(
          backgroundColor: backgroundColor(),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(  top: 150),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        welcomeTitleText("Welcome"),
                        const SizedBox(
                          height: 18,
                        ),
                        welcomeTextField(
                            _emailController,
                            RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]"),
                            "Email",
                            [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                            Iconsax.sms,
                            TextInputAction.next,
                            TextInputType.emailAddress,
                            false),
                        const SizedBox(
                          height: 30,
                        ),
                        welcomeTextField(
                            _passwordController,
                            RegExp(r'^.{6,}$'),
                            "Password",
                            [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                            Iconsax.key,
                            TextInputAction.done,
                            TextInputType.visiblePassword,
                            true),
                        const SizedBox(
                          height: 25,
                        ),
                        longButton(() {
                          _signIn();
                        }, "Login", Colors.green.shade800, context),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            welcomeFaintText("Don't you have an account?", context),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const SignUpPage()));
                              },
                              child: welcomeActionText("Sign Up"),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
     ]);
  }
}
