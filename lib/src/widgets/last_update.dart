import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdate {
  String getDate(String input) {
    RegExp regExp = RegExp("\\b(\\d{4}-\\d{2}-\\d{2})");
    String date = regExp.firstMatch(input).group(0).toString();
    int year = int.parse(date.split("-")[0]);
    int month = int.parse(date.split("-")[1]);
    int day = int.parse(date.split("-")[2]);
    DateTime dateTime = DateTime(year, month, day);
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  String getTime(String input) {
    RegExp regExp = RegExp("(\\d{2}:\\d{2})");
    String timeInUTC = regExp.firstMatch(input).group(0).toString();
    int year = int.parse(input.split("T")[0].split("-")[0]);
    int month = int.parse(input.split("T")[0].split("-")[1]);
    int day = int.parse(input.split("T")[0].split("-")[2]);
    int hours = int.parse(timeInUTC.split(":")[0]);
    int minutes = int.parse(timeInUTC.split(":")[1]);
    DateTime dateTime = DateTime(year, month, day, hours, minutes);
    dateTime = dateTime.add(Duration(
        minutes: DateTime.now().timeZoneOffset.inMinutes));
    return DateFormat('H:mm').format(dateTime);
  }
}
