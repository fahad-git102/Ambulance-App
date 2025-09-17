import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BodyWidgetPdfHelper {
  static Future<Uint8List?> captureWidgetAsImage(
      GlobalKey boundaryKey,
      ) async {
    try {
      RenderRepaintBoundary? boundary = boundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) return null;

      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing widget: $e');
      return null;
    }
  }

  // Method to get all active body widgets with selections for PDF
  static Map<String, dynamic> getBodyWidgetInfo({
    required Set<String> selectedFrontMaleBodyParts,
    required Set<String> selectedBackMaleBodyParts,
    required Set<String> selectedFrontFemaleBodyParts,
    required Set<String> selectedBackFemaleBodyParts,
  }) {
    final Map<String, dynamic> bodyWidgetInfo = {};

    if (selectedFrontMaleBodyParts.isNotEmpty) {
      bodyWidgetInfo['front_male'] = {
        'type': 'front_male',
        'title': 'Male Front View - Selected Injuries',
        'selectedParts': selectedFrontMaleBodyParts.toList(),
      };
    }

    if (selectedBackMaleBodyParts.isNotEmpty) {
      bodyWidgetInfo['back_male'] = {
        'type': 'back_male',
        'title': 'Male Back View - Selected Injuries',
        'selectedParts': selectedBackMaleBodyParts.toList(),
      };
    }

    if (selectedFrontFemaleBodyParts.isNotEmpty) {
      bodyWidgetInfo['front_female'] = {
        'type': 'front_female',
        'title': 'Female Front View - Selected Injuries',
        'selectedParts': selectedFrontFemaleBodyParts.toList(),
      };
    }

    if (selectedBackFemaleBodyParts.isNotEmpty) {
      bodyWidgetInfo['back_female'] = {
        'type': 'back_female',
        'title': 'Female Back View - Selected Injuries',
        'selectedParts': selectedBackFemaleBodyParts.toList(),
      };
    }

    return bodyWidgetInfo;
  }
}