import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Localizations.override(
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
                SizedBox(
                  width: 4.0,
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
      width: MediaQuery.of(context).size.width * 0.4,
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
                  EdgeInsets.only(top: 56, bottom: 56, left: 0, right: (MediaQuery.of(context).size.width * 0.5)),
              labelText: individualName,
              // prefixIcon: SizedBox(
              //   width: (MediaQuery.of(context).size.width * 0.4) / 2,
              // ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontSize: 14,
              ),
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
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 48.0),
              child: Text(
                AppLocalizations.of(context).saudiCurrency,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emptyIndividualDataField(
      {@required BuildContext context}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
      width: MediaQuery.of(context).size.width * 0.4,
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
              EdgeInsets.only(top: 56, bottom: 56, left: 16, right: 16),
              labelText: AppLocalizations.of(context).emptyField,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: SizedBox(
                width: (MediaQuery.of(context).size.width * 0.4) * 0.2,
              ),
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
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Localizations.override(
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
                  SizedBox(
                    width: 4.0,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 48.0),
              child: Text(
                  AppLocalizations.of(context).emptyField,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
