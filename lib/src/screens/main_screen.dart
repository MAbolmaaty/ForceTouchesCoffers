import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:force_touches_financial/app_theme.dart';
import 'package:force_touches_financial/src/screens/login_screen.dart';
import 'package:force_touches_financial/src/utils/networking/coffers_api.dart';
import 'package:force_touches_financial/src/utils/preferences/user_preferences.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => MainScreen(),
      );

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final CoffersApi coffersApi = CoffersApi();

  Future<Null> _fetchData() {
    return UserPreferences()
        .getUser()
        .then((authenticationResponseModel) async {
      await coffersApi.fetchData(authenticationResponseModel.jwt);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    return ChangeNotifierProvider(
        create: (context) => coffersApi,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: AppTheme.kPrimaryColor,
            ),
            backgroundColor: AppTheme.kPrimaryColor,
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child:
                    Consumer<CoffersApi>(builder: (context, coffersApi, child) {
                  if (coffersApi.coffersLoading == CoffersLoading.Failed) {
                    UserPreferences().removeUser().then((value) =>
                        Navigator.of(context).pushAndRemoveUntil(
                            LoginScreen.route(), (route) => false));
                  }
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context).lastUpdate,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Cairo'),
                                  ),
                                  Text(
                                  DateFormat('yyyy/MM/dd').format(DateTime.now()),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Cairo'),
                                  ),
                                  Text(
                                    DateFormat('h:mm').format(DateTime.now()),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Cairo'),
                                  ),
                                ]),
                            GestureDetector(
                              onTap: () {
                                coffersApi.loggingOut();
                                UserPreferences().removeUser().then((value) =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                        LoginScreen.route(), (route) => false));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: coffersApi.logout,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          backgroundColor:
                                              AppTheme.kPrimaryColor,
                                          strokeWidth: 2,
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.white)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).logout,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: AppLocalizations.of(context)
                                                .localeName ==
                                            'ar'
                                        ? Image.asset(
                                            'assets/images/LOGOUT_AR.png',
                                          )
                                        : Image.asset(
                                            'assets/images/LOGOUT_EN.png',
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      Divider(
                        indent: 16.0,
                        endIndent: 16.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      ///////////////////////////////// Salaries
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            TextFormField(
                              maxLines: 1,
                              enabled: false,
                              initialValue: " ",
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 11, bottom: 11, left: 16, right: 16),
                                labelText:
                                    AppLocalizations.of(context).salaries,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                ),
                                alignLabelWithHint: true,
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: Text(
                                  coffersApi.coffersLoading ==
                                          CoffersLoading.Succeed
                                      ? coffersApi.coffersResponseModel.salaries
                                      : '...',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Cairo'),
                                ),
                              ),
                            ),
                            Align(
                              alignment:
                                  AppLocalizations.of(context).localeName ==
                                          'ar'
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child: Container(
                                margin:
                                    EdgeInsets.only(right: 16.0, left: 16.0),
                                child: Text(
                                  AppLocalizations.of(context).saudiCurrency,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Cairo'),
                                ),
                              ),
                            ),
                            Align(
                              alignment:
                                  AppLocalizations.of(context).localeName ==
                                          'ar'
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin:
                                    EdgeInsets.only(right: 16.0, left: 16.0),
                                child: Text(
                                  coffersApi.coffersLoading ==
                                          CoffersLoading.Succeed
                                      ? coffersApi
                                          .coffersResponseModel.salariesMonth
                                      : '...',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Cairo',
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ///////////////////////////////// Bills
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            TextFormField(
                              maxLines: 1,
                              enabled: false,
                              initialValue: " ",
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 11, bottom: 11, left: 16, right: 16),
                                labelText: AppLocalizations.of(context).bills,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 14,
                                ),
                                alignLabelWithHint: true,
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: Text(
                                  coffersApi.coffersLoading ==
                                          CoffersLoading.Succeed
                                      ? coffersApi.coffersResponseModel.bills
                                      : '...',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment:
                                  AppLocalizations.of(context).localeName ==
                                          'ar'
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child: Container(
                                margin:
                                    EdgeInsets.only(right: 16.0, left: 16.0),
                                child: Text(
                                  AppLocalizations.of(context).saudiCurrency,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ///////////////////////////////// Treasury
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            TextFormField(
                              maxLines: 1,
                              enabled: false,
                              initialValue: " ",
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 11, bottom: 11, left: 16, right: 16),
                                labelText:
                                    AppLocalizations.of(context).treasury,
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 14,
                                ),
                                alignLabelWithHint: true,
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: Text(
                                  coffersApi.coffersLoading ==
                                          CoffersLoading.Succeed
                                      ? coffersApi.coffersResponseModel.treasury
                                      : '...',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment:
                                  AppLocalizations.of(context).localeName ==
                                          'ar'
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child: Container(
                                margin:
                                    EdgeInsets.only(right: 16.0, left: 16.0),
                                child: Text(
                                  AppLocalizations.of(context).saudiCurrency,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      Divider(
                        indent: 16.0,
                        endIndent: 16.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///////////////////////////////// Ibrahim
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16.0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                TextFormField(
                                  maxLines: 1,
                                  enabled: false,
                                  initialValue: " ",
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 56,
                                        bottom: 56,
                                        left: 16,
                                        right: 16),
                                    labelText:
                                        AppLocalizations.of(context).ibrahim,
                                    prefixIcon: SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  0.4) *
                                              0.2,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                      fontSize: 14,
                                    ),
                                    alignLabelWithHint: true,
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Text(
                                      coffersApi.coffersLoading ==
                                              CoffersLoading.Succeed
                                          ? coffersApi.coffersResponseModel
                                              .ibrahimTreasury
                                          : '...',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 48.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .saudiCurrency,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///////////////////////////////// Abdelaziz
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16.0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                TextFormField(
                                  maxLines: 1,
                                  enabled: false,
                                  initialValue: " ",
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 56,
                                        bottom: 56,
                                        left: 16,
                                        right: 16),
                                    labelText:
                                        AppLocalizations.of(context).abdelaziz,
                                    prefixIcon: SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  0.4) *
                                              0.2,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                      fontSize: 14,
                                    ),
                                    alignLabelWithHint: true,
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Text(
                                      coffersApi.coffersLoading ==
                                              CoffersLoading.Succeed
                                          ? coffersApi.coffersResponseModel
                                              .abdelazizTreasury
                                          : '...',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 48.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .saudiCurrency,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///////////////////////////////// Bahaa
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16.0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                TextFormField(
                                  maxLines: 1,
                                  enabled: false,
                                  initialValue: " ",
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 56,
                                        bottom: 56,
                                        left: 16,
                                        right: 16),
                                    labelText:
                                        AppLocalizations.of(context).bahaa,
                                    prefixIcon: SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  0.4) *
                                              0.2,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                      fontSize: 14,
                                    ),
                                    alignLabelWithHint: true,
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Text(
                                      coffersApi.coffersLoading ==
                                              CoffersLoading.Succeed
                                          ? coffersApi.coffersResponseModel
                                              .bahaaTreasury
                                          : '...',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 48.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .saudiCurrency,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///////////////////////////////// Abdelrahman
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16.0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                TextFormField(
                                  maxLines: 1,
                                  enabled: false,
                                  initialValue: " ",
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 56,
                                        bottom: 56,
                                        left: 16,
                                        right: 16),
                                    labelText: AppLocalizations.of(context)
                                        .abdelrahman,
                                    prefixIcon: SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  0.4) *
                                              0.2,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                      fontSize: 14,
                                    ),
                                    alignLabelWithHint: true,
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Text(
                                      coffersApi.coffersLoading ==
                                              CoffersLoading.Succeed
                                          ? coffersApi.coffersResponseModel
                                              .abdelrahmanTreasury
                                          : '...',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 48.0),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .saudiCurrency,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      Divider(
                        indent: 16.0,
                        endIndent: 16.0,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                AppLocalizations.of(context).coffersTotal,
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                            Text(
                              coffersApi.coffersLoading ==
                                      CoffersLoading.Succeed
                                  ? coffersApi
                                      .coffersResponseModel.treasuryTotal
                                  : '...',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              AppLocalizations.of(context).saudiCurrency,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                    ],
                  );
                }),
              ),
            )));
  }
}
