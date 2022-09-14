import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:social_media_login/constants.dart';

class UserProvider with ChangeNotifier {
  String displayName = '';
  String email = '';
  String photoUrl = '';
  var image;
  LoginMethod? loginMethod = null;

  void setLoginMethod(LoginMethod method) {
    loginMethod = method;
    notifyListeners();
  }

  void setLoginDetails(Map<String, dynamic> loginDetails) {
    displayName = loginDetails['displayName'];
    email = loginDetails['email'];
    photoUrl = loginDetails['photoUrl'] ?? '';
    image = CachedNetworkImage(
      imageUrl: photoUrl,
      placeholder: (context, url) =>
          new Image.asset('Images/HomePage/DefaultProfileImage.jpg'),
      errorWidget: (context, url, error) =>
          new Image.asset('Images/HomePage/DefaultProfileImage.jpg'),
    );
    notifyListeners();
  }
}
