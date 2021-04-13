import 'package:force_touches_financial/src/models/authentication_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(
      AuthenticationResponseModel authenticationResponseModel) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString('api_token', authenticationResponseModel.jwt);
    sharedPreferences.setInt(
        'user_id', authenticationResponseModel.user.sId);
    sharedPreferences.setString(
        'username', authenticationResponseModel.user.username);
    sharedPreferences.setString(
        'email', authenticationResponseModel.user.email);

    return true;
  }

  Future<AuthenticationResponseModel> getUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    String apiToken = sharedPreferences.get('api_token');
    int userId = sharedPreferences.get('user_id');
    String username = sharedPreferences.getString('username');
    String email = sharedPreferences.getString('email');

    return AuthenticationResponseModel(
        jwt: apiToken,
        user: User(sId: userId, username: username, email: email));
  }

  Future<bool> removeUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.remove('api_token');
    sharedPreferences.remove('user_id');
    sharedPreferences.remove('username');
    return sharedPreferences.remove('email');
  }
}
