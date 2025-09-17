import 'package:flutter/material.dart';

class VitalSet {
  TextEditingController time = TextEditingController();
  TextEditingController hr = TextEditingController();
  TextEditingController rr = TextEditingController();
  TextEditingController bpSys = TextEditingController();
  TextEditingController bpDia = TextEditingController();
  TextEditingController spo2 = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController bgl = TextEditingController();
  TextEditingController gcs = TextEditingController();

  Map<String, dynamic> toMap() {
    return {
      "time": time.text,
      "hr": hr.text,
      "rr": rr.text,
      "bp_systolic": bpSys.text,
      "bp_diastolic": bpDia.text,
      "spo2": spo2.text,
      "temp_c": temp.text,
      "bgl_mgdl": bgl.text,
      "gcs": gcs.text
    };
  }
}