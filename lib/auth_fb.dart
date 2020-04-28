//facebook login
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class AuthServiceFB {
  bool isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  AuthServiceFB();

  Future loginWithFB() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        userProfile = profile;
        isLoggedIn = true;
        break;

      case FacebookLoginStatus.cancelledByUser:
        isLoggedIn = false;
        break;
      case FacebookLoginStatus.error:
        isLoggedIn = false;
        break;
    }
  }

  void logout() {
    facebookLogin.logOut();
    isLoggedIn = false;
  }
}

final AuthServiceFB authServiceFB = AuthServiceFB();
