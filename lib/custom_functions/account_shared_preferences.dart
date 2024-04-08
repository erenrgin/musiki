import 'package:shared_preferences/shared_preferences.dart';

class AccountSharedPreferences {
  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';

  //Save user logged statues to shared preference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }


  //Get user logged statues from shared preference
  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

}
