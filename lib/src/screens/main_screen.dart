import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:force_touches_financial/app_theme.dart';
import 'package:force_touches_financial/src/screens/login_screen.dart';
import 'package:force_touches_financial/src/utils/networking/coffers_api.dart';
import 'package:force_touches_financial/src/utils/preferences/user_preferences.dart';
import 'package:force_touches_financial/src/widgets/amount_data_field.dart';
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

  // bool isNegativeAmount(String amount) {
  //   return amount.contains(RegExp("- ?[0-9]|[0-9] ?-"));
  // }
  //
  // String checkAmount(String amount) {
  //   amount = amount.replaceAll(" ", "");
  //   RegExp regExp = RegExp("[.|,]?\\d+[.|,]?");
  //   var splits = regExp.allMatches(amount).toList();
  //   String wholeNumber = "";
  //   for (var split in splits) {
  //     wholeNumber += split.group(0).toString();
  //   }
  //   if (parseAmount(wholeNumber) == null) wholeNumber = "...";
  //
  //   return wholeNumber;
  // }
  //
  // double parseAmount(String amount) {
  //   amount = amount.replaceAll(" ", "");
  //   RegExp regExp = RegExp("[.]?\\d+[.]?");
  //   bool isNegative = isNegativeAmount(amount);
  //   var splits = regExp.allMatches(amount).toList();
  //   String wholeNumber = "";
  //   for (var split in splits) {
  //     wholeNumber += split.group(0).toString();
  //   }
  //   double doubleAmount;
  //   try {
  //     doubleAmount = double.parse(wholeNumber);
  //   } on Exception catch (e) {}
  //   if (isNegative) {
  //     doubleAmount = doubleAmount * -1;
  //   }
  //   return doubleAmount;
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    AmountDataField amountDataField = AmountDataField();
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
              //////////////// Fetching Data with every refresh
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child:
                Consumer<CoffersApi>(builder: (context, coffersApi, child) {
                  // Direct user to the Login Screen if failed to load main data
                  if (coffersApi.coffersLoading == CoffersLoading.Failed) {
                    UserPreferences().removeUser().then((value) =>
                        Navigator.of(context).pushAndRemoveUntil(
                            LoginScreen.route(), (route) => false));
                  }
                  // Calculate The Four Treasuries (Abdelaziz, Bahaa, Ibrahim, Abdelrahman)
                  String treasuryTotal = "";
                  if (coffersApi.coffersLoading == CoffersLoading.Succeed) {
                    double doubleTreasuryTotal;
                    doubleTreasuryTotal = amountDataField.parseAmount(
                        coffersApi.coffersResponseModel.ibrahimTreasury) +
                        amountDataField.parseAmount(
                            coffersApi.coffersResponseModel.abdelazizTreasury) +
                        amountDataField.parseAmount(
                            coffersApi.coffersResponseModel.bahaaTreasury) +
                        amountDataField.parseAmount(coffersApi
                            .coffersResponseModel.abdelrahmanTreasury);
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
                                  ////////////// Current Data
                                  Text(
                                    DateFormat('yyyy/MM/dd')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Cairo'),
                                  ),
                                  ///////////// Current Time
                                  Text(
                                    DateFormat('h:mm').format(DateTime.now()),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Cairo'),
                                  ),
                                ]),
                            //////////////// Logging out
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
                      coffersApi.coffersLoading == CoffersLoading.Succeed
                          ? amountDataField.mainDataField(
                          context: context,
                          labelText: AppLocalizations.of(context).salaries,
                          values: [
                            coffersApi.coffersResponseModel.salaries,
                            coffersApi.coffersResponseModel.salariesMonth
                          ])
                          : amountDataField.emptyMainDataField(
                          context: context),
                      ///////////////////////////////// Bills
                      coffersApi.coffersLoading == CoffersLoading.Succeed
                          ? amountDataField.mainDataField(
                          context: context,
                          labelText: AppLocalizations.of(context).bills,
                          values: [
                            coffersApi.coffersResponseModel.bills,
                          ])
                          : amountDataField.emptyMainDataField(
                          context: context),
                      ///////////////////////////////// Treasury
                      coffersApi.coffersLoading == CoffersLoading.Succeed
                          ? amountDataField.mainDataField(
                          context: context,
                          labelText: AppLocalizations.of(context).treasury,
                          values: [
                            coffersApi.coffersResponseModel.treasury,
                          ])
                          : amountDataField.emptyMainDataField(
                          context: context),
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
                          ///////////////////////////////// Ibrahim Treasury
                          coffersApi.coffersLoading == CoffersLoading.Succeed
                              ? amountDataField.individualDataField(
                              context: context,
                              individualName:
                              AppLocalizations.of(context).ibrahim,
                              values: [
                                coffersApi
                                    .coffersResponseModel.ibrahimTreasury
                              ])
                              : amountDataField.emptyIndividualDataField(
                              context: context),
                          ///////////////////////////////// Abdelaziz Treasury
                          coffersApi.coffersLoading == CoffersLoading.Succeed
                              ? amountDataField.individualDataField(
                              context: context,
                              individualName:
                              AppLocalizations.of(context).abdelaziz,
                              values: [
                                coffersApi.coffersResponseModel
                                    .abdelazizTreasury
                              ])
                              : amountDataField.emptyIndividualDataField(
                              context: context),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///////////////////////////////// Bahaa Treasury
                          coffersApi.coffersLoading == CoffersLoading.Succeed
                              ? amountDataField.individualDataField(
                              context: context,
                              individualName:
                              AppLocalizations.of(context).bahaa,
                              values: [
                                coffersApi
                                    .coffersResponseModel.bahaaTreasury
                              ])
                              : amountDataField.emptyIndividualDataField(
                              context: context),
                          ///////////////////////////////// Abdelrahman Treasury
                          coffersApi.coffersLoading == CoffersLoading.Succeed
                              ? amountDataField.individualDataField(
                              context: context,
                              individualName:
                              AppLocalizations.of(context).abdelrahman,
                              values: [
                                coffersApi.coffersResponseModel
                                    .abdelrahmanTreasury
                              ])
                              : amountDataField.emptyIndividualDataField(
                              context: context),
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
                      //Treasury Total (Abdelaziz, Bahaa, Ibrahim, Abdelrahman)
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
                                          amountDataField.checkAmount(context, treasuryTotal),
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
                                  visible: (amountDataField.parseAmount(treasuryTotal) !=
                                      null) ==
                                      (amountDataField.parseAmount(treasuryTotal) != 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: amountDataField.isNegativeAmount(
                                            treasuryTotal)
                                            ? const Color(0xffC70F0F)
                                            : const Color(0xff0FC73A),
                                        shape: BoxShape.circle),
                                    child: amountDataField.isNegativeAmount(treasuryTotal)
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

