import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:force_touches_financial/app_theme.dart';

class AmountDataField {
  String checkAmount(BuildContext context, String amount) {
    amount = amount.replaceAll(" ", "");
    RegExp regExp = RegExp("[.|,]?\\d+[.|,]?");
    var splits = regExp.allMatches(amount).toList();
    String wholeNumber = "";
    for (var split in splits) {
      wholeNumber += split.group(0).toString();
    }
    if (parseAmount(wholeNumber) == null)
      wholeNumber = AppLocalizations.of(context).emptyField;

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
      print(e.toString());
    }
    if (isNegative) {
      doubleAmount = doubleAmount * -1;
    }
    return doubleAmount;
  }

  bool isNegativeAmount(String amount) {
    return amount.contains(RegExp("- ?[0-9]|[0-9] ?-"));
  }

  Widget mainDataField(
      {@required BuildContext context,
      @required String labelText,
      @required List<String> values}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          TextFormField(
            maxLines: 1,
            enabled: false,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 11, bottom: 11, left: 16, right: 16),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
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
                child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Localizations.override(
                  context: context,
                  locale: const Locale('en'),
                  child: Builder(builder: (BuildContext context) {
                    return Text(
                      checkAmount(context, values[0]),
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
                  visible: (parseAmount(values[0]) != null) ==
                      (parseAmount(values[0]) != 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: isNegativeAmount(values[0])
                            ? const Color(0xffC70F0F)
                            : const Color(0xff0FC73A),
                        shape: BoxShape.circle),
                    child: isNegativeAmount(values[0])
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
            )),
          ),
          Align(
            alignment: AppLocalizations.of(context).localeName == 'ar'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 16.0, left: 16.0),
              child: Text(
                AppLocalizations.of(context).saudiCurrency,
                style: TextStyle(
                    color: Colors.white, fontSize: 12, fontFamily: 'Cairo'),
              ),
            ),
          ),
          if (values.length > 1)
            Align(
              alignment: AppLocalizations.of(context).localeName == 'ar'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(right: 16.0, left: 16.0),
                child: Text(
                  values[1],
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Cairo', fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget emptyMainDataField({@required BuildContext context}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          TextFormField(
            maxLines: 1,
            enabled: false,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 11, bottom: 11, left: 16, right: 16),
              labelText: AppLocalizations.of(context).emptyField,
              floatingLabelBehavior: FloatingLabelBehavior.always,
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
                child: Localizations.override(
                  context: context,
                  locale: const Locale('en'),
                  child: Builder(builder: (BuildContext context) {
                    return Text(
                      AppLocalizations.of(context).emptyField,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Cairo'),
                    );
                  }),
                )),
          ),
          Align(
            alignment: AppLocalizations.of(context).localeName == 'ar'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 16.0, left: 16.0),
              child: Text(
                AppLocalizations.of(context).emptyField,
                style: TextStyle(
                    color: Colors.white, fontSize: 12, fontFamily: 'Cairo'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget individualDataField(
      {@required BuildContext context,
      @required String individualName,
      @required List<String> values}) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            shape: BoxShape.rectangle,
            border: Border.all(width: 0.8, color: Colors.white),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Localizations.override(
                      context: context,
                      locale: const Locale('en'),
                      child: Builder(builder: (BuildContext context) {
                        return Text(
                          checkAmount(context, values[0]),
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
                      visible: (parseAmount(values[0]) != null) ==
                          (parseAmount(values[0]) != 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: isNegativeAmount(values[0])
                                ? const Color(0xffC70F0F)
                                : const Color(0xff0FC73A),
                            shape: BoxShape.circle),
                        child: isNegativeAmount(values[0])
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
                ),
              ),
              Container(
                margin: (parseAmount(values[0]) != null) ==
                        (parseAmount(values[0]) != 0.0)
                    ? EdgeInsets.only(left: 14.0)
                    : EdgeInsets.only(left: 0.0),
                child: Text(
                  AppLocalizations.of(context).saudiCurrency,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              color: AppTheme.kPrimaryColor,
              child: Text(
                '  $individualName  ',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 14,
                ),
              )),
        ),
      ],
    );
  }

  Widget emptyIndividualDataField({@required BuildContext context}) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            shape: BoxShape.rectangle,
            border: Border.all(width: 0.8, color: Colors.white),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Localizations.override(
                  context: context,
                  locale: const Locale('en'),
                  child: Builder(builder: (BuildContext context) {
                    return Text(
                      AppLocalizations.of(context).emptyField,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Cairo'),
                    );
                  }),
                ),
              ),
              Container(
                child: Text(
                  AppLocalizations.of(context).emptyField,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              color: AppTheme.kPrimaryColor,
              child: Text(
                '  ${AppLocalizations.of(context).emptyField}  ',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 14,
                ),
              )),
        ),
      ],
    );
  }
}
