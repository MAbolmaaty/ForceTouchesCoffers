import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:force_touches_financial/src/models/authentication_response_model.dart';
import 'package:force_touches_financial/src/utils/networking/app_url.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

enum Status {
  NotLoggedIn,
  LoggedIn,
  LoggingIn,
}

enum PasswordVisibility {
  PasswordVisible,
  PasswordHidden,
}

class AuthenticationApi with ChangeNotifier {

  Status _loggedInStatus = Status.NotLoggedIn;
  PasswordVisibility _passwordVisibility = PasswordVisibility.PasswordHidden;

  Status get loggedInStatus => _loggedInStatus;
  PasswordVisibility get passwordVisibility => _passwordVisibility;


  Future<Map<String, dynamic>> login(String identifier, String password) async {
    var result;

    final Map<String, dynamic> requestBody = {
      'identifier': identifier,
      'password': password
    };

    _loggedInStatus = Status.LoggingIn;
    notifyListeners();

    Map<String, String> headers = {"Content-Type": "application/json"};

    Response response;
    try {
      response = await post(Uri.parse(AppUrl.login_url),
          headers: headers, body: json.encode(requestBody));
    } on Exception catch (e) {
      e.toString();
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      AuthenticationResponseModel authenticationResponseModel =
          AuthenticationResponseModel.fromJson(responseData);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {
        'status': true,
        'data': authenticationResponseModel,
      };
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'data': json.decode(response.body)
      };
    }
    return result;
  }

  void changePasswordVisibility() {
    if (_passwordVisibility == PasswordVisibility.PasswordHidden) {
      _passwordVisibility = PasswordVisibility.PasswordVisible;
      notifyListeners();
    } else {
      _passwordVisibility = PasswordVisibility.PasswordHidden;
      notifyListeners();
    }
  }
}
