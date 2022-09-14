import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:social_media_login/HomeScreen.dart';
import 'package:social_media_login/LoginPage.dart';
import 'package:social_media_login/provider.dart';

late SharedPreferences _sharedPreferences;
bool isLoggedIn = false;
void initializePrefs() async {
  _sharedPreferences = await SharedPreferences.getInstance();
  isLoggedIn = _sharedPreferences.getBool('isLoggedIn') ?? false;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  initializePrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Social Media Login',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
              ),
              elevation: 0,
              shadowColor: Colors.white,
              color: Color(0xFF6A61E2),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xFF6A61E2),
                statusBarIconBrightness: Brightness.light,
                systemStatusBarContrastEnforced: true,
              ),
            ),
            scaffoldBackgroundColor: Color(0xFFF9F8FE),
            textTheme: TextTheme(
              displayLarge: TextStyle(
                color: Color(0xFF0F0B3E),
                fontWeight: FontWeight.bold,
              ),
              displayMedium: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              displaySmall: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF5F54DE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: (isLoggedIn) ? HomeScreen() : LoginPage(),
        );
      }),
    );
  }
}
