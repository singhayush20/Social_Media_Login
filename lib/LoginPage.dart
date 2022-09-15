import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_login/HomeScreen.dart';
import 'package:social_media_login/constants.dart';
import 'package:social_media_login/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AccessToken? _accessToken;
  late SharedPreferences _sharedPreferences;
  bool isLoggedIn = false;
  Future<void> googleSignIn(UserProvider provider) async {
    print('Signing Option chosen: Google');
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      print('Google Sign In Result: $result');
      if (result != null) {
        print('Current user: ${_googleSignIn.currentUser}');
        provider.setLoginMethod(LoginMethod.google);
        provider.setLoginDetails({
          'displayName': result.displayName,
          'email': result.email,
          'photoUrl': result.photoUrl
        });
        _sharedPreferences.setBool('isLoggedIn', true);
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } catch (e) {
      print('Error occurred while logging in with google ${e.toString()}');
    }
  }

  Future<void> _facebookSignIn(UserProvider provider) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      print('facebook login result: $result');
      if (result.status == LoginStatus.success) {
        _accessToken = result.accessToken;
        final userData = await FacebookAuth.instance.getUserData();
        print('facebook user data: $userData');
        provider.setLoginMethod(LoginMethod.facebook);
        provider.setLoginDetails({
          'displayName': userData['name'],
          'email': userData['email'],
          'photoUrl': userData['picture']['data']['url'],
        });
        _sharedPreferences.setBool('isLoggedIn', true);
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    initializePrefs();
  }

  void initializePrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    isLoggedIn = _sharedPreferences.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = Provider.of<UserProvider>(context);

    final screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.15,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "Social Media Authentication",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  child: FittedBox(
                    child: Image.asset(
                      'Images/LoginPage/Login Page.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                ),
                height: screenHeight * 0.2,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "Choose a Login Method",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.4,
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color(0xFF0F0B3E),
                    ),
                  ],
                  color: Color(0xFF5F54DE),
                  border: Border.all(
                    color: Color(0xFF403BD6),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _facebookSignIn(provider);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: Icon(
                            FontAwesomeIcons.facebook,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        flex: 5,
                        child: FittedBox(
                          child: Text(
                            'Facebook',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Flexible(
              child: Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.4,
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color(0xFF0F0B3E),
                    ),
                  ],
                  color: Color(0xFF5F54DE),
                  border: Border.all(
                    color: Color(0xFF403BD6),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    googleSignIn(provider);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          child: Icon(
                            FontAwesomeIcons.google,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        flex: 5,
                        child: FittedBox(
                          child: Text(
                            'Google',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
