import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:social_media_login/LoginPage.dart';
import 'package:social_media_login/constants.dart';
import 'package:social_media_login/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences _sharedPreferences;
  @override
  void initState() {
    initializePrefs();
  }

  void initializePrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> _signOutGoogle() async {
    print('Signing Out Google');
    GoogleSignIn _googleSignIn = GoogleSignIn();
    print('Current user: ${_googleSignIn.currentUser}');
    try {
      var result = await _googleSignIn.signOut();
      print('sign out result : $result');

      print('User logged out');
      _sharedPreferences.setBool('isLoggedIn', false);
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error occurred while signing out google: $e');
    }
  }

  void _signOutFacebook() async {
    print('Sign Out Facebook');
    try {
      await FacebookAuth.instance.logOut();
      _sharedPreferences.setBool('isLoggedIn', false);
      Navigator.popUntil(context, (route) => false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error occurred while logging out from facebook $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = Provider.of<UserProvider>(context);
    final screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media Demo'),
        actions: [
          TextButton(
            onPressed: () {
              if (provider.loginMethod == LoginMethod.google)
                _signOutGoogle();
              else if (provider.loginMethod == LoginMethod.facebook)
                _signOutFacebook();
            },
            child: Text(
              'Sign Out',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Container(
              height: screenHeight * 0.3,
              child: FittedBox(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: ClipOval(
                    child: provider.image,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Container(
              height: screenHeight * 0.1,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15.0,
                    color: Color(0xFF5046E5),
                  ),
                ],
                color: Color(0xFF6A61E2),
                border: Border.all(
                  color: Color(0xFF0F0B3E),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Text(
                      'Name:',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.loose,
                    child: Text(
                      '${provider.displayName}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Container(
              height: screenHeight * 0.1,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15.0,
                    color: Color(0xFF5046E5),
                  ),
                ],
                color: Color(0xFF6A61E2),
                border: Border.all(
                  color: Color(0xFF0F0B3E),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Text(
                      'Email:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.loose,
                    child: FittedBox(
                      child: Text(
                        '${provider.email}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
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
  }
}
