import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';
import 'package:nephro_care/features/trackers/injections/injection_enums.dart';

class InjectionModel {
  final String id;
  final String drugName;
  final String dosage;
  final InjectionRoute route;
  final InjectionSite site;
  final InjectionType type;
  final DateTime administeredDate;
  final String? administeredBy;
  final String? location;
  final String? lotNumber;
  final String? batchNumber;
  final InjectionReaction? reaction;
  final String? reactionNotes;
  final String? linkedProcedureId;
  final String? linkedDialysisSessionId;
  final String? notes;
  final Timestamp timestamp;
  final bool isPendingSync;

  InjectionModel({
    required this.id,
    required this.drugName,
    required this.dosage,
    required this.route,
    required this.site,
    required this.type,
    required this.administeredDate,
    this.administeredBy,
    this.location,
    this.lotNumber,
    this.batchNumber,
    this.reaction,
    this.reactionNotes,
    this.linkedProcedureId,
    this.linkedDialysisSessionId,
    this.notes,
    required this.timestamp,
    this.isPendingSync = false,
  });

  factory InjectionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return InjectionModel(
      id: data['id'] as String,
      drugName: data['drugName'] as String,
      dosage: data['dosage'] as String,
      route: InjectionRoute.values.parse(data['route']),
      //How does this work?
      site: InjectionSite.values.parse(data['site']),
      type: InjectionType.values.parse(data['type']),
      administeredDate: (data['administeredDate'] as Timestamp).toDate(),
      administeredBy: data['administeredBy'] as String?,
      location: data['location'] as String?,
      lotNumber: data['lotNumber'] as String?,
      batchNumber: data['batchNumber'] as String?,
      reaction: InjectionReaction.values.parseOrNull(data['reaction']),
      reactionNotes: data['reactionNotes'] as String?,
      linkedProcedureId: data['linkedProcedureId'] as String?,
      linkedDialysisSessionId: data['linkedDialysisSessionId'] as String?,
      notes: data['notes'] as String?,
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory InjectionModel.fromJson(Map<String, dynamic> json) {
    return InjectionModel(
      id: json['id'] as String,
      drugName: json['drugName'] as String,
      dosage: json['dosage'] as String,
      route: InjectionRoute.values.parse(json['route']),
      site: InjectionSite.values.parse(json['site']),
      type: InjectionType.values.parse(json['type']),
      administeredDate: (json['administeredDate'] as Timestamp).toDate(),
      administeredBy: json['administeredBy'] as String?,
      location: json['location'] as String?,
      lotNumber: json['lotNumber'] as String?,
      batchNumber: json['batchNumber'] as String?,
      reaction: InjectionReaction.values.parseOrNull(json['reaction']),
      reactionNotes: json['reactionNotes'] as String?,
      linkedProcedureId: json['linkedProcedureId'] as String?,
      linkedDialysisSessionId: json['linkedDialysisSessionId'] as String?,
      notes: json['notes'] as String?,
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'drugName': drugName,
      'dosage': dosage,
      'route': route.name,
      'site': site.name,
      'type': type.name,
      'administeredDate': Timestamp.fromDate(administeredDate),
      'administeredBy': administeredBy,
      'location': location,
      'lotNumber': lotNumber,
      'batchNumber': batchNumber,
      'reaction': reaction?.name,
      'reactionNotes': reactionNotes,
      'linkedProcedureId': linkedProcedureId,
      'linkedDialysisSessionId': linkedDialysisSessionId,
      'notes': notes,
      'timestamp': timestamp,
    };
  }

  InjectionModel copyWith({
    String? id,
    String? drugName,
    String? dosage,
    InjectionRoute? route,
    InjectionSite? site,
    InjectionType? type,
    DateTime? administeredDate,
    String? administeredBy,
    String? location,
    String? lotNumber,
    String? batchNumber,
    InjectionReaction? reaction,
    String? reactionNotes,
    String? linkedProcedureId,
    String? linkedDialysisSessionId,
    String? notes,
    Timestamp? timestamp,
    bool? isPendingSync,
  }) {
    return InjectionModel(
      id: id ?? this.id,
      drugName: drugName ?? this.drugName,
      dosage: dosage ?? this.dosage,
      route: route ?? this.route,
      site: site ?? this.site,
      type: type ?? this.type,
      administeredDate: administeredDate ?? this.administeredDate,
      administeredBy: administeredBy ?? this.administeredBy,
      location: location ?? this.location,
      lotNumber: lotNumber ?? this.lotNumber,
      batchNumber: batchNumber ?? this.batchNumber,
      reaction: reaction ?? this.reaction,
      reactionNotes: reactionNotes ?? this.reactionNotes,
      linkedProcedureId: linkedProcedureId ?? this.linkedProcedureId,
      linkedDialysisSessionId:
          linkedDialysisSessionId ?? this.linkedDialysisSessionId,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'InjectionModel(id: $id, drug: $drugName, dosage: $dosage, route: ${route.abbreviation}, date: $administeredDate)';
  }
}
