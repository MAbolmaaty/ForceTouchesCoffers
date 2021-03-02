import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:force_touches_financial/app_theme.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppTheme.kPrimaryColor,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewPortConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewPortConstraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context).login,
                          style: AppTheme.heading,
                        ),
                      )),
                  SizedBox(height: 16.0,),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      child: Image.asset(
                        'assets/images/LOGO.png',
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      child: Image.asset(
                        'assets/images/ACHIEVE_YOUR_GOALS.png',
                      )),
                  SizedBox(height: 16.0,),
                  ///////////////////////////////// Identifier
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TextFormField(
                      maxLines: 1,
                      // validator: (value) => value.isEmpty
                      //     ? AppLocalizations.of(context)
                      //     .enterEmailOrPhoneNumber
                      //     : null,
                      // onSaved: (value) => _identifier = value,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 16, bottom: 16, left: 16, right: 16),
                          labelText:
                              AppLocalizations.of(context).emailOrPhoneNumber,
                          labelStyle: TextStyle(
                            color: const Color(0xFF999898),
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide:
                                  BorderSide(color: const Color(0xffE3E3E6))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide:
                                  BorderSide(color: const Color(0xffE3E3E6))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide:
                                  BorderSide(color: const Color(0xffE3E3E6))),
                          isDense: true),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  ///////////////////////////// Password
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0)),
                      child: TextFormField(
                        maxLines: 1,
                        // validator: (value) => value.isEmpty
                        //     ? AppLocalizations.of(context).enterPassword
                        //     : null,
                        // onSaved: (value) => _password = value,
                        // obscureText: authenticationApi.passwordVisibility ==
                        //     PasswordVisibility.PasswordHidden,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 16, bottom: 16, left: 16, right: 16),
                            labelText: AppLocalizations.of(context).password,
                            labelStyle: TextStyle(
                              color: const Color(0xFF999898),
                              fontSize: 14,
                              fontFamily: 'Cairo',
                            ),
                            suffixIcon: GestureDetector(
                              child: Icon(
                                // authenticationApi.passwordVisibility ==
                                //     PasswordVisibility.PasswordHidden
                                //     ? Icons.visibility_off
                                //     : Icons.visibility,
                                Icons.visibility,
                                color: const Color(0xffE3E3E6),
                                size: 25,
                              ),
                              onTap: () {
                                // authenticationApi
                                //     .changePasswordVisibility();
                              },
                            ),
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: const Color(0xffE3E3E6))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: const Color(0xffE3E3E6))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: const Color(0xffE3E3E6))),
                            isDense: true),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: true,
                          //onChanged: _onRememberMeChanged,
                          checkColor: AppTheme.kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context).rememberMe,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Cairo'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 48.0,
                        width: MediaQuery.of(context).size.width,
                        margin:
                            EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                        child: RaisedButton(
                          onPressed: () {},
                          color: AppTheme.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          child: Text(
                            AppLocalizations.of(context).login,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cairo',
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0,),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
