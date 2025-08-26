import 'package:uuid/uuid.dart';

class BodyInjury {
  String id;
  String? injuryType, severity, notes, bodySide, added;

  BodyInjury({
    String? id,
    this.injuryType,
    this.severity,
    this.notes,
    this.added,
    this.bodySide,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'injuryType': injuryType,
      'severity': severity,
      'notes': notes,
      'added': added,
      'bodySide': bodySide
    };
  }

  factory BodyInjury.fromMap(Map<String, dynamic> map) {
    return BodyInjury(
      id: map['id'] as String,
      injuryType: map['injuryType'] as String?,
      severity: map['severity'] as String?,
      added: map['added'] as String?,
      bodySide: map['bodySide'] as String?,
      notes: map['notes'] as String?,
    );
  }
}
