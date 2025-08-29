import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<Uint8List> generateIncidentReportPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) => [
        // Title
        pw.Text("Incident Report",
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            )),
        pw.Text("Incident occurred: ${data['incidentDate']}"),
        pw.SizedBox(height: 12),

        // Subject & Incident Row
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Subject Box
            pw.Expanded(
              child: _infoBox("Subject", [
                _twoCol("Name", data['name'], "Student ID", data['studentId']),
                _twoCol("Gender", data['gender'], "DOB", data['dob']),
              ]),
            ),
            pw.SizedBox(width: 8),
            // Incident Box
            pw.Expanded(
              child: _infoBox("Incident", [
                _twoCol("Occurred", data['incidentDate'], "Site", data['site']),
                _twoCol("Location", data['location'], "Activity", data['activity']),
                _twoCol("Severity", data['severity'], "Mechanism", data['mechanism']),
                _twoCol("Injury Type", data['injuryType'], "Illness Type", data['illnessType']),
              ]),
            ),
          ],
        ),
        pw.SizedBox(height: 10),

        // Chief Complaint
        _infoBox("Chief Complaint & Notes", [
          pw.Text(data['chiefComplaint']),
          pw.SizedBox(height: 6),
          pw.Text(data['notes'], style: pw.TextStyle(font: pw.Font.courier())),
        ]),
        pw.SizedBox(height: 10),

        // Treatments & Vitals
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: _infoBox("Treatments", [
                pw.Text(data['treatments']),
              ]),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: _infoBox("Vitals", [
                pw.Text(data['vitals'].toString()),
              ]),
            ),
          ],
        ),
        pw.SizedBox(height: 10),

        // Body Map List
        _infoBox("Body Map", [
          for (var injury in (data['bodyMap'] as List))
            pw.Text(
              "${injury['region']} - ${injury['bodySide']}: "
                  "${injury['injuryType']} (${injury['severity']}) "
                  "${injury['notes'] != null ? '- ${injury['notes']}' : ''}",
              style: pw.TextStyle(fontSize: 10),
            ),
        ]),
        pw.SizedBox(height: 10),

        // Photos Grid
        if (data['photos'] != null && (data['photos'] as List).isNotEmpty)
          _infoBox("Photos", [
            pw.Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var photo in (data['photos'] as List))
                  pw.Container(
                    width: 200,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(photo['pickedAt'] ?? "",
                            style: pw.TextStyle(
                                fontSize: 8, color: PdfColors.grey700)),
                        if (photo['file'] != null)
                          pw.Container(
                            margin: const pw.EdgeInsets.symmetric(vertical: 4),
                            height: 120,
                            child: pw.Image(pw.MemoryImage(photo['file']), height: 120),
                          ),
                        if (photo['caption'] != null)
                          pw.Text(photo['caption'],
                              style: pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  ),
              ],
            ),
          ]),
        pw.SizedBox(height: 10),

        // Signatures Row
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _signatureBox("Responder", data['signResponder']),
            pw.SizedBox(width: 8),
            _signatureBox("Patient", data['signPatient']),
            pw.SizedBox(width: 8),
            _signatureBox("Guardian", data['signGuardian']),
          ],
        ),
      ],
    ),
  );

  return pdf.save();
}

// Helper: Info box with border
pw.Widget _infoBox(String title, List<pw.Widget> children) {
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

// Helper: Key-Value pairs in two columns
pw.Widget _twoCol(String k1, String v1, String k2, String v2) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text("$k1\n$v1", style: pw.TextStyle(fontSize: 10)),
      pw.Text("$k2\n$v2", style: pw.TextStyle(fontSize: 10)),
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
