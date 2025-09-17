import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<Uint8List> generateNewIncidentReportPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) => [
        // Title
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Logo Image
            if (data['logoImage'] != null)
              pw.Container(
                width: 60,
                height: 60,
                margin: pw.EdgeInsets.only(right: 16),
                child: pw.Image(
                  pw.MemoryImage(data['logoImage']),
                  fit: pw.BoxFit.contain,
                ),
              ),
            // Text Content
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Incident Report",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  if (_isNotEmpty(data['incidentDate']))
                    pw.Text("Incident occurred: ${data['incidentDate']}"),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),

        // Subject & Incident Row
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Subject Box - only show if has content
            if (_hasSubjectData(data))
              pw.Expanded(
                child: _infoBox("Subject", _buildSubjectContent(data)),
              ),
            if (_hasSubjectData(data) && _hasIncidentData(data))
              pw.SizedBox(width: 8),
            // Incident Box - only show if has content
            if (_hasIncidentData(data))
              pw.Expanded(
                child: _infoBox("Incident", _buildIncidentContent(data)),
              ),
          ],
        ),
        if (_hasSubjectData(data) || _hasIncidentData(data))
          pw.SizedBox(height: 10),

        // Chief Complaint - only show if has content
        if (_isNotEmpty(data['chiefComplaint']) || _isNotEmpty(data['notes']))
          _infoBox("Chief Complaint & Notes", [
            if (_isNotEmpty(data['chiefComplaint']))
              pw.Text(data['chiefComplaint']),
            if (_isNotEmpty(data['chiefComplaint']) && _isNotEmpty(data['notes']))
              pw.SizedBox(height: 6),
            if (_isNotEmpty(data['notes']))
              pw.Text(data['notes'], style: pw.TextStyle(font: pw.Font.courier())),
          ]),
        if (_isNotEmpty(data['chiefComplaint']) || _isNotEmpty(data['notes']))
          pw.SizedBox(height: 10),

        // Treatments & Vitals
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (_isNotEmpty(data['treatments']))
              pw.Expanded(
                child: _infoBox("Treatments", [
                  pw.Text(data['treatments']),
                ]),
              ),
            if (_isNotEmpty(data['treatments']) && _hasVitalsData(data))
              pw.SizedBox(width: 8),
            if (_hasVitalsData(data))
              pw.Expanded(
                child: _infoBox("Vitals", [
                  pw.Text(_formatVitals(data['vitals'])),
                ]),
              ),
          ],
        ),
        if (_isNotEmpty(data['treatments']) || _hasVitalsData(data))
          pw.SizedBox(height: 10),

        if (_hasBodyWidgetData(data))
          _infoBox("Injury Location Overview", [
            pw.Text(
              "Visual representation of selected injury locations on body diagrams",
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 8),
            _buildBodyWidgetGrid(data['bodyWidgetImages']),
          ]),
        if (_hasBodyWidgetData(data))
          pw.SizedBox(height: 10),

        // Body Map List - only show if has data
        if (_hasBodyMapData(data))
          _infoBox("Body Map Details", [
            for (var injury in (data['bodyMap'] as List))
              if (_hasInjuryData(injury))
                pw.Text(
                  _formatInjuryText(injury),
                  style: pw.TextStyle(fontSize: 10),
                ),
          ]),
        if (_hasBodyMapData(data))
          pw.SizedBox(height: 10),

        // Photos Grid - only show if has photos
        if (_hasPhotosData(data))
          _infoBox("Photos", [
            pw.Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var photo in (data['photos'] as List))
                  if (photo['file'] != null)
                    pw.Container(
                      width: 200,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (_isNotEmpty(photo['pickedAt']))
                            pw.Text(photo['pickedAt'] ?? "",
                                style: pw.TextStyle(
                                    fontSize: 8, color: PdfColors.grey700)),
                          pw.Container(
                            margin: const pw.EdgeInsets.symmetric(vertical: 4),
                            height: 120,
                            child: pw.Image(pw.MemoryImage(photo['file']), height: 120),
                          ),
                          if (_isNotEmpty(photo['caption']))
                            pw.Text(photo['caption'],
                                style: pw.TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
              ],
            ),
          ]),
        if (_hasPhotosData(data))
          pw.SizedBox(height: 10),

        // Signatures Row - only show signatures that exist
        if (_hasAnySignature(data))
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (data['signResponder'] != null)
                _signatureBox("Responder", data['signResponder']),
              if (data['signResponder'] != null &&
                  (data['signPatient'] != null || data['signGuardian'] != null))
                pw.SizedBox(width: 8),
              if (data['signPatient'] != null)
                _signatureBox("Patient", data['signPatient']),
              if (data['signPatient'] != null && data['signGuardian'] != null)
                pw.SizedBox(width: 8),
              if (data['signGuardian'] != null)
                _signatureBox("Guardian", data['signGuardian']),
            ],
          ),
      ].where((widget) => widget != null).toList(),
    ),
  );

  return pdf.save();
}

// Helper functions to check if data exists
bool _isNotEmpty(dynamic value) {
  if (value == null) return false;
  if (value is String) return value.trim().isNotEmpty;
  if (value is List) return value.isNotEmpty;
  return true;
}

bool _hasSubjectData(Map<String, dynamic> data) {
  return _isNotEmpty(data['name']) ||
      _isNotEmpty(data['studentId']) ||
      _isNotEmpty(data['gender']) ||
      _isNotEmpty(data['dob']);
}

bool _hasIncidentData(Map<String, dynamic> data) {
  return _isNotEmpty(data['incidentDate']) ||
      _isNotEmpty(data['site']) ||
      _isNotEmpty(data['location']) ||
      _isNotEmpty(data['activity']) ||
      _isNotEmpty(data['severity']) ||
      _isNotEmpty(data['mechanism']) ||
      _isNotEmpty(data['injuryType']) ||
      _isNotEmpty(data['illnessType']);
}

bool _hasVitalsData(Map<String, dynamic> data) {
  if (data['vitals'] == null) return false;
  if (data['vitals'] is List) return (data['vitals'] as List).isNotEmpty;
  return true;
}

bool _hasBodyMapData(Map<String, dynamic> data) {
  if (data['bodyMap'] == null) return false;
  if (data['bodyMap'] is List) {
    List bodyMap = data['bodyMap'] as List;
    return bodyMap.any((injury) => _hasInjuryData(injury));
  }
  return false;
}

bool _hasInjuryData(Map<String, dynamic> injury) {
  return _isNotEmpty(injury['region']) ||
      _isNotEmpty(injury['bodySide']) ||
      _isNotEmpty(injury['injuryType']) ||
      _isNotEmpty(injury['severity']) ||
      _isNotEmpty(injury['notes']);
}

bool _hasPhotosData(Map<String, dynamic> data) {
  if (data['photos'] == null) return false;
  if (data['photos'] is List) {
    List photos = data['photos'] as List;
    return photos.any((photo) => photo['file'] != null);
  }
  return false;
}

bool _hasBodyWidgetData(Map<String, dynamic> data) {
  if (data['bodyWidgetImages'] == null) return false;
  if (data['bodyWidgetImages'] is List) {
    List bodyWidgets = data['bodyWidgetImages'] as List;
    return bodyWidgets.any((widget) =>
    widget is Map<String, dynamic> &&
        widget['imageBytes'] != null &&
        widget['selectedParts'] is List &&
        (widget['selectedParts'] as List).isNotEmpty
    );
  }
  return false;
}

pw.Widget _buildBodyWidgetGrid(dynamic bodyWidgetImages) {
  if (bodyWidgetImages == null || bodyWidgetImages is! List) {
    return pw.Container();
  }

  final List<Map<String, dynamic>> widgets =
  (bodyWidgetImages as List).cast<Map<String, dynamic>>();

  if (widgets.isEmpty) return pw.Container();

  // Build grid with 2 columns
  List<pw.Widget> rows = [];

  for (int i = 0; i < widgets.length; i += 2) {
    rows.add(
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // First widget in row
          pw.Expanded(
            child: _buildBodyWidgetSection(widgets[i]),
          ),

          // Second widget if exists
          if (i + 1 < widgets.length) ...[
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildBodyWidgetSection(widgets[i + 1]),
            ),
          ] else ...[
            pw.Expanded(child: pw.Container()),
          ],
        ],
      ),
    );

    // Add spacing between rows
    if (i + 2 < widgets.length) {
      rows.add(pw.SizedBox(height: 16));
    }
  }

  return pw.Column(children: rows);
}

pw.Widget _buildBodyWidgetSection(Map<String, dynamic> bodyWidget) {
  final imageBytes = bodyWidget['imageBytes'] as Uint8List?;
  final title = bodyWidget['title'] as String? ?? '';
  final selectedParts = (bodyWidget['selectedParts'] as List<dynamic>?)
      ?.cast<String>() ?? <String>[];

  if (imageBytes == null) return pw.Container();

  return pw.Container(
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Body widget image
        pw.Container(
          height: 180,
          width: 110,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.ClipRRect(
            horizontalRadius: 6,
            verticalRadius: 6,
            child: pw.Image(
              pw.MemoryImage(imageBytes),
              fit: pw.BoxFit.contain,
            ),
          ),
        ),

        pw.SizedBox(height: 8),

        // Title
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
          textAlign: pw.TextAlign.center,
        ),

        pw.SizedBox(height: 6),

        // Selected parts (limit to prevent overflow)
        if (selectedParts.isNotEmpty)
          pw.Container(
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Selected Areas:',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                ...selectedParts.take(6).map<pw.Widget>((part) =>
                    pw.Text(
                      '• $part',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                ).toList(),
                if (selectedParts.length > 6)
                  pw.Text(
                    '• ... and ${selectedParts.length - 6} more',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );
}

bool _hasAnySignature(Map<String, dynamic> data) {
  return data['signResponder'] != null ||
      data['signPatient'] != null ||
      data['signGuardian'] != null;
}

// Helper functions to build content
List<pw.Widget> _buildSubjectContent(Map<String, dynamic> data) {
  List<pw.Widget> content = [];

  if (_isNotEmpty(data['name']) || _isNotEmpty(data['studentId'])) {
    content.add(_twoColConditional("Name", data['name'], "Student ID", data['studentId']));
  }

  if (_isNotEmpty(data['gender']) || _isNotEmpty(data['dob'])) {
    content.add(_twoColConditional("Gender", data['gender'], "DOB", data['dob']));
  }

  return content;
}

List<pw.Widget> _buildIncidentContent(Map<String, dynamic> data) {
  List<pw.Widget> content = [];

  if (_isNotEmpty(data['incidentDate']) || _isNotEmpty(data['site'])) {
    content.add(_twoColConditional("Occurred", data['incidentDate'], "Site", data['site']));
  }

  if (_isNotEmpty(data['location']) || _isNotEmpty(data['activity'])) {
    content.add(_twoColConditional("Location", data['location'], "Activity", data['activity']));
  }

  if (_isNotEmpty(data['severity']) || _isNotEmpty(data['mechanism'])) {
    content.add(_twoColConditional("Severity", data['severity'], "Mechanism", data['mechanism']));
  }

  if (_isNotEmpty(data['injuryType']) || _isNotEmpty(data['illnessType'])) {
    content.add(_twoColConditional("Injury Type", data['injuryType'], "Illness Type", data['illnessType']));
  }

  return content;
}

// String _formatVitals(dynamic vitals) {
//   if (vitals == null) return '';
//   if (vitals is List && vitals.isEmpty) return '';
//   return vitals.toString();
// }
String _formatVitals(dynamic vitals) {
  if (vitals == null) return '';
  if (vitals is List && vitals.isEmpty) return '';

  if (vitals is List) {
    List<String> formattedVitals = [];

    for (int i = 0; i < vitals.length; i++) {
      var vital = vitals[i];
      if (vital is Map<String, dynamic>) {
        List<String> vitalLines = [];

        // Add time if available
        if (_isNotEmpty(vital['time'])) {
          vitalLines.add("Time: ${vital['time']}");
        }

        // Add vital signs in a structured format
        List<String> measurements = [];
        if (_isNotEmpty(vital['hr'])) measurements.add("HR: ${vital['hr']}");
        if (_isNotEmpty(vital['rr'])) measurements.add("RR: ${vital['rr']}");
        if (_isNotEmpty(vital['gcs'])) measurements.add("GCS: ${vital['gcs']}");
        if (_isNotEmpty(vital['bp_systolic']) && _isNotEmpty(vital['bp_diastolic'])) {
          measurements.add("BP: ${vital['bp_systolic']}/${vital['bp_diastolic']}");
        } else if (_isNotEmpty(vital['bp_systolic'])) {
          measurements.add("BP Sys: ${vital['bp_systolic']}");
        } else if (_isNotEmpty(vital['bp_diastolic'])) {
          measurements.add("BP Dia: ${vital['bp_diastolic']}");
        }
        if (_isNotEmpty(vital['spo2'])) measurements.add("SpO2: ${vital['spo2']}%");
        if (_isNotEmpty(vital['temp_c'])) measurements.add("Temp: ${vital['temp_c']}°C");
        if (_isNotEmpty(vital['bgl_mgdl'])) measurements.add("BGL: ${vital['bgl_mgdl']} mg/dL");

        if (measurements.isNotEmpty) {
          vitalLines.addAll(measurements);
        }

        if (vitalLines.isNotEmpty) {
          formattedVitals.add("Set ${i + 1}:\n${vitalLines.join(', ')}");
        }
      }
    }

    return formattedVitals.join('\n\n');
  }

  return vitals.toString();
}


String _formatInjuryText(Map<String, dynamic> injury) {
  List<String> parts = [];

  if (_isNotEmpty(injury['region'])) {
    String region = injury['region'];
    if(_isNotEmpty(injury['gender'])){
      region += " - ${injury['gender']}";
    }
    if (_isNotEmpty(injury['bodySide'])) {
      region += " - ${injury['bodySide']}";
    }
    parts.add(region);
  }

  if (_isNotEmpty(injury['injuryType'])) {
    String injuryInfo = injury['injuryType'];
    if (_isNotEmpty(injury['severity'])) {
      injuryInfo += " (${injury['severity']})";
    }
    parts.add(injuryInfo);
  }

  if (_isNotEmpty(injury['notes'])) {
    parts.add("- ${injury['notes']}");
  }

  return parts.join(': ');
}

// Helper: Info box with border
pw.Widget _infoBox(String title, List<pw.Widget> children) {
  if (children.isEmpty) return pw.SizedBox.shrink();

  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    margin: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.SizedBox(height: 4),
        ...children,
      ],
    ),
  );
}

// Helper: Key-Value pairs in two columns (conditional)
pw.Widget _twoColConditional(String k1, String? v1, String k2, String? v2) {
  List<pw.Widget> leftColumn = [];
  List<pw.Widget> rightColumn = [];

  if (_isNotEmpty(v1)) {
    leftColumn.addAll([
      pw.Text(k1, style: pw.TextStyle(fontSize: 10)),
      pw.Text(v1!, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
    ]);
  }

  if (_isNotEmpty(v2)) {
    rightColumn.addAll([
      pw.Text(k2, style: pw.TextStyle(fontSize: 10)),
      pw.Text(v2!, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
    ]);
  }

  if (leftColumn.isEmpty && rightColumn.isEmpty) {
    return pw.SizedBox.shrink();
  }

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      if (leftColumn.isNotEmpty)
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: leftColumn,
        )
      else
        pw.SizedBox.shrink(),
      if (rightColumn.isNotEmpty)
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: rightColumn,
        )
      else
        pw.SizedBox.shrink(),
    ],
  );
}

// Helper: Key-Value pairs in two columns (original - kept for compatibility)
pw.Widget _twoCol(String k1, String v1, String k2, String v2) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(k1, style: pw.TextStyle(fontSize: 10)),
          pw.Text(v1, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ],
      ),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(k2, style: pw.TextStyle(fontSize: 10)),
          pw.Text(v2, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    ],
  );
}

// Helper: Signature box
pw.Widget _signatureBox(String label, Uint8List? signature) {
  return pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blueGrey, width: 1),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          if (signature != null)
            pw.Image(pw.MemoryImage(signature), height: 40),
          pw.SizedBox(height: 6),
          pw.Text(label, style: pw.TextStyle(fontSize: 10)),
        ],
      ),
    ),
  );
}