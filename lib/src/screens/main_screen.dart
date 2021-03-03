import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:force_touches_financial/app_theme.dart';

class MainScreen extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => MainScreen(),
      );

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<Null> _fetchData() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: AppTheme.kPrimaryColor,
        ),
        backgroundColor: AppTheme.kPrimaryColor,
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _fetchData,
            child: SingleChildScrollView(
              child: Column(
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
                        Column(children: <Widget>[
                          Text(
                            'Last Update',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Cairo'),
                          ),
                          Text(
                            '02/02/2020',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Cairo'),
                          ),
                          Text(
                            '07:30 PM',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Cairo'),
                          ),
                        ]),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                //Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.logout,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
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
                            labelText: AppLocalizations.of(context).salaries,
                            labelStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 13,
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
                              '18,000',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 16.0, left: 16.0),
                            child: Text(
                              'SAR',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(right: 16.0, left: 16.0),
                            child: Text(
                              'July',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ///////////////////////////////// Bills
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
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
                              fontSize: 13,
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
                              '18,000',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 16.0, left: 16.0),
                            child: Text(
                              'SAR',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ///////////////////////////////// Treasury
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
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
                            labelText: AppLocalizations.of(context).treasury,
                            labelStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 13,
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
                              '18,000',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 16.0, left: 16.0),
                            child: Text(
                              'SAR',
                              style: TextStyle(color: Colors.white),
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
                  ///////////////////////////////// Ibrahim
                  Row(
                    children: [
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
                                    top: 56, bottom: 56, left: 16, right: 16),
                                labelText: 'Ibrahim',
                                prefixIcon: SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          0.4) *
                                      0.2,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 12,
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
                                  '18,000',
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
                                  'SAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                    top: 56, bottom: 56, left: 16, right: 16),
                                labelText: 'Ibrahim',
                                prefixIcon: SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          0.4) *
                                      0.2,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 12,
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
                                  '18,000',
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
                                  'SAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
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
                                    top: 56, bottom: 56, left: 16, right: 16),
                                labelText: 'Ibrahim',
                                prefixIcon: SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          0.4) *
                                      0.2,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 12,
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
                                  '18,000',
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
                                  'SAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                    top: 56, bottom: 56, left: 16, right: 16),
                                labelText: 'Ibrahim',
                                prefixIcon: SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          0.4) *
                                      0.2,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                  fontSize: 12,
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
                                  '18,000',
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
                                  'SAR',
                                  style: TextStyle(color: Colors.white),
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
                          flex:1,
                          child: Text(
                            'Coffers Total',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          '18,000',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          'SAR',
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
              ),
            )));
  }
}
