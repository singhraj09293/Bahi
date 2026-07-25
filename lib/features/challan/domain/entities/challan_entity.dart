import 'package:challan_app/features/challan/data/models/challan_item.dart';
import 'package:challan_app/features/challan/data/models/workers_assignment.dart';

class Challan {
  final String workerid;
  final String challanNo;
  final DateTime date;
  final String workersNames;
  final int totalPiece;
  final String classification;
  final String isReady;
  final bool isDelivered;
  final DateTime? deliveryDate;
  final DateTime? lotCameDate;
  final List<String> garmentTypes;
  final String sethName;
  final String design;
  final String designer;
  final List<WorkerAssignment> assignments;

  const Challan({
    required this.challanNo,
    required this.date,
    required this.workersNames,
    required this.totalPiece,
    required this.classification,
    required this.isReady,
    required this.isDelivered,
    this.deliveryDate,
    required this.workerid,
    this.lotCameDate,
    required this.garmentTypes,
    required this.sethName,
    required this.design,
    required this.designer,
     required this.assignments,
  });
}
