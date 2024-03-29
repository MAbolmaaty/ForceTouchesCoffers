import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:force_touches_financial/src/models/coffers_response_model.dart';
import 'package:force_touches_financial/src/utils/networking/app_url.dart';
import 'package:http/http.dart';

enum CoffersLoading {
  Loading,
  Succeed,
  Failed,
}

class CoffersApi with ChangeNotifier {
  CoffersLoading _coffersLoading = CoffersLoading.Loading;
  CoffersResponseModel _coffersResponseModel;
  bool _logout = false;

  CoffersLoading get coffersLoading => _coffersLoading;

  CoffersResponseModel get coffersResponseModel => _coffersResponseModel;

  bool get logout => _logout;

  Future<Map<String, dynamic>> fetchData(String apiToken) async {
    var result;

    final Map<String, String> headers = {'Authorization': 'Bearer $apiToken'};

    Response response;
    try {
      response = await get(Uri.parse(AppUrl.force_touches_coffers_url),
          headers: headers);
    } on Exception catch (e) {
      e.toString();
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      _coffersResponseModel = CoffersResponseModel.fromJson(responseData);
      _coffersLoading = CoffersLoading.Succeed;
      notifyListeners();

      result = {'status': true, 'data': _coffersResponseModel};
    } else {
      _coffersLoading = CoffersLoading.Failed;
      notifyListeners();
      result = {'status': false, 'data': responseData};
    }

    return result;
  }

  void loggingOut(){
    _logout = true;
    notifyListeners();
  }
}
