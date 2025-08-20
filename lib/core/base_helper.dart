import 'package:flutter/material.dart';

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
}