import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class BaseHelper{
  static Future<DateTime?> datePicker(
      context, {
        required DateTime initialDate,
      }) async {
    return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
  }
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy, HH:mm:ss');
    return formatter.format(dateTime);
  }
  static Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();
  }
}