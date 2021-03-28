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
      await coffersApi
          .fetchData(authenticationResponseModel.jwt);
    });
  }

  bool isNegativeAmount(String amount) {
    return amount.contains(RegExp("- ?[0-9]|[0-9] ?-"));
  }

  String checkAmount(String amount) {
    amount = amount.replaceAll(" ", "");
    RegExp regExp = RegExp("[.|,]?\\d+[.|,]?");
    var splits = regExp.allMatches(amount).toList();
    String wholeNumber = "";
    for (var split in splits) {
      wholeNumber += split.group(0).toString();
    }
    if (parseAmount(wholeNumber) == null) wholeNumber = "...";

    return wholeNumber;
  }

  double parseAmount(String amount) {
    amount = amount.replaceAll(" ", "");
    RegExp regExp = RegExp("[.]?\\d+[.]?");
    bool isNegative = isNegativeAmount(amount);
    var splits = regExp.allMatches(amount).toList();
    String wholeNumber = "";
    for (var split in splits) {
      wholeNumber += split.group(0).toString();
    }
    double doubleAmount;
    try {
      doubleAmount = double.parse(wholeNumber);
    } on Exception catch (e) {
      print(wholeNumber);
      print(e.toString());
    }
    if (isNegative) {
      doubleAmount = doubleAmount * -1;
    }
    return doubleAmount;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    return ChangeNotifierProvider(
        create: (context) => coffersApi,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 0.0,
              elevation: 0.0,
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
                  String treasuryTotal = "";
                  if(coffersApi.coffersLoading == CoffersLoading.Succeed){
                    double doubleTreasuryTotal;
                    doubleTreasuryTotal = parseAmount(coffersApi.coffersResponseModel.ibrahimTreasury) +
                        parseAmount(coffersApi.coffersResponseModel.abdelazizTreasury) +
                        parseAmount(coffersApi.coffersResponseModel.bahaaTreasury) +
                        parseAmount(coffersApi.coffersResponseModel.abdelrahmanTreasury);
                    treasuryTotal = doubleTreasuryTotal.toString();
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
                                    DateFormat('yyyy/MM/dd')
                                        .format(DateTime.now()),
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
                            ElevatedButton(
                              onPressed: () {
                                coffersApi.loggingOut();
                                UserPreferences().removeUser().then((value) =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                        LoginScreen.route(), (route) => false));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppTheme.kPrimaryColor,
                                elevation: 0.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                child: coffersApi.coffersLoading ==
                                        CoffersLoading.Succeed
                                    ? Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Localizations.override(
                                            context: context,
                                            locale: const Locale('en'),
                                            child: Builder(builder:
                                                (BuildContext context) {
                                              return Text(
                                                checkAmount(coffersApi
                                                    .coffersResponseModel
                                                    .salaries),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Cairo'),
                                              );
                                            }),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Visibility(
                                            visible: (parseAmount(coffersApi
                                                        .coffersResponseModel
                                                        .salaries) !=
                                                    null) ==
                                                (parseAmount(coffersApi
                                                        .coffersResponseModel
                                                        .salaries) !=
                                                    0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: isNegativeAmount(
                                                          coffersApi
                                                              .coffersResponseModel
                                                              .salaries)
                                                      ? const Color(0xffC70F0F)
                                                      : const Color(0xff0FC73A),
                                                  shape: BoxShape.circle),
                                              child: isNegativeAmount(coffersApi
                                                      .coffersResponseModel
                                                      .salaries)
                                                  ? Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                      size: 14.0,
                                                    )
                                                  : Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 14.0,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '...',
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
                                child: coffersApi.coffersLoading ==
                                        CoffersLoading.Succeed
                                    ? Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Localizations.override(
                                            context: context,
                                            locale: const Locale('en'),
                                            child: Builder(builder:
                                                (BuildContext context) {
                                              return Text(
                                                checkAmount(coffersApi
                                                    .coffersResponseModel
                                                    .bills),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Cairo'),
                                              );
                                            }),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Visibility(
                                            visible: (parseAmount(coffersApi
                                                .coffersResponseModel
                                                .bills) !=
                                                null) ==
                                                (parseAmount(coffersApi
                                                    .coffersResponseModel
                                                    .bills) !=
                                                    0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: isNegativeAmount(
                                                          coffersApi
                                                              .coffersResponseModel
                                                              .bills)
                                                      ? const Color(0xffC70F0F)
                                                      : const Color(0xff0FC73A),
                                                  shape: BoxShape.circle),
                                              child: isNegativeAmount(coffersApi
                                                      .coffersResponseModel
                                                      .bills)
                                                  ? Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                      size: 14.0,
                                                    )
                                                  : Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 14.0,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '...',
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
                                child: coffersApi.coffersLoading ==
                                        CoffersLoading.Succeed
                                    ? Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Localizations.override(
                                            context: context,
                                            locale: const Locale('en'),
                                            child: Builder(builder:
                                                (BuildContext context) {
                                              return Text(
                                                checkAmount(coffersApi
                                                    .coffersResponseModel
                                                    .treasury),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Cairo'),
                                              );
                                            }),
                                          ),
                                          SizedBox(
                                            width: 4.0,
                                          ),
                                          Visibility(
                                            visible: (parseAmount(coffersApi
                                                .coffersResponseModel
                                                .treasury) !=
                                                null) ==
                                                (parseAmount(coffersApi
                                                    .coffersResponseModel
                                                    .treasury) !=
                                                    0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: isNegativeAmount(
                                                          coffersApi
                                                              .coffersResponseModel
                                                              .treasury)
                                                      ? const Color(0xffC70F0F)
                                                      : const Color(0xff0FC73A),
                                                  shape: BoxShape.circle),
                                              child: isNegativeAmount(coffersApi
                                                      .coffersResponseModel
                                                      .treasury)
                                                  ? Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                      size: 14.0,
                                                    )
                                                  : Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 14.0,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '...',
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
                                    child: coffersApi.coffersLoading ==
                                            CoffersLoading.Succeed
                                        ? Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Localizations.override(
                                                context: context,
                                                locale: const Locale('en'),
                                                child: Builder(builder:
                                                    (BuildContext context) {
                                                  return Text(
                                                    checkAmount(coffersApi
                                                        .coffersResponseModel
                                                        .ibrahimTreasury),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: 'Cairo'),
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                              Visibility(
                                                visible: (parseAmount(coffersApi
                                                    .coffersResponseModel
                                                    .ibrahimTreasury) !=
                                                    null) ==
                                                    (parseAmount(coffersApi
                                                        .coffersResponseModel
                                                        .ibrahimTreasury) !=
                                                        0.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: isNegativeAmount(
                                                              coffersApi
                                                                  .coffersResponseModel
                                                                  .ibrahimTreasury)
                                                          ? const Color(
                                                              0xffC70F0F)
                                                          : const Color(
                                                              0xff0FC73A),
                                                      shape: BoxShape.circle),
                                                  child: isNegativeAmount(
                                                          coffersApi
                                                              .coffersResponseModel
                                                              .ibrahimTreasury)
                                                      ? Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        )
                                                      : Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '...',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Cairo'),
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
                                    child: coffersApi.coffersLoading ==
                                            CoffersLoading.Succeed
                                        ? Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Localizations.override(
                                                context: context,
                                                locale: const Locale('en'),
                                                child: Builder(builder:
                                                    (BuildContext context) {
                                                  return Text(
                                                    checkAmount(coffersApi
                                                        .coffersResponseModel
                                                        .abdelazizTreasury),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: 'Cairo'),
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                              Visibility(
                                                visible: (parseAmount(coffersApi
                                                    .coffersResponseModel
                                                    .abdelazizTreasury) !=
                                                    null) ==
                                                    (parseAmount(coffersApi
                                                        .coffersResponseModel
                                                        .abdelazizTreasury) !=
                                                        0.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: isNegativeAmount(coffersApi
                                                              .coffersResponseModel
                                                              .abdelazizTreasury)
                                                          ? const Color(
                                                              0xffC70F0F)
                                                          : const Color(
                                                              0xff0FC73A),
                                                      shape: BoxShape.circle),
                                                  child: isNegativeAmount(
                                                          coffersApi
                                                              .coffersResponseModel
                                                              .abdelazizTreasury)
                                                      ? Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        )
                                                      : Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '...',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Cairo'),
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
                                    child: coffersApi.coffersLoading ==
                                            CoffersLoading.Succeed
                                        ? Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Localizations.override(
                                                context: context,
                                                locale: const Locale('en'),
                                                child: Builder(builder:
                                                    (BuildContext context) {
                                                  return Text(
                                                    checkAmount(coffersApi
                                                        .coffersResponseModel
                                                        .bahaaTreasury),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: 'Cairo'),
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                              Visibility(
                                                visible: (parseAmount(coffersApi
                                                    .coffersResponseModel
                                                    .bahaaTreasury) !=
                                                    null) ==
                                                    (parseAmount(coffersApi
                                                        .coffersResponseModel
                                                        .bahaaTreasury) !=
                                                        0.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: isNegativeAmount(
                                                              coffersApi
                                                                  .coffersResponseModel
                                                                  .bahaaTreasury)
                                                          ? const Color(
                                                              0xffC70F0F)
                                                          : const Color(
                                                              0xff0FC73A),
                                                      shape: BoxShape.circle),
                                                  child: isNegativeAmount(
                                                          coffersApi
                                                              .coffersResponseModel
                                                              .bahaaTreasury)
                                                      ? Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        )
                                                      : Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '...',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Cairo'),
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
                                    child: coffersApi.coffersLoading ==
                                            CoffersLoading.Succeed
                                        ? Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Localizations.override(
                                                context: context,
                                                locale: const Locale('en'),
                                                child: Builder(builder:
                                                    (BuildContext context) {
                                                  return Text(
                                                    checkAmount(coffersApi
                                                        .coffersResponseModel
                                                        .abdelrahmanTreasury),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: 'Cairo'),
                                                  );
                                                }),
                                              ),
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                              Visibility(
                                                visible: (parseAmount(coffersApi
                                                    .coffersResponseModel
                                                    .abdelrahmanTreasury) !=
                                                    null) ==
                                                    (parseAmount(coffersApi
                                                        .coffersResponseModel
                                                        .abdelrahmanTreasury) !=
                                                        0.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: isNegativeAmount(coffersApi
                                                              .coffersResponseModel
                                                              .abdelrahmanTreasury)
                                                          ? const Color(
                                                              0xffC70F0F)
                                                          : const Color(
                                                              0xff0FC73A),
                                                      shape: BoxShape.circle),
                                                  child: isNegativeAmount(coffersApi
                                                          .coffersResponseModel
                                                          .abdelrahmanTreasury)
                                                      ? Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        )
                                                      : Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 14.0,
                                                        ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '...',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Cairo'),
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
                      //////////////////////////// Treasury Total
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
                            coffersApi.coffersLoading == CoffersLoading.Succeed
                                ? Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Localizations.override(
                                        context: context,
                                        locale: const Locale('en'),
                                        child: Builder(
                                            builder: (BuildContext context) {
                                          return Text(
                                            checkAmount(treasuryTotal),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Cairo'),
                                          );
                                        }),
                                      ),
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Visibility(
                                        visible: (parseAmount(treasuryTotal) !=
                                            null) ==
                                            (parseAmount(treasuryTotal) !=
                                                0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  isNegativeAmount(treasuryTotal)
                                                      ? const Color(0xffC70F0F)
                                                      : const Color(0xff0FC73A),
                                              shape: BoxShape.circle),
                                          child: isNegativeAmount(treasuryTotal)
                                              ? Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                  size: 14.0,
                                                )
                                              : Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 14.0,
                                                ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    '...',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Cairo'),
                                  ),
                            SizedBox(
                              width: 16.0,
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
